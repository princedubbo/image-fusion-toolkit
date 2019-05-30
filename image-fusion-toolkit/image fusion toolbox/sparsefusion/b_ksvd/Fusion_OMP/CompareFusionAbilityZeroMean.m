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
%%
k=4;s=4;

load(strcat(imageName,'_BksvdCluster_dictionary_zeromean_s4_k4.mat'));
[imagef4]=FusionByOmpAndstructZeroMean(D4,d4,k,Y1,Y2,size(I1));
figure;
imshow(imagef4);
title('BKSVDClusterÈÚºÏÍ¼Ïñ£¨struct max£©');
imwrite(imagef4,strcat(imageName,'fusion_by_BKSVDCluster_zeromean_OMP_structMax'...
,'_s',num2str(s),'_k',num2str(k),'.bmp'));