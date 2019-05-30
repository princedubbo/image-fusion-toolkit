function [D3,d] = BksvdTrainD(Y,K,k,s,max_it)
%Y是训练样本，K是字典的列数，s是一组中最多含有的字典列数
%k是最多有多少个组类似于组的稀疏度
D3 = randn(size(Y,1),K);%64*256
%初始化字典D。。。
D3 = D3 ./  repmat(sqrt(sum(D3.^2)),size(Y,1),1);
B = K/s; 
d = repmat(1:B, s,1);
d=d(:)';
tic
h=waitbar(0,'BK-SVD ');
for i = 1:max_it
    [X2, C2] = simult_sparse_coding(D3,Y,d,k,1);
    [~, D3] = KSVD(X2, D3, Y, d, C2);
    waitbar(i/max_it);
end
close(h);
toc