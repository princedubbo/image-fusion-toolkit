function Data=cmb2image_seq(I1,I2,patchsize)
%该函数把两幅输入图像分别用sliding window（patch大小是pachsize）得到各自矩阵
%按照第一幅图像和第二幅图像相同位置的patch放在相邻位置
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

