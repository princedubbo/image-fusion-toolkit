function [ Q0] = Q0w( x,y,n)
%% by zoe 2012/1/3 email:dreamcather1986@163.com
% �����СΪn�����صĴ����ڵ�Q0 [-1,1]
% ���룺
%  x=(x1,x2,.....xn)��Դͼ���ڸô����ڵ�����ֵ
%  y=(y1,y2,.....yn)���ں�ͼ���ڸô����ڵ�����ֵ
x_mean=mean(x); %x�ľ�ֵ
y_mean=mean(y); %y�ľ�ֵ
x_var=var(x);  %x�ķ���
y_var=var(y);  %y�ķ���

covxy=0;
for i=1:n
    covxy=covxy+(x(i)-x_mean)*(y(i)-y_mean);
end
covxy=covxy/(n-1); %����x,y��Э����

if (x_mean^2+y_mean^2)*(x_var+y_var)==0
    Q0=4*covxy*x_mean*y_mean/((x_mean^2+y_mean^2)*(x_var+y_var)+1);
else

Q0= 4*covxy*x_mean*y_mean/((x_mean^2+y_mean^2)*(x_var+y_var));


end

