function S = shannon(img) 


I=img;
%I=double(I);
[C,R]=size(I);      %��ͼ��Ĺ��
Img_size=C*R;       %ͼ�����ص���ܸ���
L=256;              %ͼ��ĻҶȼ�
H_img=0;
nk=zeros(L,1);
for i=1:C
    for j=1:R
        Img_level=round(I(i,j))+1;                %��ȡͼ��ĻҶȼ�           
        nk(Img_level)=nk(Img_level)+1;      %ͳ��ÿ���Ҷȼ����صĵ���
    end
end
for k=1:L
    Ps(k)=nk(k)/Img_size;                  %����ÿһ���Ҷȼ����ص���ռ�ĸ���
    if Ps(k)~=0;                           %ȥ������Ϊ0�����ص�
    H_img=-Ps(k)*log2(Ps(k))+H_img;        %����ֵ�Ĺ�ʽ
    S=H_img;
    end
end
