clear all;
close all;
imageName='c03';
image1=imread(strcat(imageName,'_1.tif'));
image2=imread(strcat(imageName,'_2.tif'));
blkSize=[8,8];%可以自己修改对应的patch大小
figure;
imshow(image1);
title('source image 1');
figure;
imshow(image2);
title('source image 2');
[N1,N2]=size(image);
image1=double(image1);
image2=double(image2);

%% Create Dictionary with training signals: 
N = blkSize(1)^2;      % number of pixels in patch
s = 4; %dimension of blocks
k = 4;
K = 4*N;           %Number of columns in dictionary
max_it = 50;       %Nr of iterations for the algorithm to converge. 
%% 选择训练样本，当样本过多的时候，随机选择10000个样本出来
Y1 = im2col(image1,blkSize,'sliding');
Y2 = im2col(image2,blkSize,'sliding');
if size(Y1,2)>10000
    rand1=randperm(size(Y1,2));
    rand2=randperm(size(Y2,2));
    rand1=rand1(1:10000);
    rand2=rand2(1:10000);
    Y1=Y1(:,rand1);
    Y2=Y2(:,rand1);
end
Y=cat(2,Y1,Y2);
%% train dictionaries
%% ksvd dictionary
[D1,d1] = ksvdTrainD(Y,K,10,max_it);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_ksvd_dictionary'),'D1','d1');

% Bksvd dictionary
[D2,d2] = BksvdTrainD(Y,K,k,s,max_it);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_Bksvd_dictionary','_s',...
    num2str(s),'_k',num2str(k)),'D2','d2');

%% Bksvd+Sac dictionary
[D3,d3] =BksvdSacTrainD(Y,K,k,s,max_it);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_BksvdSAC_dictionary','_s',...
    num2str(s),'_k',num2str(k)),'D3','d3');
