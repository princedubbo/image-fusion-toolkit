function [ mat ] = rang_block( mtrx,blk_size )
%% by zoe 2012/1/3  email:dreamcather1986@163.com
%������mtrx�ֳ�blk_size��С�Ŀ�
%  ����ֿ����mat��ÿһ�ж���һ�����ֵ

[m,n]=size(mtrx);
B=blk_size;
C1=m/B; %���ж��ٿ�
C2=n/B; %���ж��ٿ�
xmat=mat2cell(mtrx,B*ones(1,C1),B*ones(1,C2)); %��x1����ֳ�B*B��С��
restx=zeros(B*B,C1*C2); %��˳��洢�� B^2*1024����������

col=1;
for i=1:C1
    for j=1:C2
        temp=reshape(xmat{i,j},B*B,1);
        restx(:,col)=temp;
       col=col+1;
    end
end

mat=restx;

end

