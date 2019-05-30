close all;
A=imread('boatrec_by_BksvdCluster_s4_k4.bmp');
B=imread('boatrec_by_BksvdSAC_s4_k4.bmp');
S=imread('boat.bmp');

C=double(S)-double(A);
D=double(S)-double(B);
E=double(A)-double(B);
figure;
imshow(im2bw(uint8(C),0.05));

sum(sum(abs(C)))
title('S-cluster');
sum(sumabs((D)))
figure;
imshow(im2bw(uint8(D),0.05));

sum(sum(abs(E)))
title('S-sac');
figure;
imshow(im2bw(uint8(E),0.01));
title('A-B');