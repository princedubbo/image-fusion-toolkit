function [X, C] = simult_sparse_coding(D, Y, d, k, find_X)

L = size(Y,2); [N,K] = size(D);
n = sqrt(sum(D.*D));
Dn =ones(N,1)*(1./n).*D;%把每列归一化
dd = false(max(d), K);
%使其对角线为true，dd是一个方阵，他的行和列都是字典原子的个数
for i = 1:max(d), dd(i,d==i) = true; end;
[X, C] = simult_BMMP(Dn, Y, dd, k, find_X);%
if find_X, X = (1./n')*ones(1,L).*X; end
