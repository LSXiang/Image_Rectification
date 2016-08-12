for i = 1:1:110
    for j = 1:1:140
        if photo(i,j)>110
            photo(i,j) = 255;
        else
            photo(i,j) = 0;
        end
    end
end
