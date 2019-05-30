clear all;
close all;
%clc;

%% First we need to train a dictionary

%% patch parameters
PATCH.ROWS = 8;      % number of rows in each patch
PATCH.COLS = 8;      % number of columns in each patch
PATCH.COLORS = 1;    % use gray-scale or RGB
PATCH.SZ = PATCH.ROWS*PATCH.COLS*PATCH.COLORS;
N = PATCH.ROWS*PATCH.COLS;      % number of pixels in patch



%% load an image for training
% imageName = 'lena.png';
% ima = imread(imageName);
% figure ;
% imshow(ima);
% if size(ima,3)>1, ima = rgb2gray(ima); end
tic
imageName='b04';
I1=imread(strcat(imageName,'_1.tif'));
I2=imread(strcat(imageName,'_2.tif'));
figure;
imshow(I1);
title('source image1');
toc

figure;
imshow(I2);
title('source image2');

[N1,N2]=size(I1);
[n1,n2]=size(I2);
bb=8;
if n1~=N1 && n2~=N2
    error('two images are not the same size.');
end
I1=double(I1);
I2=double(I2);
patchsize=[bb,bb];
Y1 = im2col(I1,patchsize,'sliding');
Y2 = im2col(I2,patchsize,'sliding');
%% load dictionary not zero mean
load(strcat(imageName,'_BksvdCluster_dictionary_s4_k4.mat'));
load(strcat(imageName,'_BksvdSAC_dictionary_s4_k4.mat'));
load(strcat(imageName,'_Bksvd_dictionary_s4_k4.mat'));
load(strcat(imageName,'_Ksvd_dictionary_s1_k4.mat'));
k=4;s=4;
s1=4;k1=4;
%% coloumn max
imagef1=FusionByOmpColomunMax(D1,d1,k*s,Y1,Y2,size(I1));
figure;
imshow(imagef1);
title('KSVDÈÚºÏÍ¼Ïñ£¨column max£©');
imwrite(imagef1,strcat(imageName,'fusion_by_KSVD_OMP_max',...
    '_s',num2str(1),'_k',num2str(k),'.bmp'));
%% fusion by BKSVD
% imagef2=FusionByOmpColomunMax(D2,d2,k,Y1,Y2,size(I1));
% figure;
% imshow(imagef2);
% title('BKSVDÈÚºÏÍ¼Ïñ£¨coloumn max£©');
% imwrite(imagef2,strcat(imageName,'fusion_by_BKSVD_OMP_coloumnMax'...
% ,'_s',num2str(s1),'_k',num2str(k1),'.bmp'));

imagef2=FusionByOmpAndstruct(D2,d2,k,Y1,Y2,size(I1));
figure;
imshow(imagef2);
title('BKSVDÈÚºÏÍ¼Ïñ£¨struct max£©');
imwrite(imagef2,strcat(imageName,'fusion_by_BKSVD_OMP_structMax'...
,'_s',num2str(s1),'_k',num2str(k1),'.bmp'));

%% fusion by BKSVD+SAC
% imagef3=FusionByOmpColomunMax(D3,d3,k,Y1,Y2,size(I1));
% figure;
% imshow(imagef3);
% title('BKSVDSACÈÚºÏÍ¼Ïñ£¨coloumn max£©');
% imwrite(imagef3,strcat(imageName,'fusion_by_BKSVDSAC_OMP_coloumnMax'...
% ,'_s',num2str(s1),'_k',num2str(k1),'.bmp'));

imagef3=FusionByOmpAndstruct(D3,d3,k,Y1,Y2,size(I1));
figure;
imshow(imagef3);
title('BKSVDSACÈÚºÏÍ¼Ïñ£¨struct max£©');
imwrite(imagef3,strcat(imageName,'fusion_by_BKSVDSAC_OMP_structMax'...
,'_s',num2str(s1),'_k',num2str(k1),'.bmp'));
%% fusion by BKSVD+Cluster
% imagef4=FusionByOmpColomunMax(D4,d4,k,Y1,Y2,size(I1));
% figure;
% imshow(imagef4);
% title('BKSVDClusterÈÚºÏÍ¼Ïñ£¨coloumn max£©');
% imwrite(imagef4,strcat(imageName,'fusion_by_BKSVDCluster_OMP_colomunMax'...
% ,'_s',num2str(s1),'_k',num2str(k1),'.bmp'));

imagef4=FusionByOmpAndstruct(D4,d4,k,Y1,Y2,size(I1));
figure;
imshow(imagef4);
title('BKSVDClusterÈÚºÏÍ¼Ïñ£¨struct max£©');
imwrite(imagef4,strcat(imageName,'fusion_by_BKSVDCluster_OMP_structMax'...
,'_s',num2str(s1),'_k',num2str(k1),'.bmp'));