function [ Qabf ] = fqiQ( a,b,f,blk_size )
%% by zoe 2012/1/3  email:dreamcather1986@163.com
%compute the quality index Q(a,b,f)
% ���룺 Դͼ��a,b
%       �ں�ͼ��f
%        �ֿ��Сble_size
%����� quality index Qabf
%���磺 Qabf=fqiQ('1.bmp','2.bmp',8)
% x1=imread(a);
% x2=imread(b);
% f=imread(f);
x1=double(a);
x2=double(b);
f=double(f);

[m,n]=size(f);
N=m*n;
B=blk_size;
% ��ͼ��ֿ飬��ͼ��ֳ�B*B��С�Ŀ飬Ȼ��ÿ������Ϊ B^2 *1������
matx1=rang_block(x1,B);
matx2=rang_block(x2,B);
matf=rang_block(f,B);
%�������п�� quality index
C=m*n/(B*B); %�ܹ���C��
if C~=length(matx1(1,:)) %���ֿ��Ƿ����
    sprintf('�ֿ����');
end
valueall=[];
q=0; %������ʼֵ
for i=1:C
    q0a=Q0w(matx1(:,i),matf(:,i),B*B);
    q0b=Q0w(matx2(:,i),matf(:,i),B*B);
    saw=var(matx1(:,i));
    sbw=var(matx2(:,i));
    
  if(saw==0&&sbw==0)
        rw=0.5;
  else
        rw=saw/(saw+sbw);
   end
        
value=rw*q0a+(1-rw)*q0b;
if(value>1||value<-1)
    sprintf('��ֵ�ֵ������');
end
 valueall=[valueall value];   

q=q+value;
end
Qabf=q/C; 



end

