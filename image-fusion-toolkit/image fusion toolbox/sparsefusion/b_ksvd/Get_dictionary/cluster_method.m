% clear all;
close all;
load('represent.mat');
tic;

s=4;
% [C1,~]=featureNormalize(A2);
% % [d, C] = clustering(C1', s);
% % % [d, C] = sparse_agg_clustering(C1', s);
% C=abs(C1');
idx=sum(abs(A2));
A2=A2(:,idx~=0);
[A,~]=featureNormalize(abs(A2'));
A=A-repmat(min(A),size(A,1),1);
A=featureNormalize(A');
A=A-repmat(min(A),size(A,1),1);