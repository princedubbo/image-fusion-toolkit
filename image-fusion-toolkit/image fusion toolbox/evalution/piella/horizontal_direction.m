function sx = horizontal_direction(J)
% Gx = zeros(M,N);
 G = [-1 0 1;-2 0 2;-1 0 1];
% for i = 1:M
%     for j = 1:N
        Gx = conv2(G,J);
%     end
% end
sx = Gx;