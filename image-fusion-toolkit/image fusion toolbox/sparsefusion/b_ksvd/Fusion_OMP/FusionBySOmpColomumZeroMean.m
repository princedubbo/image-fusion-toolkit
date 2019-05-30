function [imagef]=FusionBySOmpColomumZeroMean(D,k,Y1,Y2,imagesize)
%% D1���ֵ䣬d1�Ƿ�����Ϣ��k��ϡ��ȣ�Y1��Y2��Դͼ��1��Դͼ��2
%  imagesize��Դͼ��Ĵ�С
Y1mean=mean(Y1);
Y2mean=mean(Y2);
% e=zeros(size(Y1mean));
% f=zeros(size(Y1mean));
Y1=bsxfun(@minus,Y1,Y1mean);
Y2=bsxfun(@minus,Y2,Y2mean);
[A1, A2]=SOMP(D,Y1,Y2,k);
[numatoms,numlie]=size(A1);
Afbm=zeros(numatoms,numlie);
A1i=abs(A1);
A2i=abs(A2);
a1=sum(A1i);
a2=sum(A2i);
Afbm(:,a1>=a2)=A1(:,a1>=a2);
Afbm(:,a1<a2)=A2(:,a1<a2);
df=D*Afbm;
Y1mean=repmat(Y1mean,size(Y1,1),1);
Y2mean=repmat(Y2mean,size(Y2,1),1);
df(:,a1>=a2)=df(:,a1>=a2)+Y1mean(:,a1>=a2);
df(:,a1<a2)=df(:,a1<a2)+Y2mean(:,a1<a2);
imagef=patch2image(df,[8,8],imagesize);
imagef=uint8(imagef);