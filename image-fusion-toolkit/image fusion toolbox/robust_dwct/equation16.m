function [alpha,ja,jb]=equation16(K,tab) 
% K����ͼ��X��ĳ��ͳ��E(|X|)/var(X),Ϊһ������
%���ݷ��̣�6����betaֵ��GGD����״����
% ���ס�On the Modeling of DCT and Subband Image Data for Compression������״����nu(��)�ĳ��򣬸��ݹ�ʽ��5����6��
% ʽ��5���Ħ��൱��ʽ��6��FȡֵΪE(|X|)/var(X)ʱ�Ħ�
% table is the function about gamma,����gamma�������ݷ��̣�6������Table���

step=(7.05-0.1)/7000;
a=0.1:step:7.05;  %a����nu(��)���飬��0��20�����Ϊ0.005
Table=gamma(2./a)./sqrt(gamma(1./a).*gamma(3./a));   %Table �Ƕ�Ӧalph(��)ȡֵ�ķ�̬ϵ��E(|X|)/var(X)ֵ
%Table= log(0.5*a.*sqrt((gamma(0.5))^3.*gamma(3./a)./(gamma(1.5)*(gamma(1./a)).^3)))+0.5-1./a;
I=abs(bsxfun(@minus,Table,K(:)));
%I=Table-K; 
%m=I';
[Imin,p]=min(I,[],2);%imin ÿ����Сֵ pÿ����Сֵ���к�
[m,n]=size(K);
ja = zeros(m,n);
jb = zeros(m,n);
for i=1:m
        ja(i,1)=tab(2,p(i,1));
        jb(i,1)=tab(3,p(i,1));   
end
alpha=(p-1)*step;
end