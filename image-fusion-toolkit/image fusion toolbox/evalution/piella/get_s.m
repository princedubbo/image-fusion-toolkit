function s = get_s(JA1,MA,NA)
ag = average_gray(JA1,MA,NA);
v = get_variance(JA1,ag,MA,NA);
% sAy = zeros(MA,NA);
% [m,n] = size()
% sAy = vertical_direction(JA1);
% for i = 1:MA
%     for j =1:NA
%     gA(i,j) = sqrt(sAx(i,j)^2 + sAy(i,j)^2);
% %     aA(i,j) = atan(sAy(i,j)/sAx(i,j));
%     end
% end
s = v;