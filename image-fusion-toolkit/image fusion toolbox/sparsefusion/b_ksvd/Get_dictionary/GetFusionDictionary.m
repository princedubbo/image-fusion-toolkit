clear all;
close all;
imageName='c03';
I1=imread(strcat(imageName,'_1.tif'));
I2=imread(strcat(imageName,'_2.tif'));
figure;
imshow(I1);
title('source image1');
figure;
imshow(I2);
title('source image2');
blkSize=[8,8];%可以自己修改对应的patch大小
I1=double(I1);
I2=double(I2);
Y=cmb2image_seq(I1,I2,blkSize);
%% 选择训练样本，当样本过多的时候，随机选择10000个样本出来
if size(Y,2)>20000
    randd=randperm(size(Y,2));
    randd=randd(1:20000);
    Y=Y(:,randd);
end

%% Create Dictionary with training signals: 
N = blkSize(1)^2;      % number of pixels in patch
s = 4; %dimension of blocks
k = 4;
K = 4*N;           %Number of columns in dictionary
max_it = 50;       %Nr of iterations for the algorithm to converge. 


%% dictionary learning
[D1,d1]=ksvdTrainD(Y,K,4,max_it);
save(strcat(imageName,'_Ksvd_dictionary','_s',...
    num2str(1),'_k',num2str(4)),'D1','d1');

[D2,d2] = BksvdTrainD(Y,K,k,s,max_it);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_Bksvd_dictionary','_s',...
    num2str(s),'_k',num2str(k)),'D2','d2');


[D3,d3] =BksvdSacTrainD(Y,K,k,s,max_it);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_BksvdSAC_dictionary','_s',...
    num2str(s),'_k',num2str(k)),'D3','d3');


[D4,d4] = BksvdClusterTrainD(Y,K,k,s,max_it);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_BksvdCluster_dictionary','_s',...
    num2str(s),'_k',num2str(k)),'D4','d4');
% d0=1:K;
% D2 = randn(size(Y,1),K);%64*256
% 
% %初始化字典D。。。
% D2 = D2 ./  repmat(sqrt(sum(D2.^2)),size(Y,1),1);
% 
%  [X, C2s] = simult_sparse_coding(D2,Y,d0,k*s,1);
