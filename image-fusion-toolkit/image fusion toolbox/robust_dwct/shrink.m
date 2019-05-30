function y = shrink(x)
%窗口大小应该与融合窗口一致
win  = 7;
winf = ones(1,win)/win;
%分解层数
J = 6;
%阈值
T= 0.8;
%边缘扩展
L = length(x); % length of the original image.
N = L+2^J;     % length after extension.
x = symextend(x,2^(J-1));

%双树复小波分解,l是低频系数，h是高频系数
[l1,h1] = dtwavexfm2(x,J,'near_sym_b','qshift_b');
[l2,h2] = dtwavexfm2(t,J,'near_sym_b','qshift_b');

h= zeros(size(h1));

%低频融合
l = 0.5*(l1+l2);

%噪声方差估计
tmp1 = [h1{1,1}(:,:,2) h1{1,1}(:,:,5)];
tmp2 = [h2{1,1}(:,:,2) h2{1,1}(:,:,5)];
Nsig1 = median(abs(tmp1(:)))/0.83;
Nsig2 = median(abs(tmp2(:)))/0.83;

for scale = 1:J-1
    for dir = 1:6
        
   %估计噪声系数方差
    Y_coef1 =h1{scale}(:,:,dir);
    Y_coef_p1=h1{scale+1}(:,:,dir);
    Y_coef2 =h2{scale}(:,:,dir);
    Y_coef_p2=h2{scale+1}(:,:,dir);
   %扩展父系数
    Y_coef_p1  = expand(Y_coef_p1);
    Y_coef_p2  = expand(Y_coef_p2);
   
    Wsig1 = conv2(winf,winf,abs(Y_coef1).^2,'same');
    Ssig1 = sqrt(max(Wsig1-Nsig1.^2,eps));
    Wsig2 = conv2(winf,winf,abs(Y_coef2).^2,'same');
    Ssig2 = sqrt(max(Wsig2-Nsig2.^2,eps));
    
    
    %阈值
    T1 = sqrt(3)*Nsig1^2./Ssig1;
     T2 = sqrt(3)*Nsig2^2./Ssig2;
    
    %双变量收缩
    A1 = bishrinkage(Y_coef1,Y_coef_p1,T1);
    A2 = bishrinkage(Y_coef2,Y_coef_p2,T2);
    %融合
     %每一层操作
       [nv,nh,~] = size(h1{scale}(:,:,dir));
      
        nexp = nv*nh;           % number of coefficients considered
        M = win^2;  %prod数组元素的乘积
        X = zeros(nexp,M);
        Y= zeros(nexp,M);
        
        Ly = (win-1)/2;
        Lx = Ly;
        %取出所有窗口
        %X Y 中每一行为一个窗口内容
        n = 0;
        for ny = -Ly:Ly,	% spatial neighbors
            for nx = -Lx:Lx,
                n = n + 1;  
                f1= circshift(h1{scale}{dir},[ny nx]);
                %circshift平移矩阵
                X(:,n) = f1(:);
                %A的每一行就变成每个窗口的内容
                 %第一行对应的是(1,1)的窗口邻域，依次是第一列，第二列...
                f2 = circshift(h2{scale}{dir},[ny nx]);
                Y(:,n) = f2(:);
            end
        end
        
        mu_x = repmat(mean(X,2),1,M);
        mu_y = repmat(mean(Y,2),1,M);
        
        X_m1 = mean(abs(X - mu_x),2); Y_m1 = mean(abs(Y - mu_y),2);
        X_m2 = mean((X - mu_x).^2,2); Y_m2 = mean((Y - mu_y).^2,2);

        x = 0.05 * (1:100)';
        f = [2.4663e-05 0.004612 0.026349 0.062937 0.10606 0.15013 0.19234 0.23155 ...
            0.26742 0.3 0.32951 0.35624 0.38047 0.40247 0.42251 0.44079 0.45753 ...
            0.47287 0.48699 0.5 0.51202 0.52316 0.53349 0.5431 0.55206 0.56042 ...
            0.56823 0.57556 0.58243 0.58888 0.59495 0.60068 0.60607 0.61118 ...
            0.616 0.62057 0.6249 0.62901 0.63291 0.63662 0.64015 0.64352 ...
            0.64672 0.64978 0.65271 0.6555 0.65817 0.66073 0.66317 0.66552 ...
            0.66777 0.66993 0.672 0.674 0.67591 0.67775 0.67953 0.68123 0.68288 ...
            0.68446 0.68599 0.68747 0.68889 0.69026 0.69159 0.69287 0.69412 ...
            0.69532 0.69648 0.6976 0.69869 0.69974 0.70076 0.70175 0.70271 ...
            0.70365 0.70455 0.70543 0.70628 0.70711 0.70791 0.70869 0.70945 ...
            0.71019 0.71091 0.71161 0.71229 0.71295 0.71359 0.71422 0.71483 ...
            0.71543 0.71601 0.71657 0.71712 0.71766 0.71819 0.7187 0.7192 0.71968];
        
        val = X_m1.^2 ./ X_m2;     valy = Y_m1.^2 ./ Y_m2;
        X_alpha = zeros(nexp,1);   Y_alpha = zeros(nexp,1);
        X_alpha(val<f(1)) = 0.05;  Y_alpha(valy<f(1)) = 0.05;
        X_alpha(val>f(end)) = 5;   Y_alpha(valy>f(end)) = 5;
        idx = val>=f(1)&val<=f(end);
        idxy = valy>=f(1)&valy<=f(end);
        tmp = val(idx);
        tmpy = valy(idxy);
        tmp = interp1(f, x, tmp);
        tmpy = interp1(f, x, tmpy);
        
        X_alpha(idx) = tmp;
        Y_alpha(idxy) = tmpy;

        beta_x = X_m1 .* gamma(1./X_alpha) ./ gamma(2./X_alpha);
        beta_y = Y_m1 .* gamma(1./Y_alpha) ./ gamma(2./Y_alpha);
        beta_xy = zeros(nexp,1);
        
        for i = 1:nexp
            beta_xy(i) = min(min(cov(X(i,:),Y(i,:))));%取协方差的最小值
        end
  
        M = (2*beta_xy.*A1(:).*A2(:)+c) ./(beta_x.^2.*A1(:).^2+beta_y.^2.*A2(:).^2+c);
        
        M(M>1) = 1;
        M(M<0) = 0;
        
        Wmin = zeros(nexp,1);
        Wmin(M>T) = (1-(1-M(M>T))./(1-T))./2;
        Wmax = 1 - Wmin;
        Wx = Wmin;
        Wy = Wmax;
        Wx(beta_x.^2.*A1(:).^2> beta_y.^2.*A2(:).^2) = Wmax(beta_x.^2.*A1(:).^2> beta_y.^2.*A2(:).^2);
        Wy(beta_x.^2.*A1(:).^2> beta_y.^2.*A2(:).^2) = Wmin(beta_x.^2.*A1(:).^2> beta_y.^2.*A2(:).^2);
        Wx=reshape(Wx,nv,nh);
        Wy=reshape(Wy,nv,nh);
    
        h{scale}(:,:,dir) = Wx.*h1{scale}(:,:,dir) + Wy.*h2{scale}(:,:,dir);
    end
end

%逆变换
y = dtwaveifm2(l,h,'near_sym_b','qshift_b');
ind = 2^(J-1)+1:2^(J-1)+L;
y = y(ind,ind);


