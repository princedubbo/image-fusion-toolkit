clear all;
close all;
imageName='lena';
image=imread(strcat(imageName,'.bmp'));
blkSize=[8,8];             %对应的patch大小
figure;
imshow(image);
[N1,N2]=size(image);
image=double(image);

%% Create Dictionary with training signals: 
N = blkSize(1)^2;      % number of pixels in patch
s = 4;                 %dimension of blocks
k = 4;
K = 4*N;               %Number of columns in dictionary
max_it = 50;           %Nr of iterations for the algorithm to converge. 
%% 选择训练样本，当样本过多的时候，随机选择10000个样本出来
Y = im2col(image,blkSize,'sliding');
if size(Y,2)>40000
    randd=randperm(size(Y,2));
    randd=randd(1:40000);
    Y=Y(:,randd);
end
%%Y=bsxfun(@minus,Y,mean(Y)); %训练一个字典不与图像的亮度有关系的
% D = randn(size(Y,1),K);%64*256
% 
% %初始化字典D。。。
% D = D ./  repmat(sqrt(sum(D.^2)),size(Y,1),1);
ds = 0.45;rs = 0.45
[D5,d5] = BksvdCluster_lowSim_TrainD(D,Y,K,k,s,max_it, ds, rs);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_BksvdCluster_lowSim_dictionary','_s',...
    num2str(s),'_k',num2str(k)),'D5','d5');

[D4,d4] = BksvdClusterTrainD(D,Y,K,k,s,max_it);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_BksvdCluster_dictionary','_s',...
    num2str(s),'_k',num2str(k)),'D4','d4');

[D1,d1] = ksvdTrainD(D, Y,K,k*s,max_it);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_ksvd_dictionary','_s',...
    num2str(s),'_k',num2str(k)),'D1','d1');
% [D4,d4] = BksvdClusterTrainD(Y,K,k,s,max_it);
% % save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
% save(strcat(imageName,'_BksvdCluster_dictionary','_s',...
%     num2str(s),'_k',num2str(k)),'D4','d4');
% % d0=1:K;
% % D2 = randn(size(Y,1),K);%64*256
% % 
% % %初始化字典D。。。
% % D2 = D2 ./  repmat(sqrt(sum(D2.^2)),size(Y,1),1);
% % 
% %  [X, C2s] = simult_sparse_coding(D2,Y,d0,k*s,1);
