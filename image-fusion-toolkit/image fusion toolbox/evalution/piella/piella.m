function [Q,Qw,Qe]=piella(A,B,F)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Piella和Heijmans提出了一种新的图像融合质量评价标准，该标准主要基于通用图像融合指数（UIQI），以更精细的加权平均方式度量了融合图像的UIQI。
%PFQM体系包括了图像融合质量指数（Image Fusion Quality Index， IFQI），加权融合质量指数（Weighted Fusion Quality Index， WFQI）和边缘相关融合质量指数（Edge-dependent Fusion Quality Index， EFQI）。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% A1 = rgb2gray(A);
% B1 = rgb2gray(B);
% F1 = rgb2gray(F);
A2 = im2double(A);
B2 = im2double(B);
F2 = im2double(F);
BW1 = edge(A2,'sobel');
BW2 = edge(B2,'sobel');
BW3 = edge(F2,'sobel');
% figure;
% subplot(2,2,1);
% imshow(BW1); title('BW1');
% subplot(2,2,2);
% imshow(BW2) ; title('BW2');
% subplot(2,2,3);
% imshow(BW3) ; title('BW3');
[MA,NA] = size(A2);
[MB,NB] = size(B2);
[MF,NF] = size(F2);
[MA1,NA1] = size(BW1);
[MB1,NB1] = size(BW2);
[MF1,NF1] = size(BW3);
W = 3;
H = 3;
halfW = ceil(W/2);
halfH = ceil(H/2);
M = (MA - halfW)*(NA - halfH);
 
%%%生成一个W*H的滑行窗口 ----A与F
 
QAF1 = zeros(MA - halfW,NA - halfH);
 
for i = halfH:MA- halfW
    for j = halfW:NA- halfH
        PA = A2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PF = F2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PB = B2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        QAF1(i - 1,j - 1) = get_Q(PA,PF,W,H);
 
    end
end
 
%%%%生成一个W*H的滑行窗口 ----B与F
 
QBF1 = zeros(MA - halfW,NA - halfH);
 
for i = halfH:MB- halfH
    for j = halfW:NB- halfW
        PB = B2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PF = F2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        QBF1(i - 1,j - 1) = get_Q(PB,PF,W,H);
 
    end
end
 
%%%求方差s（A|W) 和 s（B|W) 
sA = zeros(MA - halfW,NA - halfH);
sB = zeros(MA - halfW,NA - halfH);
LA =  zeros(MA - halfW,NA - halfH);
LB =  zeros(MA - halfW,NA - halfH);
C =  zeros(MA - halfW,NA - halfH);
for i = halfH:MA- halfH
    for j = halfW:NA- halfW
        PA = A2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PF = F2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PB = B2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        sA (i - 1,j - 1) = get_s(PA,W,H);
        sB (i - 1,j - 1) = get_s(PB,W,H); 
        C (i - 1,j - 1) = max( sA (i - 1,j - 1),sB (i - 1,j - 1));
    end
end
allC = sum(sum(C));
c = C./allC;
%%%权重LA 
s = zeros(MA - halfW,NA - halfH);
s = sA + sB;
for i = 1:MA - halfH
    for j = 1:NA - halfW
 
        if( s(i,j) == 0 )
            LA(i,j) = 0;
        else
            LA(i,j) = sA(i,j)/s(i,j);
        end
    end
end
%%%权重LB
for i = 1:MA - halfH
    for j = 1:NA - halfW
 
if( s(i,j) == 0 )
    LB(i,j) = 0;
else
    LB(i,j) = sB(i,j)/s(i,j);
end
    end
end
% %%%%求IFQI
IFQI1 = sum(sum(LA.*QAF1));
IFQI2 = sum(sum(LB.*QBF1));
IFQI3 = IFQI1 + IFQI2;
IFQI = IFQI3/M;
Q=IFQI;
 
%%%%求WFQI
 
WFQI = sum(sum(c.*(LA.*QAF1))) + sum(sum(c.*(LB.*QBF1)));
Qw=WFQI;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%边缘图像%%%%%%%%%%%%%%%%%%%%%%%
 
%%%生成一个W*H的滑行窗口 ----BW1与BW3
 
QBW13 = zeros(MA1- halfH,NA1- halfW);
 
for i = halfH:MA1- halfH
    for j = halfW:NA1- halfW
        PA1 = BW1(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PF1 = BW3(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PB1 = BW2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        QBW13(i - 1,j - 1) = get_Q(PA1,PF1,W,H);
 
    end
end
 
%%%%生成一个W*H的滑行窗口 ----BW2与BW3
 
QBW23 = zeros(MB1- halfH,NB1- halfW);
 
for i = halfH:MB1- halfH
    for j = halfW:NB1- halfW
        PB1 = BW2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PF1 = BW3(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        QBW23(i - 1,j - 1) = get_Q(PB1,PF1,W,H);
 
    end
end
 
%%%求方差s1（A|W) 和 s1（B|W) 
sA1 = zeros(MA1 - halfW,NA1 - halfH);
sB1 = zeros(MB1 - halfW,NB1 - halfH);
LA1 =  zeros(MA1 - halfW,NA1 - halfH);
LB1 =  zeros(MB1 - halfW,NB1 - halfH);
C1 =  zeros(MA1 - halfW,NA1 - halfH);
for i = halfH:MA1 - halfH
    for j = halfW:NA1 - halfW
        PA1 = BW1(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PF1 = BW3(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PB1 = BW2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        sA1(i - 1,j - 1) = get_s(PA1,W,H);
        sB1(i - 1,j - 1) = get_s(PB1,W,H); 
        C1(i - 1,j - 1) = max( sA1 (i - 1,j - 1),sB1 (i - 1,j - 1));
    end
end
allC1 = sum(sum(C1));
c1 = C1./allC1;
%%%权重LA1
s1 = zeros(MA1 - halfW,NA1 - halfH);
s1 = sA1 + sB1;
for i = 1:MA1 - halfW
    for j = 1:NA1 - halfW
 
if( s1(i,j) == 0 )
    LA1(i,j) = 0;
else
    LA1(i,j) = sA1(i,j)/s1(i,j);
end
    end
end
%%%权重LB1
for i = 1:MB1 - halfW
    for j = 1:NB1 - halfW
 
if( s1(i,j) == 0 )
    LB1(i,j) = 0;
else
    LB1(i,j) = sB1(i,j)/s1(i,j);
end
    end
end
% %%%%求IFQI0
IFQI10 = sum(sum(LA1.*QBW13));
IFQI20 = sum(sum(LB1.*QBW23));
IFQI30 = IFQI10 + IFQI20;
IFQI0 = IFQI30/M;
 
%%%%求WFQI0
 
WFQI0 = sum(sum(c1.*(LA1.*QBW13))) + sum(sum(c1.*(LB1.*QBW23)));
 
%%%%求EFQI
a = 1;
EFQI = WFQI^(1 - a ) * WFQI0^a;
Qe=EFQI;
