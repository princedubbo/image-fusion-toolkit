function c = get_c(sB,sA,MA1,NA1,W,H)
for i = 2:MA1
    for j = 2:NA1
        PA = A2(i - (2-1):i + (2-1),j - (2-1):j + (2-1) );
        PB = B2(i - (2-1):i + (2-1),j - (2-1):j + (2-1) );
        sB(i - 1,j - 1) = get_s(PB,W,H);
        sA(i - 1 ,j - 1) = get_s(PA,W,H);
        C(i - 1,j - 1) = max(sA,sB);
    end
end