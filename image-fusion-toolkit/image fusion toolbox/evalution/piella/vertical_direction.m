function sy = vertical_direction(J)
% Gy = zeros(M,N);
G = [1 2 1;0 0 0;-1 -2 -1];
% for i = 1:M
%     for j = 1:N
Gy = conv2(G,J);
%     end
% end
sy = Gy;