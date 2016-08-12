photo1 = imread('Ö±µÀ.bmp');
photo5 = ones(110,140); 

vretical_correction_array = [0 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 7 7 7 8 8 8 9 9 9 10 10 10 11 11 11 12 12 13 13 14 14 15 15 16 16 17 17 18 18 19 19 20 20 21 22 22 23 24 24 25 26 27 28 28 29 30 31 32 33 34 35 36 37 38 40 41 42 43 45 46 48 49 51 52 54 56 58 60 63 65 67 70 72 75 78 81 84 88 92 96 101 106];

for i = 1:1:110
    for j = 1:1:sizeofRow(i)*2
        photo5(i,70- sizeofRow(i)+j) = photo1(vretical_correction_array(i)+1,lateral_correction_array(i,70-sizeofRow(i)+j));
    end
end
