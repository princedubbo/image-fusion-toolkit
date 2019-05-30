clear all;
close all;
imageName='lena';
load(strcat(imageName,'_ksvd_representation_s4_k4.mat'));
x = X1~=0;
s = sum(x,2);
figure;
% 画出字典中对应的元素在整幅图像中使用的频率
bar((1:256),s);
x1 = X1<0;
s1 = sum(x1, 2);
figure;
bar(1:256,s1);
x2 = X1>0;
s2 = sum(x2, 2);
figure;
bar(1:256,s2);
x3 = x2 - x1;
figure
s3 = sum(x3, 2);
bar(1:256, s3);

% 随机选择一些pach进行显示
figure;
indices1 = find(X1(:,1));
bar(indices1, X1(indices1,1));
figure;
indices2 = find(X1(:,1361));
bar(indices2, X1(indices2,1361));
figure;
indices3 = find(X1(:,12227));
bar(indices3, X1(indices3,12227));
figure;
indices4 = find(X1(:,52100));
bar(indices4, X1(indices4,52100));
figure;
indices5 = find(X1(:,62000));
bar(indices5, X1(indices5,62000));



