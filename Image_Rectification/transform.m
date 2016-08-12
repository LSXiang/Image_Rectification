photo = imread('a.bmp');
photo1 = ones(110,140); 

for i = 1:1:140
    for j = 1:1:110
        if photo1(ddd((i-1)*110+j,2)+1,ddd((i-1)*110+j,1)+1) == 1
            photo1(ddd((i-1)*110+j,2)+1,ddd((i-1)*110+j,1)+1) = ( photo(j,i) + photo1(ddd((i-1)*110+j,2)+1,ddd((i-1)*110+j,1)+1) );
        else
            photo1(ddd((i-1)*110+j,2)+1,ddd((i-1)*110+j,1)+1) = photo(j,i);
        end
    end
end


