function QAF1 = get_Q(A2,F2,M,N)
 
 
%%%%%%%%%%%%%%%%%%��ͼ������ָ��%%%%%%%%%%%%%%%%
%%%��A��B��ƽ���Ҷ��뷽��
ag = average_gray(A2,M,N);
 
v = get_variance(A2,ag,M,N);
 
v1 = sqrt(v);
 
 
%%%��F��ƽ���Ҷ��뷽��
agF = average_gray(F2,M,N);
vF = get_variance(A2,agF,M,N);
vF1 = sqrt(vF);
 
 
%%%��ͼ��Э����
cF= get_covariance(A2,F2,ag,agF,M,N);
 
 
%%%��ͼ���������س̶�
if (v1 == 0 || vF1 == 0)
    LF = 0;
else
    LF = cF/(v1*vF1);
end
 
 
%%%%ͼ��ƽ���Ҷ�ֵ�����Ƴ̶�
if( ag == 0 || agF == 0)
    SF = 0;
else
    SF = 2*(ag*agF)/(ag^2 + agF^2);
end
 
 
%%%ͼ�񷽲��������
if ( v == 0 || vF == 0)
    VF = 0;
else
    VF = 2*(v1*vF1)/(v + vF);
end
 
 
%%%ͼ������ָ��
 
QAF1 = LF*SF*VF;