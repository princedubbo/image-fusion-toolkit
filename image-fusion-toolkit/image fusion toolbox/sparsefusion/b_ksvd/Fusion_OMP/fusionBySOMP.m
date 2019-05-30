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

load(strcat(imageName,'_Ksvd_dictionary_s1_k4.mat'));

k=4;s=4;
s1=4;k1=4;
%% coloumn max
imagef1=FusionBySOmpColomumZeroMean(D1,k*s,Y1,Y2,size(I1));
figure;
imshow(imagef1);
title('KSVD & SOMPÈÚºÏÍ¼Ïñ£¨column max£©');
imwrite(imagef1,strcat(imageName,'fusion_by_KSVD_SOMP_max',...
    '_s',num2str(1),'_k',num2str(k),'.bmp'));
