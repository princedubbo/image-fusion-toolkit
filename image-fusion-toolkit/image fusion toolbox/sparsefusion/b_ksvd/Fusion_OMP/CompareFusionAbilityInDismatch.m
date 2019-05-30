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
imageName='b04';
I1=imread(strcat(imageName,'_1.tif'));
I2=imread(strcat(imageName,'_2.tif'));
figure;
imshow(I1);
title('source image1');

figure;
imshow(I2);
title('source image2');

%% 对一副图像进行平移，模拟失配的情况
I1numlie=size(I1,2);
I1_m=zeros(size(I1));
spnum=5;
for i=1:I1numlie
    if i>spnum
        I1_m(:,i)=I1(:,i-spnum+1);
    else
        I1_m(:,i)=I1(:,I1numlie-(spnum-i));
    end
end
figure;
imshow(I1_m,[]);
title('source image1 平移过后的图像');


[N1,N2]=size(I1);
[n1,n2]=size(I2);
bb=8;
if n1~=N1 && n2~=N2
    error('two images are not the same size.');
end
I1=double(I1_m);
I2=double(I2);
patchsize=[bb,bb];
Y1 = im2col(I1,patchsize,'sliding');
Y2 = im2col(I2,patchsize,'sliding');

k=4;s=4;
%% load dictionary not zero mean
load(strcat(imageName,'_BksvdCluster_dictionary_s4_k4.mat'));
load(strcat(imageName,'_BksvdSAC_dictionary_s4_k4.mat'));
load(strcat(imageName,'_Bksvd_dictionary_s4_k4.mat'));
load(strcat(imageName,'_Ksvd_dictionary_s1_k4.mat'));
%% coloumn max
imagef1=FusionByOmpColomunMax(D1,d1,k*s,Y1,Y2,size(I1));
figure;
imshow(imagef1);
title('KSVD融合图像（column max）_OMP');
imwrite(imagef1,strcat(imageName,'fusion_by_KSVD_OMP_max_dismatch',...
    num2str(spnum),'_s',num2str(s),'_k',num2str(k),'.bmp'));
%% fusion by BKSVD
% imagef2=FusionByOmpColomunMax(D2,d2,k,Y1,Y2,size(I1));
% figure;
% imshow(imagef2);
% title('BKSVD融合图像（coloumn max）');
% imwrite(imagef2,strcat(imageName,'fusion_by_BKSVD_OMP_coloumnMax_dismatch'...
% ,num2str(spnum),'_s',num2str(s),'_k',num2str(k),'.bmp'));

imagef2=FusionByOmpAndstruct(D2,d2,k,Y1,Y2,size(I1));
figure;
imshow(imagef2);
title('BKSVD融合图像（struct max）');
imwrite(imagef2,strcat(imageName,'fusion_by_BKSVD_OMP_structMax_dismatch'...
,num2str(spnum),'_s',num2str(s),'_k',num2str(k),'.bmp'));

%% fusion by BKSVD+SAC
% imagef3=FusionByOmpColomunMax(D3,d3,k,Y1,Y2,size(I1));
% figure;
% imshow(imagef3);
% title('BKSVDSAC融合图像（coloumn max）');
% imwrite(imagef3,strcat(imageName,'fusion_by_BKSVDSAC_OMP_coloumnMax_dismatch'...
% ,num2str(spnum),'_s',num2str(s),'_k',num2str(k),'.bmp'));

imagef3=FusionByOmpAndstruct(D3,d3,k,Y1,Y2,size(I1));
figure;
imshow(imagef3);
title('BKSVDSAC融合图像（struct max）');
imwrite(imagef3,strcat(imageName,'fusion_by_BKSVDSAC_OMP_structMax_dismatch'...
,num2str(spnum) ,'_s',num2str(s),'_k',num2str(k),'.bmp'));
%% fusion by BKSVD+Cluster
% imagef4=FusionByOmpColomunMax(D4,d4,k,Y1,Y2,size(I1));
% figure;
% imshow(imagef4);
% title('BKSVDCluster融合图像（coloumn max）');
% imwrite(imagef4,strcat(imageName,'fusion_by_BKSVDCluster_OMP_colomunMax_dismatch'...
% ,num2str(spnum),'_s',num2str(s),'_k',num2str(k),'.bmp'));

imagef4=FusionByOmpAndstruct(D4,d4,k,Y1,Y2,size(I1));
figure;
imshow(imagef4);
title('BKSVDCluster融合图像（struct max）');
imwrite(imagef4,strcat(imageName,'fusion_by_BKSVDCluster_OMP_structMax_dismatch'...
,num2str(spnum),'_s',num2str(s),'_k',num2str(k),'.bmp'));