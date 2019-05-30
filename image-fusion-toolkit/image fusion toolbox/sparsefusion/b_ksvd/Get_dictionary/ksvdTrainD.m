function [D2,d0] = ksvdTrainD(Y,K,k,max_it)
%Y��ѵ��������K���ֵ��������k��ϡ���
D2 = randn(size(Y,1),K);%64*256
% %��ʼ���ֵ�D������
D2 = D2 ./  repmat(sqrt(sum(D2.^2)),size(Y,1),1);
d0=1:K;

%%
h=waitbar(0,'K-SVD');
tic
for i = 1:max_it
    [X1 ,C1] = simult_sparse_coding(D2,Y,d0,k,1);
    [~ ,D2] = KSVD(X1, D2, Y, d0, C1);
    waitbar(i/max_it);
end
close(h);
toc