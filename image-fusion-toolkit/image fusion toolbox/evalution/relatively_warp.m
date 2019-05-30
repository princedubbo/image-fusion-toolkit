%����ͼ�����Ա�׼��
function f=relatively_warp(h1,h2)
%DREL return relatively warp(��Ա�׼��)       ����ͼ�����Ա�׼��
%input must be a imagehandle                  ����ͼ����
%image fusion evaluate parameter              ͼ���ں����۲���
%    example
%      ��׼ͼ��   h1
%      �ںϺ�ͼ�� h2
%      f=DREL(h1��h2);
%��Ա�׼��ԽС���ͱ�ʾͼ���ںϵ�Ч��Խ��
s=size(size(h1));%�ж��ǻҶ�ͼ����RGB
if s(2)==3;
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
u1=(sum(G1(:)))/(m1*n1);
u2=(sum(G2(:)))/(m2*n2);
c1=0;
c2=0;
for i=1:m1
    for j=1:n1
        w1=G1(i,j)-u1;
        w2=G2(i,j)-u2;
        c1=c1+w1^2;
        c2=c2+w2^2;
    end
end
f1=sqrt(c1/(m1*n1));
f2=sqrt(c2/(m2*n2));
f=(f1-f2)/f1;