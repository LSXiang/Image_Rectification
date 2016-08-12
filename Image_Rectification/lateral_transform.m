photo4 = ones(110,140); 


for i = 1:1:110
    for j = 1 : 1 : sizeofRow(i)*2
        photo4(i,70- sizeofRow(i)+j) = photo3(i,lateral_correction_array(i,70-sizeofRow(i)+j));
    end
end