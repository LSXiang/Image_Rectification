sss = ones(110*140,2);
for i = 0 : 1 : 110*140-1 
    sss(i+1,1) = floor(i/110);
    sss(i+1,2) = round(mod(i,110));
end


