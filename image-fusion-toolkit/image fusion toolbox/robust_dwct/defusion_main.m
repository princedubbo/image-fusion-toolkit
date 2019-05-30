function [X] =defusion_main(a,b,sigma,win,J)
%a,b为输入图像
%sigma为噪声大小
%win为窗口大小
%J为分解尺度

addpath(genpath(pwd));
in = double(a);
vi = double(b);

ss = size(in);

%%
%%%查表
b1=0.1:0.001:10.05;
fun1=@(x,b1)exp(-sqrt(3).*x).*x.^(b1+1);
fun2=@(x,b1)abs(cos(x)).^b1;
fun3=@(x,b1)abs(sin(x)).^b1;
jf1 =  quadv(@(x)fun1(x,b1),0,150);
jf2 =  quadv(@(x)fun2(x,b1),0,2*pi);
%jf3 =  quadv(@(x)fun3(x,b1),0,2*pi);

tab=[b1;jf1;jf2];

%%

% Noise variance
sigma1 =sigma;
sigma2 = sigma;
n1 = sigma1*randn(ss);
n2 = sigma2*randn(ss);
% Add noise
s = in + n1;
t = vi + n1;

%窗口大小应该与融合窗口一致
%win  = 5;
%c=0.009;
winf = ones(1,win)/win;
wind =1/65* [1 2 3 2 1;2 3 4 3 2;3 4 5 4 3;2 3 4 3 2;1 2 3 2 1];

%分解层数
%J = 5;
% %阈值
T= 0.8;

%边缘扩展
L = length(s); % length of the original image.
N = L+2^J;     % length after extension.

s = symextend(s,2^(J-1));
t = symextend(t,2^(J-1));

%双树复小波分解,l是低频系数，h是高频系数
[l1,h1] = dtwavexfm2(s,J,'near_sym_b','qshift_b');
[l2,h2] = dtwavexfm2(t,J,'near_sym_b','qshift_b');

%低频融合
sl1 =conv2(abs(l1).^2,wind,'same');
sl2 = conv2(abs(l2).^2,wind,'same');

%均值
av1 = conv2(abs(l1),wind,'same');
av2 =conv2(abs(l2),wind,'same');
ss1 =sqrt( conv2((abs(l1)-av1).^2,wind,'same'));
ss2 =sqrt( conv2((abs(l2)-av2).^2,wind,'same'));

l = 0.5*(ss1.^1.2./(ss1.^1.2+ss2.^1.2).*l1+ss2.^1.2./(ss1.^1.2+ss2.^1.2).*l2...
    +sl1./(sl1+sl2).*l1+sl2./(sl1+sl2).*l2);

%噪声方差估计
tmp1 = [h1{1,1}(:,:,2) h1{1,1}(:,:,5)];
tmp2 = [h2{1,1}(:,:,2) h2{1,1}(:,:,5)];
Nsig1 = median(abs(tmp1(:)))/0.5749;
Nsig2 = median(abs(tmp2(:)))/0.5749;
% Nsig1 = median(abs(tmp1(:)))/0.83;
% Nsig2 = median(abs(tmp2(:)))/0.83;

for scale = 1:J-1
    for dir = 1:6
        
        %估计含噪系数方差
        
        y_a =h1{scale}(:,:,dir);
        y_ap=h1{scale+1}(:,:,dir);
        
        
        y_b =h2{scale}(:,:,dir);
        y_bp=h2{scale+1}(:,:,dir);
        
        
        %扩展父系数
        y_ap  = expand(y_ap);
        y_bp  = expand(y_bp);
        
        %一阶绝对距
        ma1 = conv2(winf,winf,abs(y_a),'same');
        mb1 = conv2(winf,winf,abs(y_b),'same');
        
        %含噪2阶绝对距
        ma20 = conv2(winf,winf,abs(y_a).^2,'same');
        mb20 = conv2(winf,winf,abs(y_b).^2,'same');
        
        %纯净二阶距
        ma2 = max(ma20-sigma1.^2,eps);
        mb2 = max(mb20-sigma1.^2,eps);
        
        
        %阈值
        T1 = sqrt(3)*sigma1^2./sqrt(ma2);
        T2 = sqrt(3)*sigma1^2./sqrt(mb2);
        
        % %     %双变量收缩
        A1 = bishrinkage(y_a,y_ap,T1);
        A2 = bishrinkage(y_b,y_bp,T2);
        
        
        %融合
        %每一层操作
        [nv,nh,~] = size(h1{scale}(:,:,dir));
        
        %%%核心改变的地方
        k1 = ma1./sqrt(ma2);
        k2 = mb1./sqrt(mb2);
        
        %beta
        [b1,ja1,ja2]=equation16(k1,tab);
        [b2,jb1,jb2]=equation16(k2,tab);
        b1=reshape(b1,nv,nh);
        b1=reshape(b1,nv,nh);
        b2=reshape(b2,nv,nh);
        ja1=reshape(ja1,nv,nh);
        ja2=reshape(ja2,nv,nh);
        jb1=reshape(jb1,nv,nh);
        jb2=reshape(jb2,nv,nh);
        
        %alpha！！显著度！！
        a1 = ma1.* gamma(1./b1) ./ gamma(2./b1);
        a2 = mb1.* gamma(1./b2) ./ gamma(2./b2);
        
        fc1 = sqrt(ma2);
        fc2 = sqrt(mb2);
        
        
        kd =abs(log(6.*a1.*a2.*gamma(1./b1).*gamma(1./b2)./(fc1.*fc2.*pi.*b1.*b2))-2+...
            3./(2*pi)* (a1.^(-b1).*ja1.*ja2.*abs(fc1).^b1+a2.^(-b2).*jb1.*jb2.*abs(fc2).^b2));
        
        Ha = 1./b1 -log(b1./(2.*a1.*gamma(1./b1)));
        Hb = 1./b2 -log(b2./(2.*a2.*gamma(1./b2)));
%         
%         kd1= log(b1.*a2.*gamma(1./b2)./(b2.*a1.*gamma(1./b1)))+ (a1./a2).^b2.*gamma((b2+1)./b1)./gamma(1./b1)-1./b1;
%         kd2= log(b2.*a1.*gamma(1./b1)./(b1.*a2.*gamma(1./b2)))+ (a2./a1).^b1.*gamma((b1+1)./b2)./gamma(1./b2)-1./b2;
%         
%         %??
        XX = b1/(2*a1.*gamma(1./b1)).*exp(-(abs(k1)./a1).^b1);
        YY = b2/(2*a2.*gamma(1./b2)).*exp(-(abs(k2)./a2).^b2);
        X2 = (b1.*(XX - 1./b1)).^2;
        Y2 = (b2.*(YY - 1./b2)).^2;
        S1 = conv2(X2,ones(win),'same');
        S2 = conv2(Y2,ones(win),'same');
        kd = sqrt(S1+S2);
        kd1 = S1./kd;
        kd2 = S2./kd;
%         kd1 = kd;
%         kd2 = kd;
        %End
        %核心匹配度
        %  M =(2.*kd.*A1.*A2+eps)./(A1.^2.*Ha+A2.^2.*Hb+eps);
        M =(2.*kd+eps)./(Ha+Hb+eps);
        P=M;
        M(M>1)=0;
        %剔除奇异值
        max1 = spfilt(M, 'max', 5, 5);
        P(P>max1)=max1(P>max1);
        
        Sa=kd1.*A1.^2;
        Sb=kd2.*A2.^2;
        
        S1=Ha.*A1.^2;
        S2=Ha.*A2.^2;
        
        T=0.8;
        T3=0.2;
        Wmin1 = zeros(nv,nh);
        Wmin1(P>T) = (1-(1-P(P>T))./(1-T.*(A1(P>T)+A2(P>T))))./2;
        Wmax1 = 1 - Wmin1;
        Wx = Wmin1;
        Wy = Wmax1;
        Wx(S1> S2) = Wmax1(S1> S2);
        Wy(S1> S2) = Wmin1(S1> S2);
        
        W1 = zeros(nv,nh);
        W1(Sa>Sb) = 1;
        W2= 1 - W1;
        
        ac=W1.*sqrt(1+(P).^2);
        bc=W2.*sqrt(1+(P).^2);
        
        Wx(P<T3) = ac(P<T3);
        Wy(P<T3) = bc(P<T3);
        
        %          Wx(A1==0) = 0;
        %          Wy(A2==0) = 0;
        
        hf{J,1}(:,:,dir)=0.5*(h1{J}(:,:,dir)+h2{J}(:,:,dir));
        hf{scale,1}(:,:,dir) =A1.*Wx .*h1{scale}(:,:,dir) +A2.*Wy.*h2{scale}(:,:,dir);
        
        
    end
end

%逆变换
X = dtwaveifm2(l,hf,'near_sym_b','qshift_b');
ind = 2^(J-1)+1:2^(J-1)+L;
X = X(ind,ind);
