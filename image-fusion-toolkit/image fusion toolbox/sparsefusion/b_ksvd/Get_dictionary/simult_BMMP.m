function [X, C] = simult_BMMP(D, B, dd, max_it, find_X)

%written by Kevin Rosenblum, 2007-2008
%kevin@technion.ac.il
%其中max_it表示为每列的稀疏性
K = size(D,2);%字典的原子数
L = size(B,2);%样本矩阵的列数，即有多少个patch
BL = size(dd,1);%BL=K
cols = false(L,K); 
r = zeros(BL,L);%稀疏表示系数矩阵的维数相同
B0 = B; %样本矩阵
X = zeros(K,L);%稀疏表示系数矩阵的维数相同

for p=1:max_it
    rr= D'*B;%%???
    for i = 1:BL, r(i,:) = sum(rr(dd(i,:),:).^2,1); end
    [mx, arg] = max(r);
    if p==1
        for l = 1:BL
            samps = (arg==l);
            cols(samps,dd(l,:)) = true;
            if (p==max_it && ~find_X), continue, end;
                [Q R] = qr(D(:,dd(l,:)),0);
            if p<max_it, B(:,samps)  = B(:,samps) -Q*(Q'*B(:,samps) ); end
            if find_X && p==max_it, X(dd(l,:),samps) = R\(Q'*B0(:,samps)); end
        end
        arg_prev = arg;
    elseif p==2
        arg_new = sort([arg;arg_prev],1);
        for l = 1:BL
            sampsl = arg_new(1,:)==l;
            for t = l+1:BL
                ddd = dd(l,:)|dd(t,:);
                samps = (sampsl & arg_new(2,:)==t);
                cols(samps,ddd) = true;
                if (p==max_it && ~find_X), continue, end;
                [Q R] = qr(D(:,ddd),0);
                if p<max_it, B(:,samps)  = B(:,samps) -Q*(Q'*B(:,samps) ); end
                if find_X && p==max_it, X(ddd,samps) = R\(Q'*B0(:,samps)); end
            end
        end
    else
        for l = 1:L
            cols(l,dd(arg(l),:)) = true;
            if (p==max_it && ~find_X), continue, end;
            [Q R] = qr(D(:,cols(l,:)),0);
            if p<max_it, B(:,l) = B(:,l)-Q*(Q'*B(:,l)); end
            if find_X && p==max_it, X(cols(l,:),l) = R\(Q'*B0(:,l)); end
        end
    end
end
C = false(L,BL); for i = 1:BL, C(:,i) = sum(cols(:,dd(i,:)),2)>0;end
