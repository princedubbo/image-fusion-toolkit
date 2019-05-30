function G = matrixdis_G(C, s, d, dlen, G, k)



if isempty(G)
    G=zeros(size(C,2));
    G(triu(ones(size(C,2)),1)==1)=pdist(C','cityblock');
%     G = C'*C;
%     for i =1:B
%         c_ind = dlen>(s-dlen(i));
%         G(i,c_ind) = -1; G(c_ind,i) = -1;
%     end
%     G(~triu(ones(B),1)) = -1;

else
    Gk = sum(abs(C-repmat(C(:,k),1,size(C,2)))); 
    Gk(dlen>(s-dlen(k))) = NaN;
    G(k,k+1:end) = Gk(k+1:end); 
    G(1:k-1,k) = Gk(1:k-1);
end