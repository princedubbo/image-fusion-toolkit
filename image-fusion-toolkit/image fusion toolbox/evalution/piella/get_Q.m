function QAF1 = get_Q(A2,F2,M,N)
 
 
%%%%%%%%%%%%%%%%%%求图像质量指数%%%%%%%%%%%%%%%%
%%%求A、B的平均灰度与方差
ag = average_gray(A2,M,N);
 
v = get_variance(A2,ag,M,N);
 
v1 = sqrt(v);
 
 
%%%求F的平均灰度与方差
agF = average_gray(F2,M,N);
vF = get_variance(A2,agF,M,N);
vF1 = sqrt(vF);
 
 
%%%两图像协方差
cF= get_covariance(A2,F2,ag,agF,M,N);
 
 
%%%两图像的线性相关程度
if (v1 == 0 || vF1 == 0)
    LF = 0;
else
    LF = cF/(v1*vF1);
end
 
 
%%%%图像平均灰度值的相似程度
if( ag == 0 || agF == 0)
    SF = 0;
else
    SF = 2*(ag*agF)/(ag^2 + agF^2);
end
 
 
%%%图像方差的相似性
if ( v == 0 || vF == 0)
    VF = 0;
else
    VF = 2*(v1*vF1)/(v + vF);
end
 
 
%%%图像质量指数
 
QAF1 = LF*SF*VF;