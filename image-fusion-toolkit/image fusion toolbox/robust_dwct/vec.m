function [X,Y]= vec(a,b, block)
    [nv,nh] = size(a);
    nexp = nv*nh;     % number of coefficients considered
    N = block^2;  
    X = zeros(nexp,N);
    Y = zeros(nexp,N);
    Ly = (block-1)/2;
    Lx = (block-1)/2;
    %ȡ�����д���
    %X Y ��ÿһ��Ϊһ����������
    n = 0;
    for ny = -Ly:Ly,	% spatial neighbors
        for nx = -Lx:Lx,
            n = n + 1;
            f = circshift(a,[ny nx]);
            X(:,n) = f(:);
            f = circshift(b,[ny nx]);
            Y(:,n) = f(:);
        end
    end

end