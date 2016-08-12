fid=fopen('E:\My_Project\Matlab_Of_Stady_Journey\Image_Rectification\lateral_correction_array.txt','wt');%写入文件路径
[m,n]=size(lateral_correction_array);                   %获取矩阵的大小，p为要输出的矩阵
for i=1:1:m
if mod(i,2)==0
%fprintf(fid,'water levle since %d hours\n',i/100-1); 
end
for j=1:1:n
if j==n                    %如果一行的个数达到n个则换行，否则空格
fprintf(fid,'%d,\n',lateral_correction_array(i,j)); 
else
fprintf(fid,'%d,\t',lateral_correction_array(i,j));
end
end
end
fclose(fid); 