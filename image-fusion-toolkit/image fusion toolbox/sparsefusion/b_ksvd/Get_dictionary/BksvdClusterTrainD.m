function [D2,d2] = BksvdClusterTrainD(Y,K,k,s,max_it)
%%
% [D1,D2,d2,D3] = compare_ksvd(Y,K,k,s,d0,max_it);
% train dictionaries using KSVD and BKSVD+SAC
%
% Output:
%  D1 - result of KSVD2
%  D2 - result of BKSVD+SAC
%  d2 - recovered block structure for BKSVD+SAC
%  D3 - result of BKSVD without SAC
% initialize dictionary with random columns of norm 1
d0=1:K;
D2 = randn(size(Y,1),K);%64*256

%³õÊ¼»¯×ÖµäD¡£¡£¡£
D2 = D2 ./  repmat(sqrt(sum(D2.^2)),size(Y,1),1);
tic
h=waitbar(0,'BK-SVD & Cluster');
for i = 1:max_it
  
    [X, C2s] = simult_sparse_coding(D2,Y,d0,k*s,1);
    [d2, ~] =clustering(X, s);

    [X2, C2] = simult_sparse_coding(D2,Y,d2,k,1);
    [~, D2] = KSVD(X2, D2, Y, d2, C2);

    waitbar(i/max_it);
end
close(h);
toc