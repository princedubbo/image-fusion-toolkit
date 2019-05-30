function image=patch2image(d,patchsize,imsize)
%d是分成patch组成的矩阵，pachsize是每个patch的大小，imsize的大小；
N1=imsize(1);%源图像的行数
N2=imsize(2);%源图像的列数
m=patchsize(1);%patch的行和列的数目
R=zeros(N1,N2);%记录源图像中每个像素点出现的次数
image=zeros(N1,N2);%
count=1;
for i=1:N2-m+1
    for j=1:N1-m+1
        image(j:j+m-1,i:i+m-1)=image(j:j+m-1,i:i+m-1)+reshape(d(:,count),[m,m]);
        R(j:j+m-1,i:i+m-1)=R(j:j+m-1,i:i+m-1)+ones(m);
        count=count+1;
    end
end
image=image./R;
