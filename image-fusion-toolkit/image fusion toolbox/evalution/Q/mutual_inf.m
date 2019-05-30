function mulinf = mutual_inf( A,F )
%函数功能:
%        求输入两幅图像之间的互信息
%输入参数：
%        A,F----输入的两幅图像
%输出参数：
%        mulinf----输入的两幅图像之间的互信息
%---------------------------------------------------------------%

[COUNTS1,X] = imhist(A);
[m1,n1]=size(A);
PA=COUNTS1/(m1*n1);
[COUNTS2,Y] = imhist(F);
[m2,n2]=size(F);
PF=COUNTS2/(m2*n2);
COUNTS=zeros(256,256);
for k=1:m1
       for l=1:n1
                i=A(k,l);
                j=F(k,l);
                COUNTS(i+1,j+1)=COUNTS(i+1,j+1)+1;
       end
end

PAF=COUNTS/65536;
MIfa=0;
for i=1:256
    for j=1:256
        if(PAF(i,j)~=0&&PF(i)~=0&&PA(j)~=0)
            MIfa=MIfa+PAF(i,j)*log2(PAF(i,j)/(PF(i)*PA(j)));
        end
    end
end
mulinf=MIfa;

end

