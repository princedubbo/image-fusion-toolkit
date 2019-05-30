clear all;
fid = fopen('data.txt','w');
fprintf(fid,'%s\t','ksvd-original');
n = 1000000;
fprintf(fid, '%g\n', n);
fclose(fid);