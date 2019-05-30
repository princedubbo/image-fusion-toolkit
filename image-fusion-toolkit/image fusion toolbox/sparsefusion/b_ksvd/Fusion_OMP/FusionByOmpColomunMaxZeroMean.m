function [imagef]=FusionByOmpColomunMaxZeroMean(D1,d1,k,Y1,Y2,imagesize)
%% D1是字典，d1是分组信息，k是稀疏度，Y1，Y2是源图像1和源图像2
%  imagesize是源图像的大小
Y1mean=mean(Y1);
Y2mean=mean(Y2);
Y1=bsxfun(@minus,Y1,Y1mean);
Y2=bsxfun(@minus,Y2,Y2mean);
[A1 ,~] = simult_sparse_coding(D1,Y1,d1,k,1);
[A2 ,~] = simult_sparse_coding(D1,Y2,d1,k,1);
[numatoms,numlie]=size(A1);
Afbm=zeros(numatoms,numlie);
A1i=abs(A1);
A2i=abs(A2);
a1=sum(A1i);
a2=sum(A2i);
Afbm(:,a1>=a2)=A1(:,a1>=a2);
Afbm(:,a1<a2)=A2(:,a1<a2);
df=D1*Afbm;
Y1mean=repmat(Y1mean,size(Y1,1),1);
Y2mean=repmat(Y2mean,size(Y2,1),1);
df(:,a1>=a2)=df(:,a1>=a2)+Y1mean(:,a1>=a2);
df(:,a1<a2)=df(:,a1<a2)+Y2mean(:,a1<a2);
imagef=patch2image(df,[8,8],imagesize);
imagef=uint8(imagef);
