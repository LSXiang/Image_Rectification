% C车的横向矫正脚本

vision = ones(110,1);
sizeofRow = ones(110,1);
a = ones(110,1);
b = ones(110,1);
lateral_correction_array = ones(110,150);

%下面参数的量纲 cm
farSight  = 177;                   %145 
nearSight = 0;
farWidth  = 254;                   %220
nearWidth = 51;                    %45

row = 110;              %总共有110行
column = 25;            %最远处 多少cm 对应 column 列

tanxita = (farWidth - nearWidth)/(2*(farSight-nearSight));

for i = 1 : 1 : 110
    vision(i) = (((farSight-nearSight)/110)*(110 - i))*tanxita*2+nearWidth;
    sizeofRow(i) = round( (vision(i)*column)/40 );
end


for i = 1 : 1 : 110
    if sizeofRow(i) > 150
        sizeofRow(i) = 150;
    end
    %  y = a*x + b
    a(i) = 150/sizeofRow(i);
    b(i) = - a(i) * (75 - 0.5*sizeofRow(i));
end

%矫正系数表
correction_array = ones(110,1);

%校正系数设计

%for i = 1 : 1 : 110
%    if i < 66
%        correction_array(i) = 2*round( 0.25*(sqrt(65*65-(66-i)*(66-i))-i*55/110) ); 
%    else
%        correction_array(i) = 2*round( 0.25*(sqrt(66*66-(i-66)*(i-66))-i*55/110)+1);
%    end
%end


%从新修正sizeofRow
for i = 1 : 1 : 110
   sizeofRow(i) = floor( 0.5* (sizeofRow(i) ));%- correction_array(i)));
end



for i = 1 : 1 : 110
    for j = round( (76 - sizeofRow(i) ) ) : 1 : round( 75 + sizeofRow(i) )
        lateral_correction_array(i,j) = floor( a(i)*j+b(i) );
    end
end



for i = 1 : 1 : 110
    for j = 1 : 1 : 150
      lateral_correction_array(i,j) = lateral_correction_array(i,j) - 1;
    end
end




