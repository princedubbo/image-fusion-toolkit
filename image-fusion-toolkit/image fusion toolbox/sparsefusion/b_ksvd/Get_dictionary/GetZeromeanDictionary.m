clear all;
close all;
imageName='barb1';
I1=imread(strcat(imageName,'.bmp'));
figure;
imshow(I1);
title('source image1');
blkSize=[8,8];%�����Լ��޸Ķ�Ӧ��patch��С
I1=double(I1);
Y = im2col(I1,blkSize,'sliding');

%% ѡ��ѵ�������������������ʱ�����ѡ��20000����������
if size(Y,2)>10000
    randd=randperm(size(Y,2));
    randd=randd(1:10000);
    Y=Y(:,randd);
end

%% Create Dictionary with training signals: 
N = blkSize(1)^2;      % number of pixels in patch
s = 4; %dimension of blocks
k = 4;
K = 4*N;           %Number of columns in dictionary
max_it = 50;       %Nr of iterations for the algorithm to converge. 

Y1=bsxfun(@minus,Y,mean(Y)); %ѵ��һ���ֵ䲻��ͼ��������й�ϵ��
%% dictionary learning
%K-SVD�����ں��в���ȥ��ֵ��Ч����õ�
% [D1,d1]=ksvdTrainD(Y,K,k,max_it);
% save(strcat(imageName,'_Ksvd_dictionary','_s',...
%     num2str(1),'_k',num2str(k)),'D1','d1');

% [D2,d2] = BksvdTrainD(Y1,K,k,s,max_it);
% % save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
% save(strcat(imageName,'_Bksvd_dictionary_zeromean','_s',...
%     num2str(s),'_k',num2str(k)),'D2','d2');


% [D3,d3] =BksvdSacTrainD(Y1,K,k,s,max_it);
% % save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
% save(strcat(imageName,'_BksvdSAC_dictionary_zeromean','_s',...
%     num2str(s),'_k',num2str(k)),'D3','d3');


[D4,d4] = BksvdClusterTrainD(Y1,K,k,s,max_it);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_BksvdCluster_dictionary_zeromean_scale','_s',...
    num2str(s),'_k',num2str(k)),'D4','d4');
