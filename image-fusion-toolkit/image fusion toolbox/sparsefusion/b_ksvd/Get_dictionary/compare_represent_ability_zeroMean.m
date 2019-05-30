clear all;
close all;
imageName='lena';
image=imread(strcat(imageName,'.bmp'));
blkSize=[8,8];%可以自己修改对应的patch大小
figure;
imshow(image);
[N1,N2]=size(image);
image=double(image);

%% Create Dictionary with training signals: 
N = blkSize(1)^2;      % number of pixels in patch
s = 4; %dimension of blocks
k = 4;
K = 4*N;           %Number of columns in dictionary
max_it = 50;       %Nr of iterations for the algorithm to converge. 

%% 训练好了的字典，用load读取
% load('boat_Bksvd_dictionary_s4_k4.mat')
% load('boat_BksvdSAC_dictionary_s4_k4.mat');
% load('boat_BksvdCluster_dictionary_s4_k4.mat');
load(strcat(imageName,'_ksvd_dictionary_s4_k4.mat'))
load(strcat(imageName,'_BksvdCluster_dictionary_s4_k4.mat'));
% load(strcat(imageName,'_BksvdCluster_dictionary_zeromean_scale_s4_k4.mat'));
% load(strcat(imageName,'_BksvdSAC_dictionary_s4_k4.mat'));
% load(strcat(imageName,'_Bksvd_dictionary_s4_k4.mat'));
load(strcat(imageName,'_BksvdCluster_lowSim_dictionary_s4_k4.mat'));
%% 用上述训练得到的字典重构图像
Ys = im2col(image, blkSize, 'sliding');
Ysmean = mean(Ys);
Ys=bsxfun(@minus,Ys,Ysmean);
%% KSVD重构图像
X1= simult_sparse_coding(D1,Ys,d1,k*s,1);
Ycomp4 = D1*X1;
Ycomp4=bsxfun(@plus,Ycomp4,Ysmean);
ima4=patch2image(Ycomp4,blkSize,size(image));
ima_re=uint8(ima4);
figure;
imshow(ima_re);
save(strcat(imageName,'_ksvd_representation','_s',...
    num2str(s),'_k',num2str(k)),'X1');
title('KSVD重构得到的图像');
% 保存对应的稀疏表示系数用来分析，稀疏表示系数是否拥有什么规律
imwrite(ima_re,strcat(imageName,'rec_by_KSVD',...
    '_s',num2str(s),'_k',num2str(k),'.bmp'));
diff_Ksvd_Original=image-ima4;
val_Cluster_lowSim_Original=sum(sum(abs(diff_Ksvd_Original)))

%% BKSVD+SAC重构图像
% X3 = simult_sparse_coding(D3,Ys,d3,k,1);
% Ycomp3 = D3*X3;
% ima1=patch2image(Ycomp3,blkSize,size(image));
% ima_re=uint8(ima1);
% save(strcat(imageName,'_BksvdSac_representation','_s',...
%     num2str(s),'_k',num2str(k)),'X3');
% figure;
% imshow(ima_re);
% title('BKSVD+SAC重构得到的图像');
% imwrite(ima_re,strcat(imageName,'rec_by_BksvdSAC',...
%     '_s',num2str(s),'_k',num2str(k),'.bmp'));
% diff_Sac_Original=image-ima1;
% val_Sac_Original=sum(sum(abs(diff_Sac_Original)))


%% BKSVD+Cluster重构图像
X4 = simult_sparse_coding(D4,Ys,d4,k,1);
Ycomp4 = D4*X4;
% Ycomp4=bsxfun(@plus,Ycomp4,Ysmean);
save(strcat(imageName,'_BksvdCluster_representation','_s',...
    num2str(s),'_k',num2str(k)),'X4');
Ycomp4 = Ycomp4 + Ysmean;
ima2=patch2image(Ycomp4,blkSize,size(image));
ima_re=uint8(ima2);
figure;
imshow(ima_re);
title('BKSVD+Cluster重构得到的图像');
imwrite(ima_re,strcat(imageName,'rec_by_BksvdCluster_scale',...
    '_s',num2str(s),'_k',num2str(k),'.bmp'));
% diff_Cluster_Sac=ima1-ima2;
% val_Cluster_Sac=sum(sum(abs(diff_Cluster_Sac)))
diff_Cluster_Original=image-ima2;
val_Ksvd_Original=sum(sum(abs(diff_Cluster_Original)))
%% BKSVD重构图像
% X2 = simult_sparse_coding(D2,Ys,d2,k,1);
% Ycomp2 = D2*X2;
% ima3=patch2image(Ycomp2,blkSize,size(image));
% ima_re=uint8(ima3);
% figure;
% imshow(ima_re);
% title('BKSVD重构得到的图像');
% imwrite(ima_re,strcat(imageName,'rec_by_Bksvd',...
%     '_s',num2str(s),'_k',num2str(k),'.bmp'));
% 
% % diff_Sac_Bksvd=ima1-ima3;
% % val_Sac_Bksvd=sum(sum(abs(diff_Sac_Bksvd)))
% diff_Bksvd_Original=image-ima3;
% val_Bksvd_Original=sum(sum(abs(diff_Bksvd_Original)))
% save(strcat(imageName,'_diff_Sac_Bksvd_Cluster','_s',...
%     num2str(s),'_k',num2str(k)),'diff_Sac_Original','val_Sac_Original',...
%    'diff_Cluster_Original','val_Cluster_Original','diff_Bksvd_Original',...
%    'val_Bksvd_Original','diff_Sac_Bksvd','val_Sac_Bksvd',...
%   'diff_Cluster_Sac','val_Cluster_Sac' );


%% BKSVD+Cluster_lowSim重构图像
X5 = simult_sparse_coding(D5,Ys,d5,k,1);
Ycomp5 = D5*X5;
Ycomp5 = Ycomp5 + Ysmean;
% Ycomp4=bsxfun(@plus,Ycomp4,Ysmean);
save(strcat(imageName,'_BksvdCluster_lowSim_representation','_s',...
    num2str(s),'_k',num2str(k)),'X5');
ima2=patch2image(Ycomp5,blkSize,size(image));
ima_re=uint8(ima2);
figure;
imshow(ima_re);
title('BKSVD+Cluster+lowSim重构得到的图像');
imwrite(ima_re,strcat(imageName,'rec_by_BksvdCluster_lowSim_scale',...
    '_s',num2str(s),'_k',num2str(k),'.bmp'));
% diff_Cluster_Sac=ima1-ima2;
% val_Cluster_Sac=sum(sum(abs(diff_Cluster_Sac)))
diff_Cluster_lowSim_Original=image-ima2;
val_Cluster_Original=sum(sum(abs(diff_Cluster_lowSim_Original)))