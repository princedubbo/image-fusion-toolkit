function [d, C] = test_adptive_blocks(D,C, s,ds, rs)
%% 验证自适应分组算法
idx=sum(abs(C));
C=C(:,idx~=0);

[C,~]=featureNormalize(abs(C'));
C=C-repmat(min(C),size(C,1),1);

K = size(C,2);          % number of atoms in dictionary

d=1:K;
dlen=ones(1,K);
G = calculate_G_test(D,C,s,d,dlen,[],[],ds, rs);  % similarity between sparsity of blocks
while sum(sum(G>-1))
    [k1, k2] = find_closest_l0(G, C);% find the best pair of blocks to merge
    d(d==k2) = k1;                   % merge block k2 with k1
    d(d>k2) = d(d>k2)-1;             % update labels of all blocks
    C(:,k1) = (C(:,k1)+C(:,k2))/2;   % update sparsity structure
    C = C(:,[1:(k2-1) (k2+1):end]);  
    dlen(k1) = dlen(k1)+dlen(k2);    % update block size
    dlen = dlen([1:(k2-1) (k2+1):end]);
    G = calculate_G_test(D,C,s ,d, dlen, G([1:(k2-1) (k2+1):end],[1:(k2-1) (k2+1):end]), k1, ds, rs);
end