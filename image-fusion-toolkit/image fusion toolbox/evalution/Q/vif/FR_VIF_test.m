clc,clear,close all
I=imread('infrared1.jpg');
I1=histeq(I);
I=double(I);
I1=double(I1);
vif=FR_VIF(I,I1);