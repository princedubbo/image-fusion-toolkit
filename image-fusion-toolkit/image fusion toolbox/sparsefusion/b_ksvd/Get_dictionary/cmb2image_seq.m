function Data=cmb2image_seq(I1,I2,patchsize)
%�ú�������������ͼ��ֱ���sliding window��patch��С��pachsize���õ����Ծ���
%���յ�һ��ͼ��͵ڶ���ͼ����ͬλ�õ�patch��������λ��
B1=im2col(I1,patchsize,'sliding');
B2=im2col(I2,patchsize,'sliding');
[m,n]=size(B1);
Data=zeros(m,2*n);
j=1;
for i=1:2:2*n
    Data(:,i)=B1(:,j);
    Data(:,i+1)=B2(:,j);
    j=j+1;
end

