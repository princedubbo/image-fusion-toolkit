clear all;
close all;
imageName='a01';
I1=imread(strcat(imageName,'_1.tif'));
I2=imread(strcat(imageName,'_2.tif'));
figure;
imshow(I1);
title('source image1');
figure;
imshow(I2);
title('source image2');
patchsize=[8,8];%�����Լ��޸Ķ�Ӧ��patch��С
I1=double(I1);
I2=double(I2);
Y1 = im2col(I1,patchsize,'sliding');
%% ѡ��ѵ�������������������ʱ�����ѡ��10000����������
if size(Y1,2)>20000
    randd=randperm(size(Y1,2));
    randd=randd(1:20000);
    Y1=Y1(:,randd);
end

%% 
Y2 = im2col(I2,patchsize,'sliding');
if size(Y2,2)>20000
    randd=randperm(size(Y2,2));
    randd=randd(1:20000);
    Y2=Y2(:,randd);
end

%% Create Dictionary with training signals: 
N = patchsize(1)^2;      % number of pixels in patch
s = 4; %dimension of blocks
k = 8;
K = 4*N;           %Number of columns in dictionary
max_it = 50;       %Nr of iterations for the algorithm to converge. 


%% dictionary learning
[D1,d1]=ksvdTrainD(Y1,K,4,max_it);
save(strcat(imageName,'_Ksvd_dictionary1','_s',...
    num2str(1),'_k',num2str(4)),'D1','d1');


[D2,d2]=ksvdTrainD(Y2,K,4,max_it);
save(strcat(imageName,'_Ksvd_dictionary2','_s',...
    num2str(1),'_k',num2str(4)),'D2','d2');
