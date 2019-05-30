function [ mat ] = rang_block( mtrx,blk_size )
%% by zoe 2012/1/3  email:dreamcather1986@163.com
%将矩阵mtrx分成blk_size大小的块
%  输出分块矩阵mat：每一列都是一个块的值

[m,n]=size(mtrx);
B=blk_size;
C1=m/B; %行有多少块
C2=n/B; %列有多少块
xmat=mat2cell(mtrx,B*ones(1,C1),B*ones(1,C2)); %把x1矩阵分成B*B的小块
restx=zeros(B*B,C1*C2); %按顺序存储在 B^2*1024的向量里面

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

