function    v = get_variance(I,ag,M,N)
sum = 0;
for i = 1:M
    for  j = 1:N
       sum = sum + (I(i,j) - ag)^2;
    end
end
v = sum/(M*N - 1);