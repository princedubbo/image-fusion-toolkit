function   ag = average_gray(I,M,N)
sum = 0;
for i = 1:M
    for  j = 1:N
       sum = sum + I(i,j);
    end
end
ag = sum/(M*N);