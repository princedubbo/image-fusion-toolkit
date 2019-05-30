function [ qedf ] = efq( a,b,f,blk_size )
%% by zoe 2012/1/3 email:dreamcather1986@163.com
%compute the edge-dependent fusion quality index 
% ���룺 Դͼ�� a,b
%       �ں�ͼ�� f
%       �ֿ��Сble_size
%����� quality index Qabf
%���磺 qedf=efqQ('1.bmp','2.bmp',8)

apl=1;
% x1=imread(a);
x1=a;
x1=edge(x1,'canny'); % edge image of a
% imwrite(x1,'edg1.bmp');
% x2=imread(b);
x2=b;
x2=edge(x2,'canny');
% imwrite(x2,'edg2.bmp');
% f2=imread(f);
f2=f;
f2=edge(f2,'canny');
% imwrite(f2,'edgf.bmp');

qedf=wfq( a,b,f,blk_size )*[wfq(x1,x2,f2,blk_size)]^apl;



end

