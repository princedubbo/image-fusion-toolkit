function [A1, A2]=SOMP(D,X1,X2,L)
%=============================================
% Sparse coding of a group of signals based on a given 
% dictionary and specified number of atoms to use. 
% input arguments: 
%       D - the dictionary (its columns MUST be normalized).
%       X - the signals to represent
%       L - the max. number of coefficients for each signal.
% output arguments: 
%       A - sparse coefficient matrix.
%=============================================
[n,P]=size(X1);%n��һ���źŵ�ά����p���źŵĸ���
[n,K]=size(D);%K����Ӧ���ֵ���Ŀ
h=waitbar(0,'SOMP');
tic
for k=1:1:P,%�ҳ�ÿ���źŵ�ϡ���ʾ
    a=[];
    x1=X1(:,k);%��Ӧ���źţ���������
    x2=X2(:,k);
    residual1=x1;
    residual2=x2;
    indx=zeros(L,1);
    for j=1:1:L,
        proj1=D'*residual1;
        proj2=D'*residual2;
        [maxVal,pos]=max(abs(proj1)+abs(proj2));%�����ҳ���Ӧ������ֵ��ʾ����һ��
        pos=pos(1);
        indx(j)=pos;
        a1=pinv(D(:,indx(1:j)))*x1;%ΪʲôҪ������氡���������������е�ϡ��ϡ���£�
        %�ҵ���С�������ı�ʾ������
        a2=pinv(D(:,indx(1:j)))*x2;
        residual1=x1-D(:,indx(1:j))*a1;
        residual2=x2-D(:,indx(1:j))*a2;
        if sum(residual1.^2) < 1e-6 && sum(residual1.^2) < 1e-6
            break;
        end
    end;
    temp=zeros(K,1);
    temp(indx(1:j))=a1;
    A1(:,k)=sparse(temp);
    temp(indx(1:j))=a2;
    A2(:,k)=sparse(temp);
    waitbar(k/P);
end;
close(h);
toc
return;
