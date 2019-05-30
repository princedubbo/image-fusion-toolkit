function [X, D] = KSVD(X, D, Y, d, C)

% Kevin Rosenlum - 2010
% This function executes one iteration of the BK-SVD algorithm
% [X, D] = KSVD(X, D, Y, d, C)
% Input:
%-D (NxK): initial dictionary
%-Y (NxL): signal set of size L 
%-X (KxL): initial representations of Y
%-d (1xK): block structure of D
%-C (LxB): C(l,b)=1 if X(d==b,l)~=0 (B = nr of blocks in d)
% Output:
%-D (NxK): optimal dictionary
%-X (KxL): optimal representations of Y

YY = D*X;
N = size(D,1);
for k = 1:max(d)
    wk = C(:,k)'~=0; swk = sum(wk);
    if ~swk continue, end;
    col = (d==k); len = sum(col);
    if len>swk
        col(find(col,len-swk))=0; len = swk;
    end;
    YYk = D(:,col)*X(col,wk);
    YYnk = YY(:,wk)-YYk;
    Erk = Y(:,wk)-YYnk;
    [U,S,V] = pca(Erk,len);
    Dc = U;
    Xc = S*V';
    D(:,col) = Dc;
    X(col,wk) = Xc;
    YY(:,wk) = YYnk+Dc*Xc;
end
