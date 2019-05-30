function [k1, k2] = find_closest_l0(G, C);

[mx, i] = max(G(:));
[k1, k2] = ind2sub([size(G,1) size(G,2)],i);

