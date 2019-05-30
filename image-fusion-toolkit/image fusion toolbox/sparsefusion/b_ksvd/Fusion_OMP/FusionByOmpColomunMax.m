function [imagef]=FusionByOmpColomunMax(D1,d1,k,Y1,Y2,imagesize)
%% D1���ֵ䣬d1�Ƿ�����Ϣ��k��ϡ��ȣ�Y1��Y2��Դͼ��1��Դͼ��2
%  imagesize��Դͼ��Ĵ�С
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
imagef=patch2image(df,[8,8],imagesize);
imagef=uint8(imagef);
