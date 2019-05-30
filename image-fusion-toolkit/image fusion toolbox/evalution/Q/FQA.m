function [Q0,Qw,Qe,Qabf,vif1,vif2,MI1,MI2] = FQA(VL, IR, Fusion)

B=5;
Q0 = fqiQ(VL,IR,Fusion,B);
Qw = wfq(VL,IR,Fusion,B);
Qe = efq(VL,IR,Fusion,B);
Qabf =QABF(VL,IR,Fusion);
vif1 = vifvec(VL, Fusion);
vif2 = vifvec(IR, Fusion);
MI1 = 0;
MI2 = 0;
% MI1 = mutual_inf(VL,Fusion);
% MI2 = mutual_inf(IR,Fusion);

end
