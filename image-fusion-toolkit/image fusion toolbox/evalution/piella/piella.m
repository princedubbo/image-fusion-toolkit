function [Q,Qw,Qe]=piella(A,B,F)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Piella��Heijmans�����һ���µ�ͼ���ں��������۱�׼���ñ�׼��Ҫ����ͨ��ͼ���ں�ָ����UIQI�����Ը���ϸ�ļ�Ȩƽ����ʽ�������ں�ͼ���UIQI��
%PFQM��ϵ������ͼ���ں�����ָ����Image Fusion Quality Index�� IFQI������Ȩ�ں�����ָ����Weighted Fusion Quality Index�� WFQI���ͱ�Ե����ں�����ָ����Edge-dependent Fusion Quality Index�� EFQI����
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
 
%%%����һ��W*H�Ļ��д��� ----A��F
 
QAF1 = zeros(MA - halfW,NA - halfH);
 
for i = halfH:MA- halfW
    for j = halfW:NA- halfH
        PA = A2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PF = F2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PB = B2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        QAF1(i - 1,j - 1) = get_Q(PA,PF,W,H);
 
    end
end
 
%%%%����һ��W*H�Ļ��д��� ----B��F
 
QBF1 = zeros(MA - halfW,NA - halfH);
 
for i = halfH:MB- halfH
    for j = halfW:NB- halfW
        PB = B2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PF = F2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        QBF1(i - 1,j - 1) = get_Q(PB,PF,W,H);
 
    end
end
 
%%%�󷽲�s��A|W) �� s��B|W) 
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
%%%Ȩ��LA 
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
%%%Ȩ��LB
for i = 1:MA - halfH
    for j = 1:NA - halfW
 
if( s(i,j) == 0 )
    LB(i,j) = 0;
else
    LB(i,j) = sB(i,j)/s(i,j);
end
    end
end
% %%%%��IFQI
IFQI1 = sum(sum(LA.*QAF1));
IFQI2 = sum(sum(LB.*QBF1));
IFQI3 = IFQI1 + IFQI2;
IFQI = IFQI3/M;
Q=IFQI;
 
%%%%��WFQI
 
WFQI = sum(sum(c.*(LA.*QAF1))) + sum(sum(c.*(LB.*QBF1)));
Qw=WFQI;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��Եͼ��%%%%%%%%%%%%%%%%%%%%%%%
 
%%%����һ��W*H�Ļ��д��� ----BW1��BW3
 
QBW13 = zeros(MA1- halfH,NA1- halfW);
 
for i = halfH:MA1- halfH
    for j = halfW:NA1- halfW
        PA1 = BW1(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PF1 = BW3(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PB1 = BW2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        QBW13(i - 1,j - 1) = get_Q(PA1,PF1,W,H);
 
    end
end
 
%%%%����һ��W*H�Ļ��д��� ----BW2��BW3
 
QBW23 = zeros(MB1- halfH,NB1- halfW);
 
for i = halfH:MB1- halfH
    for j = halfW:NB1- halfW
        PB1 = BW2(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        PF1 = BW3(i - (halfH-1):i + (halfH-1),j - (halfW-1):j + (halfW-1) );
        QBW23(i - 1,j - 1) = get_Q(PB1,PF1,W,H);
 
    end
end
 
%%%�󷽲�s1��A|W) �� s1��B|W) 
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
%%%Ȩ��LA1
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
%%%Ȩ��LB1
for i = 1:MB1 - halfW
    for j = 1:NB1 - halfW
 
if( s1(i,j) == 0 )
    LB1(i,j) = 0;
else
    LB1(i,j) = sB1(i,j)/s1(i,j);
end
    end
end
% %%%%��IFQI0
IFQI10 = sum(sum(LA1.*QBW13));
IFQI20 = sum(sum(LB1.*QBW23));
IFQI30 = IFQI10 + IFQI20;
IFQI0 = IFQI30/M;
 
%%%%��WFQI0
 
WFQI0 = sum(sum(c1.*(LA1.*QBW13))) + sum(sum(c1.*(LB1.*QBW23)));
 
%%%%��EFQI
a = 1;
EFQI = WFQI^(1 - a ) * WFQI0^a;
Qe=EFQI;
