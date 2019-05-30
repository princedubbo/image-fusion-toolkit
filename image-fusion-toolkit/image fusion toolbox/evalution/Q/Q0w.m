function [ Q0] = Q0w( x,y,n)
%% by zoe 2012/1/3 email:dreamcather1986@163.com
% 计算大小为n个像素的窗口内的Q0 [-1,1]
% 输入：
%  x=(x1,x2,.....xn)是源图像在该窗口内的像素值
%  y=(y1,y2,.....yn)是融合图像在该窗口内的像素值
x_mean=mean(x); %x的均值
y_mean=mean(y); %y的均值
x_var=var(x);  %x的方差
y_var=var(y);  %y的方差

covxy=0;
for i=1:n
    covxy=covxy+(x(i)-x_mean)*(y(i)-y_mean);
end
covxy=covxy/(n-1); %计算x,y的协方差

if (x_mean^2+y_mean^2)*(x_var+y_var)==0
    Q0=4*covxy*x_mean*y_mean/((x_mean^2+y_mean^2)*(x_var+y_var)+1);
else

Q0= 4*covxy*x_mean*y_mean/((x_mean^2+y_mean^2)*(x_var+y_var));


end

