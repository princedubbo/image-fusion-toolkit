clear all;
close all;
imageName='barb1';
image=imread(strcat(imageName,'.bmp'));
blkSize=[8,8];             %对应的patch大小
figure;
imshow(image);
[N1,N2]=size(image);
image=double(image);

%% Create Dictionary with training signals: 
N = blkSize(1)^2;      % number of pixels in patch
s = 4;                 %dimension of blocks
k = 4;
K = 4*N;               %Number of columns in dictionary
max_it = 50;           %Nr of iterations for the algorithm to converge. 
%% 选择训练样本，当样本过多的时候，随机选择10000个样本出来
Ys = im2col(image,blkSize,'sliding');

if size(Ys,2)>10000
    randd=randperm(size(Ys,2));
    randd=randd(1:10000);
    Y=Ys(:,randd);
end

D = randn(size(Y,1),K);%64*256

%初始化字典D。。。
D = D ./  repmat(sqrt(sum(D.^2)),size(Y,1),1);
%%
fid = fopen('data.txt','a');

%% Ksvd字典
[D1,d1] = ksvdTrainD(D, Y,K,k*s,max_it);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_ksvd_dictionary','_s',...
    num2str(s),'_k',num2str(k)),'D1','d1');

X1= simult_sparse_coding(D1,Ys,d1,k*s,1);
Ycomp1 = D1*X1;
ima1=patch2image(Ycomp1,blkSize,size(image));
diff_Ksvd_Original=image-ima1;
val_Ksvd_Original=sum(sum(abs(diff_Ksvd_Original)));
fprintf(fid,'%s\t','ksvd-original');
fprintf(fid, '%g\n', val_Ksvd_Original);

%% Bksvd_Cluster
[D4,d4] = BksvdClusterTrainD(D,Y,K,k,s,max_it);
% save(strcat(imageName,'_dictionary','_s',num2str(s),'_k',num2str(k)),'D1','d2');
save(strcat(imageName,'_BksvdCluster_dictionary','_s',...
    num2str(s),'_k',num2str(k)),'D4','d4');

X4 = simult_sparse_coding(D4,Ys,d4,k,1);
Ycomp4 = D4*X4;
ima4=patch2image(Ycomp4,blkSize,size(image));
diff_Cluster_Original=image-ima4;
val_Cluster_Original=sum(sum(abs(diff_Cluster_Original)));

fprintf(fid,'%s\t','BksvdCluster-original');
fprintf(fid, '%g\n', val_Cluster_Original);


%%  这里设置ds（0.3-0.9）和rs（0.4-0.95）的值

fprintf(fid,'%s\n','BksvdCluster_lowSim-original');
for ds = 0.2:0.05:0.9
    for rs = 0.4:0.05:0.95
        for j = 1:3
            [D5,d5] = BksvdCluster_lowSim_DsRs_TrainD(D,Y,K,k,s,max_it,ds,rs);
            save(strcat(imageName,'_BksvdCluster_lowSim_dictionary','_s',...
            num2str(s),'_k',num2str(k),'DsRs_',num2str(ds),num2str(rs),num2str(j)),'D5','d5');
            X5 = simult_sparse_coding(D5,Ys,d5,k,1);
            Ycomp5 = D5*X5;
            ima5=patch2image(Ycomp5,blkSize,size(image));
            diff_Cluster_lowSim_Original=image-ima5;
            val_Cluster_lowSim_Original=sum(sum(abs(diff_Cluster_lowSim_Original)));
            
            fprintf(fid, '%s\t', 'ds');
            fprintf(fid, '%g\t', ds);
            fprintf(fid, '%s\t', 'rs');
            fprintf(fid, '%g\t', rs);
            fprintf(fid, '%g\n', val_Cluster_lowSim_Original);
        end
    end
end

%% 关闭文件
fclose(fid);