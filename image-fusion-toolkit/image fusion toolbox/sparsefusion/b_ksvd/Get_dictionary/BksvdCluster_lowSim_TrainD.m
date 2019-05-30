function [D,d] = BksvdCluster_lowSim_TrainD(Y,K,k,s,max_it,ds, rs)
%%
d0=1:K;
D = randn(size(Y,1),K);%64*256
% 
% %³õÊ¼»¯×ÖµäD¡£¡£¡£
D = D ./  repmat(sqrt(sum(D.^2)),size(Y,1),1);
tic
h=waitbar(0,'BK-SVD & Cluster & lowSim');
for i = 1:max_it
    [X, C2s] = simult_sparse_coding(D,Y,d0,k*s,1);
    [d, ~] =test_adptive_blocks(D, X, s, ds, rs);

    [X2, C2] = simult_sparse_coding(D,Y,d,k,1);
    [~, D] = KSVD(X2, D, Y, d, C2);

     waitbar(i/max_it);
end
close(h);
toc
