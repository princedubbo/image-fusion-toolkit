function [D,d] = BksvdCluster_lowSim_DsRs_TrainD(D,Y,K,k,s,max_it,ds,rs)
%%
% [D1,D2,d2,D3] = compare_ksvd(Y,K,k,s,d0,max_it);
% train dictionaries using KSVD and BKSVD+SAC
%
% Output:
%  D1 - result of KSVD
%  D2 - result of BKSVD+SAC
%  d2 - recovered block structure for BKSVD+SAC
%  D3 - result of BKSVD without SAC
% initialize dictionary with random columns of norm 1
d0=1:K;
% D = randn(size(Y,1),K);%64*256
% 
% %³õÊ¼»¯×ÖµäD¡£¡£¡£
% D = D ./  repmat(sqrt(sum(D.^2)),size(Y,1),1);
% D2 = D1;
% D3 = D1;

tic
h=waitbar(0,'BK-SVD & Cluster & lowSim');
for i = 1:max_it
    %ks-sparse reprentations of Y w.r.t D2 are calculated
    %(0 means only C2s is calculated, but not X2s, this is all we need for SAC)
    %C2s of size LxK contains true at (i,j) if X0(j,i)!=0

    [X, C2s] = simult_sparse_coding(D,Y,d0,k*s,1);
    %save('Xmama','X');
    %SAC-finds block structure d2 given C2s and max block size s
%     d2 = sparse_agg_clustering(C2s, s);
    [d, ~] =test_adptive_DsRs_blocks(D, X, s,ds,rs);

    %k-block-sparse reprentations X2 over d2 of Y w.r.t D2 are calculated
    %C2 of size LxB contains true at (i,j) if X2(:,i)  'uses' block nr j
    [X2, C2] = simult_sparse_coding(D,Y,d,k,1);
    %KSVD - updates every atom in D2 and nonzero values in X2 to minimize representation error
   [~, D] = KSVD(X2, D, Y, d, C2);

    waitbar(i/max_it);
end
close(h);
toc
