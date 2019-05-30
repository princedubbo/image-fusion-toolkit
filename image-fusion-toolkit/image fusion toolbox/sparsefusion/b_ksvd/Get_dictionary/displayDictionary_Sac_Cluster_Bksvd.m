K=256;
imageName='barb1';
%% ѵ�����˵��ֵ䣬��load��ȡ
load('barb1_ksvd_dictionary.mat')
load(strcat(imageName,'_BksvdCluster_dictionary_s4_k4.mat'));
load(strcat(imageName,'_BksvdSAC_dictionary_s4_k4.mat'));
load(strcat(imageName,'_Bksvd_dictionary_s4_k4.mat'));

%% ��ʾ�ֵ䣬�����ڵ�����ʾ�����ڵĵط�
figure;
I = displayDictionaryElementsAsImage(D1, floor(sqrt(K)),...
    floor(size(D2,2)/floor(sqrt(K))),8 ,8,0);
title('ksvd');
imwrite(I,strcat(imageName,'_ksvd_dictionary.bmp'));

figure;
I = displayDictionaryElementsAsImage(D2, floor(sqrt(K)),...
    floor(size(D2,2)/floor(sqrt(K))),8 ,8,0,d2);
title('Bksvd');
imwrite(I,strcat(imageName,'_Bksvd_dictionary.bmp'));

figure;
I = displayDictionaryElementsAsImage(D3, floor(sqrt(K)),...
    floor(size(D3,2)/floor(sqrt(K))),8 ,8,0,d3);
title('Bksvd+Sac');
imwrite(I,strcat(imageName,'_BksvdSAC_dictionary.bmp'));

figure;
I = displayDictionaryElementsAsImage(D4, floor(sqrt(K)),...
    floor(size(D4,2)/floor(sqrt(K))),8 ,8,0,d4);
title('Bksvd+Cluster');
imwrite(I,strcat(imageName,'_BksvdCluster_dictionary.bmp'));



