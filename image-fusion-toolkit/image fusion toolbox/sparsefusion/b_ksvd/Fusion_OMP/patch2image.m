function image=patch2image(d,patchsize,imsize)
%d�Ƿֳ�patch��ɵľ���pachsize��ÿ��patch�Ĵ�С��imsize�Ĵ�С��
N1=imsize(1);%Դͼ�������
N2=imsize(2);%Դͼ�������
m=patchsize(1);%patch���к��е���Ŀ
R=zeros(N1,N2);%��¼Դͼ����ÿ�����ص���ֵĴ���
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
