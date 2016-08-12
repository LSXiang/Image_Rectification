% C车的纵向矫正脚本

%矫正参数
camHeight = 293;                %摄像头的高度                     //276
nearSight = 148;                %近处视野摄像头到支架距离          //116
viewLength = 1770;              %视野纵向长度                     //1400
gView2View = 456;               %地视点 和 视点 之间的距离         //446

FI = ones(110,1);
BI = ones(110,1);
IG = ones(110,1);
AH = ones(110,1);
FG = ones(110,1);

viewAngle = acos(camHeight/gView2View);     %摄像头成像面 倾角---单位是rad
agleBAC = atan(camHeight/nearSight);
agleF = pi - viewAngle - agleBAC;

DB = sqrt(camHeight * camHeight + (viewLength + nearSight) * (viewLength + nearSight));
AB = sqrt(camHeight * camHeight + nearSight * nearSight);

DF = (sin(agleBAC)/sin(agleF)) * viewLength;    
AF = (sin(viewAngle)/sin(agleF)) * viewLength;
BF = AF + AB ;

for i = 1 : 1 : 110
    FG(i) = (i)*DF/110;
	FI(i) = (sin(viewAngle)/sin(agleBAC)) * FG(i);
	IG(i) = (sin(agleF)/sin(agleBAC)) * FG(i);
	BI(i) = BF-FI(i);    
	AH(i) = AB * IG(i) /BI(i);
end

%view2real
view2real = ones(1,110);

for i = 1 : 1 : 110
    view2real(111-i) = floor(AH(i)*110/1770);
end

%view2real
View2real = ones(1,110);
for i = 1 : 1 : 110
    View2real(111-i) = view2real(i);
end












