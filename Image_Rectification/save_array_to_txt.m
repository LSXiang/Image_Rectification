fid=fopen('E:\My_Project\Matlab_Of_Stady_Journey\Image_Rectification\lateral_correction_array.txt','wt');%д���ļ�·��
[m,n]=size(lateral_correction_array);                   %��ȡ����Ĵ�С��pΪҪ����ľ���
for i=1:1:m
if mod(i,2)==0
%fprintf(fid,'water levle since %d hours\n',i/100-1); 
end
for j=1:1:n
if j==n                    %���һ�еĸ����ﵽn�����У�����ո�
fprintf(fid,'%d,\n',lateral_correction_array(i,j)); 
else
fprintf(fid,'%d,\t',lateral_correction_array(i,j));
end
end
end
fclose(fid); 