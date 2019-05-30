function [D3,d] = BksvdTrainD(Y,K,k,s,max_it)
%Y��ѵ��������K���ֵ��������s��һ������ຬ�е��ֵ�����
%k������ж��ٸ������������ϡ���
D3 = randn(size(Y,1),K);%64*256
%��ʼ���ֵ�D������
D3 = D3 ./  repmat(sqrt(sum(D3.^2)),size(Y,1),1);
B = K/s; 
d = repmat(1:B, s,1);
d=d(:)';
tic
h=waitbar(0,'BK-SVD ');
for i = 1:max_it
    [X2, C2] = simult_sparse_coding(D3,Y,d,k,1);
    [~, D3] = KSVD(X2, D3, Y, d, C2);
    waitbar(i/max_it);
end
close(h);
toc