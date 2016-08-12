photo2 = ones(110,140);
hang = [1 4 9 13 17 21 25 28 31 34 37 40 42 45 47 49  51 53 55 57 59 60 62 64 65 67 68 69 72 73 74 75 76 77 78 79  80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110];
ihang = [2 3 5 6 7 8 10 11 12 14 15 16 18 19 20 22 23 24 26 27 29 30 32 33 35 36 38 39 41 43 44 46 48 50 52 54 56 58 61 63 66 70 71];

for i = 1:1:110
    for j = 1:1:140
        photo2(i,j) = photo1(i,j);
    end
end

for i = 1:1:140
    photo2(2,i) = (photo1(1,i)+photo1(5,i))/2;
    photo2(3,i) = (photo1(1,i)+photo1(5,i))/2;
    photo2(4,i) = (photo1(1,i)+photo1(5,i))/2;
    photo2(6,i) = (photo1(5,i)+photo1(10,i))/2;
    photo2(7,i) = (photo1(5,i)+photo1(10,i))/2;
    photo2(8,i) = (photo1(5,i)+photo1(10,i))/2;
    photo2(9,i) = (photo1(5,i)+photo1(10,i))/2;
    photo2(11,i) = (photo1(10,i)+photo1(15,i))/2;
    photo2(12,i) = (photo1(10,i)+photo1(15,i))/2;
    photo2(13,i) = (photo1(10,i)+photo1(15,i))/2;
    photo2(14,i) = (photo1(10,i)+photo1(15,i))/2;
    photo2(16,i) = (photo1(15,i)+photo1(19,i))/2;
    photo2(17,i) = (photo1(15,i)+photo1(19,i))/2;
    photo2(18,i) = (photo1(15,i)+photo1(19,i))/2;
    photo2(20,i) = (photo1(19,i)+photo1(23,i))/2;
    photo2(21,i) = (photo1(19,i)+photo1(23,i))/2;
    photo2(22,i) = (photo1(19,i)+photo1(23,i))/2;
    photo2(24,i) = (photo1(23,i)+photo1(26,i))/2;
    photo2(25,i) = (photo1(23,i)+photo1(26,i))/2;
    photo2(27,i) = (photo1(26,i)+photo1(30,i))/2;
    photo2(28,i) = (photo1(26,i)+photo1(30,i))/2;
    photo2(29,i) = (photo1(26,i)+photo1(30,i))/2;
    photo2(31,i) = (photo1(30,i)+photo1(33,i))/2;
    photo2(32,i) = (photo1(30,i)+photo1(33,i))/2;
    photo2(34,i) = (photo1(33,i)+photo1(36,i))/2;
    photo2(35,i) = (photo1(33,i)+photo1(36,i))/2;
    photo2(37,i) = (photo1(36,i)+photo1(39,i))/2;
    photo2(38,i) = (photo1(36,i)+photo1(39,i))/2;
    photo2(40,i) = (photo1(39,i)+photo1(41,i))/2;
    photo2(42,i) = (photo1(41,i)+photo1(44,i))/2;
    photo2(43,i) = (photo1(41,i)+photo1(44,i))/2;
    photo2(45,i) = (photo1(44,i)+photo1(46,i))/2;
    photo2(47,i) = (photo1(46,i)+photo1(49,i))/2;
    photo2(48,i) = (photo1(47,i)+photo1(49,i))/2;
    photo2(50,i) = (photo1(49,i)+photo1(51,i))/2;
    photo2(52,i) = (photo1(51,i)+photo1(53,i))/2;
    photo2(54,i) = (photo1(53,i)+photo1(55,i))/2;
    photo2(56,i) = (photo1(55,i)+photo1(57,i))/2;
    photo2(58,i) = (photo1(57,i)+photo1(59,i))/2;
    photo2(61,i) = (photo1(60,i)+photo1(62,i))/2;
    photo2(63,i) = (photo1(62,i)+photo1(64,i))/2;
    photo2(66,i) = (photo1(65,i)+photo1(67,i))/2;
    photo2(70,i) = (photo1(69,i)+photo1(71,i))/2;
    photo2(76,i) = (photo1(75,i)+photo1(77,i))/2;
end
