function [alpha,ja,jb]=equation16(K,tab) 
% K代表图象X的某个统计E(|X|)/var(X),为一个常数
%根据方程（6）求beta值，GGD的形状参数
% 文献《On the Modeling of DCT and Subband Image Data for Compression》求形状参数nu(ν)的程序，根据公式（5）（6）
% 式（5）的ν相当于式（6）F取值为E(|X|)/var(X)时的α
% table is the function about gamma,利用gamma函数根据方程（6）建立Table表格

step=(7.05-0.1)/7000;
a=0.1:step:7.05;  %a代表nu(ν)数组，从0到20，间隔为0.005
Table=gamma(2./a)./sqrt(gamma(1./a).*gamma(3./a));   %Table 是对应alph(α)取值的峰态系数E(|X|)/var(X)值
%Table= log(0.5*a.*sqrt((gamma(0.5))^3.*gamma(3./a)./(gamma(1.5)*(gamma(1./a)).^3)))+0.5-1./a;
I=abs(bsxfun(@minus,Table,K(:)));
%I=Table-K; 
%m=I';
[Imin,p]=min(I,[],2);%imin 每列最小值 p每列最小值的行号
[m,n]=size(K);
ja = zeros(m,n);
jb = zeros(m,n);
for i=1:m
        ja(i,1)=tab(2,p(i,1));
        jb(i,1)=tab(3,p(i,1));   
end
alpha=(p-1)*step;
end