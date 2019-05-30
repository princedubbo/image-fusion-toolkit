function [k1, k2] = find_min_l0(G, C);

% [mx, i] = min(G(:));
a=G(triu(ones(size(C,2)),1)==1);
minval=min(a);
if isnan(minval)
   k1=0;
   k2=0;
   return;
end
% [k1, k2] = ind2sub([size(G,1) size(G,2)],i);
[k1,k2]=find(G==minval);
if numel(k1)
    k1=k1(1);
    k2=k2(1);
else 
    k1=0;
    k2=0;
end