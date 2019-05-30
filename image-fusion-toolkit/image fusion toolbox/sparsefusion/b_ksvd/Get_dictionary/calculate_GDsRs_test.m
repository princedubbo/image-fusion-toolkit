function G = calculate_GDsRs_test( D, C, s, d, dlen, G, k, ds, rs)

B = size(C,2);
m = size(D,2);

if isempty(G)
    distTherold = quantile(pdist(D'), ds);
    G = C'*C; %计算字典列在系数上的相似性
%   G(G < quantile(G(:), 0.9995)) = -1;  %字典在系数相似性上低于均值后就不能放在一组
    for i =1:B
        c_ind = dlen>(s-dlen(i));
        G(i,c_ind) = -1; G(c_ind,i) = -1;
        distance = sqrt(sum((D - repmat(D(: , i),[1, m])).^2));
        dst = distance < distTherold;
        G(i,dst) = -1;G(dst, i) = -1;
        rst = G(:,i) <quantile(G(:,i), rs);
        G(rst, i) = -1; 
        G(i, rst) = -1; 
    end
    G(~triu(ones(B),1)) = -1;
    save('gtest','G');
else
    Gk = C(:,k)'*C; 
    Gk(dlen>(s-dlen(k))) = -1;
    G(k,k+1:end) = Gk(k+1:end); 
    G(1:k-1,k) = Gk(1:k-1);
end
