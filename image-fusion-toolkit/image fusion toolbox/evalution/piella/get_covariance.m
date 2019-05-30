function gc = get_covariance(I,J,ag1,ag2,M,N)
sum = 0;
for i = 1:M
    for  j = 1:N
       sum = sum + (I(i,j) - ag1) * (J(i,j) - ag2);
    end
end
gc = sum/(M*N - 1);