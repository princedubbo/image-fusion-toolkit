%����ͼ��Ľ�����

function f=cross_entropy(h1,h2)
%CERF return CERF(������)               ����ͼ��Ľ�����
%input must be a imagehandle            ����ͼ����
%image fusion evaluate parameter        ͼ���ں����۲���
%    example
%      ��׼ͼ��   h1
%      �ںϺ�ͼ�� h2
%      f=Hce(h1��h2);
%������ԽС���ͱ�ʾͼ���Ĳ���ԽС
% h1=('jizheng.img');
% h2=('chengji.img');
s=size(size(h1));
if s(2)==3;%�ж��ǻҶ�ͼ����RGB
f1=rgb2gray(h1);
f2=rgb2gray(h2);
else
    f1=h1;
    f2=h2;
end 
G1=double(f1);
G2=double(f2);
[m1,n1]=size(G1);
[m2,n2]=size(G2);
m2=m1;
n2=n1;
X1=zeros(1,256);
X2=zeros(1,256);
result=0;
%ͳ����ͼ���Ҷȼ�����
for i=1:m1
    for j=1:n1
        X1(G1(i,j)+1)=X1(G1(i,j)+1)+1;
        X2(G2(i,j)+1)=X2(G2(i,j)+1)+1;
    end
end
%������ͼ���Ҷȼ����س��ֵĸ���
for k=1:256
    P1(k)=X1(k)/(m1*n1);
    P2(k)=X2(k)/(m1*n1);
    if((P1(k)~=0)&(P2(k)~=0))
        result=P1(k)*log2(P1(k)/P2(k))+result;
    end
end
f=result;

