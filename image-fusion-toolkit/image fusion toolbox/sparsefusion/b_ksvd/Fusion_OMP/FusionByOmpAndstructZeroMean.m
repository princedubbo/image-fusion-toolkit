function [imagef]=FusionByOmpAndstructZeroMean(D1,d1,k,Y1,Y2,imagesize)
%% D1是字典，d1是分组信息，k是稀疏度，Y1，Y2是源图像1和源图像2
%  imagesize是源图像的大小
Y1mean=mean(Y1);
Y2mean=mean(Y2);
Y1=bsxfun(@minus,Y1,Y1mean);
Y2=bsxfun(@minus,Y2,Y2mean);
Y1mean=repmat(Y1mean,size(Y1,1),1);
Y2mean=repmat(Y2mean,size(Y2,1),1);
[A1 ,~] = simult_sparse_coding(D1,Y1,d1,k,1);
[A2 ,~] = simult_sparse_coding(D1,Y2,d1,k,1);
[numatoms,numlie]=size(A1);
Afbm=zeros(numatoms,numlie);
m=max(d1);
A1i=abs(A1);
A2i=abs(A2);

for j=1:m
   indices=find(d1==j);
   E1=sum(A1i(indices,:));
   E2=sum(A2i(indices,:));
   Afbm(indices,E1>=E2)=A1(indices,E1>=E2);
   Afbm(indices,E1<E2)=A2(indices,E1<E2);
end
df=D1*Afbm;
df=df+1/2*Y1mean+1/2*Y2mean;
imagef=patch2image(df,[8,8],imagesize);
imagef=uint8(imagef);
