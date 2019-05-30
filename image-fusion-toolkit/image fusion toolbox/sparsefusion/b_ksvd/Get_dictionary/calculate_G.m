function G = calculate_G(C, s, d, dlen, G, k)

B = size(C,2);

if isempty(G)
    G = C'*C;
    for i =1:B
        c_ind = dlen>(s-dlen(i));
        G(i,c_ind) = -1; G(c_ind,i) = -1;
    end
    G(~triu(ones(B),1)) = -1;

else
    Gk = C(:,k)'*C; 
    Gk(dlen>(s-dlen(k))) = -1;
    G(k,k+1:end) = Gk(k+1:end); 
    G(1:k-1,k) = Gk(1:k-1);
end
