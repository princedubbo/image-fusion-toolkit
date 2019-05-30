function [d, C] = sparse_agg_clustering(Cl, s)

% Kevin Rosenlum - 2010
% This function executes the SAC algorithm
% [d C] = sparse_agg_clustering(Cl, s)
% Input:
%-Cl(LxK): Cl(l,k)=1 if X(k,l)~=0 (X are sparse representations)
%-s      : maximum allowed block size
% Output:
%-d (1xK): block structure in Cl
%-C (LxB): C(l,b)=1 if Cl(l,d==b)~=0 (B = nr of blocks in d)

C = zeros(size(Cl)); 
C(Cl) = 1;
K = size(C,2);          % number of atoms in dictionary
d = zeros(1,K);         % block structure
nz = sum(C)>0; 
d(nz) = 1:sum(nz);      % initial labeling of atoms
dlen = ones(1,sum(nz)); % size of each block
C = C(:,nz);            % sparsity
G = calculate_G(C,s,d,dlen,[],[]);  % similarity between sparsity of blocks
while sum(sum(G>-1))
    [k1, k2] = find_closest_l0(G, C); % find the best pair of blocks to merge
    d(d==k2) = k1;                   % merge block k2 with k1
    d(d>k2) = d(d>k2)-1;             % update labels of all blocks
    C(:,k1) = (C(:,k1)+C(:,k2))>0;   % update sparsity structure
    C = C(:,[1:(k2-1) (k2+1):end]);  
    dlen(k1) = dlen(k1)+dlen(k2);    % update block size
    dlen = dlen([1:(k2-1) (k2+1):end]);
    G = calculate_G(C,s ,d, dlen, G([1:(k2-1) (k2+1):end],[1:(k2-1) (k2+1):end]), k1);
end

