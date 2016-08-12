% C车的横向矫正脚本

vision = ones(110,1);
sizeofRow = ones(110,1);
a = ones(110,1);
b = ones(110,1);
lateral_correction_array = ones(110,140);

%下面参数的量纲 cm
farSight  = 145; 
nearSight = 0;
farWidth  = 220;
nearWidth = 45;

row = 110;              %总共有110行
column = 30;            %最远处 多少cm 对应 column 列

tanxita = (farWidth - nearWidth)/(2*(farSight-nearSight));

for i = 1 : 1 : 110
    vision(i) = (((farSight-nearSight)/110)*(110 - i))*tanxita*2+nearWidth;
    sizeofRow(i) = round( (vision(i)*column)/45 );
end


for i = 1 : 1 : 110
    if sizeofRow(i) > 140
        sizeofRow(i) = 140;
    end
    %  y = a*x + b
    a(i) = 140/sizeofRow(i);
    b(i) = - a(i) * (70 - 0.5*sizeofRow(i));
end

%矫正系数表
correction_array = ones(110,1);

%校正系数设计
for i = 1 : 1 : 110
    if i < 66
        correction_array(i) = 2*round( 0.25*(sqrt(65*65-(66-i)*(66-i))-i*55/110) ); 
    else
        correction_array(i) = 2*round( 0.25*(sqrt(66*66-(i-66)*(i-66))-i*55/110)+1);
    end
end


%从新修正sizeofRow
for i = 1 : 1 : 110
   sizeofRow(i) = floor( 0.5* (sizeofRow(i) - correction_array(i)));
end



for i = 1 : 1 : 110
    for j = round( (71 - sizeofRow(i) ) ) : 1 : round( 70 + sizeofRow(i) )
        lateral_correction_array(i,j) = floor( a(i)*j+b(i) );
    end
end



for i = 1 : 1 : 110
    for j = 1 : 1 : 140
%      lateral_correction_array(i,j) = lateral_correction_array(i,j) - 1;
    end
end

photo1 = imread('a.bmp');
photo = ones(110,140); 

vretical_correction_array = [0 0 0 0 0 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 7 7 7 8 8 8 9 9 9 10 10 10 11 11 11 12 12 13 13 14 14 15 15 16 16 17 17 18 18 19 19 20 20 21 22 22 23 24 24 25 26 27 28 28 29 30 31 32 33 34 35 36 37 38 40 41 42 43 45 46 48 49 51 52 54 56 58 60 63 65 67 70 72 75 78 81 84 88 92 96 101 106];

for i = 1:1:110
    for j = 1:1:sizeofRow(i)*2
        photo(i,70- sizeofRow(i)+j) = photo1(vretical_correction_array(i)+1,lateral_correction_array(i,70-sizeofRow(i)+j));
    end
end

% for i = 1:1:110
%     for j = 1:1:140
%         if photo(i,j)>105
%             photo(i,j) = 255;
%         else
%             photo(i,j) = 0;
%         end
%     end
% end

%MIDLINE_EXTRACTION 该函数用于提取赛道中线
%version  1.0
%author   TJiTR__LSXiang
%date     2015-4-30

%下面变量运行时候在函数外定义声明
track_width = 31;                       %赛道宽度为30个像素点宽
midline_coordinate_array = ones(110,2); %中线坐标数组
left_border_buf = [0 0];                %左边界左边暂存区
left_border_flag = 0;                   %左边界寻找标记。1：寻到左边界； 0：未寻到左边界
right_border_buf = [0 0];               %左边界左边暂存区
right_border_flag = 0;                  %右边界寻找标记。1：寻到左边界； 0：未寻到左边界
last_midline_coordinate = [70 110];     %上一中点的坐标
special_treatment = 0;                  %特殊处理代号
special_coordinate = [0 0];             %特殊位置
last_special_row = 0;                   %前一次的特殊行
special_count = 0;                      %特殊情况次数
left_margin_loss_flag = 0;              %左边界丢失标记
right_margin_loss_flag = 0;             %右边界丢失标记
upside_flag = 0;                        %上边界
below_flag = 0;                         %下边界


left_border_buf(1) =  55;
right_border_buf(1) = 85;
%主要算法如下：
for z = 1:1:110
    i = 111 - z;
    left_border_flag = 0;
    right_border_flag = 0;
    left_margin_loss_flag = 0;            
    right_margin_loss_flag = 0;
    for j = 1:1:sizeofRow(i)*2
        if( (left_border_flag && right_border_flag)==0 && (left_border_flag && right_margin_loss_flag)==0 && (left_margin_loss_flag && right_border_flag)==0 && (left_margin_loss_flag && right_margin_loss_flag)==0 )
            if z < 80
                %寻找赛道左边界
                if left_border_flag == 0
                    if((last_midline_coordinate(1) - j) > (70 - sizeofRow(i)))
                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                            left_border_flag = 1;                                           %标记寻到赛道左边界
                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %存左边界x坐标
                            left_border_buf(2) = i;                                         %存左边界y坐标
                        end
                    else
                        left_margin_loss_flag = 1;
                    end
                end
                %寻找赛道右边界
                if right_border_flag == 0
                    if((last_midline_coordinate(1) + j) < (70 + sizeofRow(i)))
                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                            right_border_flag = 1;                                          %标记寻到赛道右边界
                            right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                            right_border_buf(2) = i;
                        end
                    else
                        right_margin_loss_flag = 1;
                    end
                end                
            else
                %寻找赛道左边界
                if left_border_flag == 0
                    if((last_midline_coordinate(1) - j) > (75 - sizeofRow(i)))
                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                            left_border_flag = 1;                                           %标记寻到赛道左边界
                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %存左边界x坐标
                            left_border_buf(2) = i;                                         %存左边界y坐标
                        end
                    else
                        left_margin_loss_flag = 1;
                    end
                end
                %寻找赛道右边界
                if right_border_flag == 0
                    if((last_midline_coordinate(1) + j) < (65 + sizeofRow(i)))
                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                            right_border_flag = 1;                                          %标记寻到赛道右边界
                            right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                            right_border_buf(2) = i;
                        end
                    else
                        right_margin_loss_flag = 1;
                    end
                end
            end                
        else
            break;               
        end       
    end
    
    if (left_border_flag && right_border_flag)                                  %两边都寻到边界
        if( last_midline_coordinate(1)-left_border_buf(1)<4)                    %判断是否出现单引导线
            if( right_border_buf(1)-last_midline_coordinate(1)<4)               %判断是否出现单引导线（两边都找到单引线）
                if(photo(left_border_buf(2),left_border_buf(1)-3)==0)&&(photo(left_border_buf(2),left_border_buf(1)-2)==0) && (photo(right_border_buf(2),right_border_buf(1)+2)==0) && (photo(right_border_buf(2),right_border_buf(1)+3)==0)      %判断是否出现黑杠
                    special_treatment = 6;                                      %特殊处理 6（直角黑线）
                    break;
                else
                    midline_coordinate_array(111-i,1) = floor(0.5*(left_border_buf(1)+right_border_buf(1)));
                    midline_coordinate_array(111-i,2) = floor(0.5*(left_border_buf(2)+right_border_buf(2)));
                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                end
            else                                                                %判断是否出现单引导线（单引线在左边）
                if(photo(left_border_buf(2),left_border_buf(1)-3)==0)&&(photo(left_border_buf(2),left_border_buf(1)-2)==0) && (photo(left_border_buf(2),left_border_buf(1)+2)==0)&&(photo(left_border_buf(2),left_border_buf(1)+3)==0)      %判断是否出现黑杠
                    special_treatment = 6;                                      %特殊处理 6（直角黑线）
                    break;
                else
                    midline_coordinate_array(111-i,1) = left_border_buf(1);
                    midline_coordinate_array(111-i,2) = left_border_buf(2);
                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                end
            end
        else if( right_border_buf(1)-last_midline_coordinate(1)<4)              %判断是否出现单引导线（单引线在右边）
                if(photo(right_border_buf(2),right_border_buf(1)+2)==0) && (photo(right_border_buf(2),right_border_buf(1)+3)==0) && (photo(right_border_buf(2),right_border_buf(1)-2)==0) && (photo(right_border_buf(2),right_border_buf(1)-3)==0)      %判断是否出现黑杠
                    special_treatment = 6;                                       %特殊处理 6（直角黑线）
                    break;
                else
                    midline_coordinate_array(111-i,1) = right_border_buf(1);
                    midline_coordinate_array(111-i,2) = right_border_buf(2);
                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                end
            else if( right_border_buf(1)-left_border_buf(1) <= 20)               %判断是否出现障碍或者出完黑线
                    special_treatment = 1;                                       %特殊处理 1
                    break;
                else
                    midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                    midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                end
            end
        end               
    else if( (left_border_flag==0) && (right_border_flag==0) )                  %两边都未寻到边界
            if i<100
                midline_coordinate_array(111-i-2,1) = floor((midline_coordinate_array(111-i-2,1)+midline_coordinate_array(111-i-3,1))/2);
                midline_coordinate_array(111-i-1,1) = floor((midline_coordinate_array(111-i-1,1)+midline_coordinate_array(111-i-2,1))/2);
                last_midline_coordinate(1) = midline_coordinate_array(111-i-1,1);
            end
            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
            midline_coordinate_array(111-i,2) = i;
            left_border_buf(2) = i;
            right_border_buf(2) = i;
        else if( (left_border_flag==1) && (right_border_flag==0) )              %左边界寻到，右边界丢失 
                if( last_midline_coordinate(1)-left_border_buf(1)<4)            %判断是否出现单引导线
                    midline_coordinate_array(111-i,1) = left_border_buf(1);
                    midline_coordinate_array(111-i,2) = left_border_buf(2);
                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                %else if( right_border_buf(1)-last_midline_coordinate(1)<4)      %判断是否出现单引导线
                     %   midline_coordinate_array(111-i,1) = right_border_buf(1);
                     %   midline_coordinate_array(111-i,2) = right_border_buf(2);
                     %   last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                     %   last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                    else if( left_border_buf(1) + track_width -( 70 + sizeofRow(i)) >= 5 )      %视野外
                            if i < 100                  %排除障碍干扰
                                special_treatment = 2;                              %特殊处理 2：右边界丢失且视野外
                                break;
                            else
                                right_border_buf(1) = left_border_buf(1) + track_width;
                                right_border_buf(2) = left_border_buf(2);
                                midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)-2;
                                midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            end
                        else if(left_border_buf(1) + track_width -( 70 + sizeofRow(i)) <= -5)   %视野内                                
                                 if special_count >= 4                          %遇到特殊情况次数记录  （次数为‘>=’后数加1）
                                    special_treatment = 3;                          %特殊处理 3：右边界丢失且视野内
                                    break;
                                else
                                    if i == last_special_row - 1           %判断特殊情况出现是否连续，避免误判
                                        special_count = special_count + 1;      %记录特殊情况出现次数
                                        last_special_row = last_special_row -1; %记录特殊行
                                        midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                        midline_coordinate_array(111-i,2) = i;
                                    else
                                        special_count = 0;                      %判断特殊情况出现不连续，清0
                                        last_special_row = i;                   %记录特殊行
                                        special_coordinate(1) = right_border_buf(1); %记录特殊列
                                        special_coordinate(2) = i;                   %记录特殊行
                                        midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                        midline_coordinate_array(111-i,2) = i;
                                    end
                                 end                              
                            else
                                right_border_buf(1) = left_border_buf(1) + track_width;
                                right_border_buf(2) = left_border_buf(2);
                                midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            end
                        end
                    %end
                end
            else if( (left_border_flag==0) && (right_border_flag==1) )          %右边界寻到，左边界丢失
                    %if( last_midline_coordinate(1)-left_border_buf(1)<4)        %判断是否出现单引导线
                        %midline_coordinate_array(111-i,1) = left_border_buf(1);
                        %midline_coordinate_array(111-i,2) = left_border_buf(2);
                        %last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                        %last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                    %else 
                    if( right_border_buf(1)-last_midline_coordinate(1)<4)  %判断是否出现单引导线
                            midline_coordinate_array(111-i,1) = right_border_buf(1);
                            midline_coordinate_array(111-i,2) = right_border_buf(2);
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        else if( right_border_buf(1) - track_width -( 70 - sizeofRow(i)) <= -5 )    %视野外
                                if i < 100           %排除障碍干扰
                                    special_treatment = 4;                          %特殊处理 4：左边界丢失且视野外
                                    break;
                                else
                                    left_border_buf(1) = right_border_buf(1)-track_width;
                                    left_border_buf(2) = right_border_buf(2);
                                    midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)+2;
                                    midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                end
                            else if(right_border_buf(1) - track_width -( 70 - sizeofRow(i)) >= 5)   %视野内
                                    if special_count >= 4;                          %遇到特殊情况次数记录  （次数为‘>=’后数加1）
                                        special_treatment = 5;                      %特殊处理 5：左边界丢失且视野内
                                        break;
                                    else
                                        if i == last_special_row - 1           %判断特殊情况出现是否连续，避免误判
                                            special_count = special_count + 1;      %记录特殊情况出现次数
                                            last_special_row = last_special_row -1; %记录特殊行
                                            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                            midline_coordinate_array(111-i,2) = i;
                                        else
                                            special_count = 0;                      %判断特殊情况出现不连续，清0
                                            last_special_row = i;                   %记录特殊行
                                            special_coordinate(1) = left_border_buf(1); %记录特殊列
                                            special_coordinate(2) = i;                  %记录特殊行
                                            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                            midline_coordinate_array(111-i,2) = i;
                                        end
                                    end
                                else
                                    left_border_buf(1) = right_border_buf(1)-track_width;
                                    left_border_buf(2) = right_border_buf(2);
                                    midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                    midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                end
                            end
                        %end
                    end
                end
            end
        end
    end
    
    if special_treatment ~= 0                   %出现特殊处理标记，则退出循环，进入对应特殊处理程序
        break;
    end
    
    %中线出现在图像边界，则退出循环。（用于单引线）
    if ((midline_coordinate_array(111-i,1) - (70 - sizeofRow(i)) <= 5)) || (((70 + sizeofRow(i) - midline_coordinate_array(111-i,1)) <= 5))
        break;
    end
    
end




switch special_treatment
    case 1
        special_coordinate(1) = floor(0.5*(right_border_buf(1)+left_border_buf(1))); %记录特殊列
        special_coordinate(2) = i;                  %记录特殊行
        last_midline_coordinate(1) = special_coordinate(1);
        last_midline_coordinate(2) = special_coordinate(2);
        
        if special_coordinate(2) > 30 
            %判断是否是出弯道黑横杠
            if((photo(special_coordinate(2)-15,special_coordinate(1)-2)==0)&&(photo(special_coordinate(2)-15,special_coordinate(1)-1)==0)) || ((photo(special_coordinate(2)-15,special_coordinate(1)+1)==0) && (photo(special_coordinate(2)-15,special_coordinate(1)+2)==0))      %判断是否出现黑杠
                special_treatment = 7;                                      %特殊处理 7（出完黑线）
            else  %为障碍
                for i  = special_coordinate(2) : -1 : 30   %往前搜寻中点

                    left_border_flag = 0;
                    right_border_flag = 0;
                    left_margin_loss_flag = 0;            
                    right_margin_loss_flag = 0;
                    for j = 1:1:sizeofRow(i)*2
                        if( (left_border_flag && right_border_flag)==0 && (left_border_flag && right_margin_loss_flag)==0 && (left_margin_loss_flag && right_border_flag)==0 && (left_margin_loss_flag && right_margin_loss_flag)==0 )
                            if z < 80
                                %寻找赛道左边界
                                if left_border_flag == 0
                                    if((last_midline_coordinate(1) - j) > (70 - sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                            left_border_flag = 1;                                           %标记寻到赛道左边界
                                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;        %存左边界x坐标
                                            left_border_buf(2) = i;                                         %存左边界y坐标
                                        end
                                    else
                                        left_margin_loss_flag = 1;
                                    end
                                end
                                %寻找赛道右边界
                                if right_border_flag == 0
                                    if((last_midline_coordinate(1) + j) < (70 + sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                            right_border_flag = 1;                                          %标记寻到赛道右边界
                                            right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                            right_border_buf(2) = i;
                                        end
                                    else
                                        right_margin_loss_flag = 1;
                                    end
                                end                
                            else
                                %寻找赛道左边界
                                if left_border_flag == 0
                                    if((last_midline_coordinate(1) - j) > (75 - sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                            left_border_flag = 1;                                           %标记寻到赛道左边界
                                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %存左边界x坐标
                                            left_border_buf(2) = i;                                         %存左边界y坐标
                                        end
                                    else
                                        left_margin_loss_flag = 1;
                                    end
                                end
                                %寻找赛道右边界
                                if right_border_flag == 0
                                    if((last_midline_coordinate(1) + j) < (65 + sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                            right_border_flag = 1;                                          %标记寻到赛道右边界
                                            right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                            right_border_buf(2) = i;
                                        end
                                    else
                                        right_margin_loss_flag = 1;
                                    end
                                end
                            end                
                        else
                            break;               
                        end       
                    end

                    if (left_border_flag && right_border_flag)                                  %两边都寻到边界
                        if( last_midline_coordinate(1)-left_border_buf(1)<4)                    %判断是否出现单引导线
                             if( right_border_buf(1)-last_midline_coordinate(1)<4)               %判断是否出现单引导线（两边都找到单引线）
                                midline_coordinate_array(111-i,1) = floor(0.5*(left_border_buf(1)+right_border_buf(1)));
                                midline_coordinate_array(111-i,2) = floor(0.5*(left_border_buf(2)+right_border_buf(2)));
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            else                                                                %判断是否出现单引导线（单引线在左边）
                                midline_coordinate_array(111-i,1) = left_border_buf(1);
                                midline_coordinate_array(111-i,2) = left_border_buf(2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            end
                        else if( right_border_buf(1)-last_midline_coordinate(1)<4)              %判断是否出现单引导线（单引线在右边）
                                midline_coordinate_array(111-i,1) = right_border_buf(1);
                                midline_coordinate_array(111-i,2) = right_border_buf(2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            else   %中线避开障碍光滑连续----------------------------------------------------------------
                                if i > special_coordinate(2) - 40    
                                    midline_coordinate_array(111-i,1) = floor(0.75*last_midline_coordinate(1)+0.25*(left_border_buf(1) + right_border_buf(1))/2);
                                else
                                    midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                end
                                midline_coordinate_array(111-i,2) = i;
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            end
                        end               
                    else if( (left_border_flag==0) && (right_border_flag==0) )                  %两边都未寻到边界
                            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                            midline_coordinate_array(111-i,2) = i;
                            left_border_buf(2) = i;
                            right_border_buf(2) = i;
                        else if( (left_border_flag==1) && (right_border_flag==0) )              %左边界寻到，右边界丢失 
                                if( last_midline_coordinate(1)-left_border_buf(1)<4)            %判断是否出现单引导线
                                    midline_coordinate_array(111-i,1) = left_border_buf(1);
                                    midline_coordinate_array(111-i,2) = left_border_buf(2);
                                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if( left_border_buf(1) + track_width -( 70 + sizeofRow(i)) >= 5 )      %视野外
                                        right_border_buf(1) = left_border_buf(1) + track_width;
                                        right_border_buf(2) = left_border_buf(2);
                                        midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)-5;
                                        midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if(left_border_buf(1) + track_width -( 70 + sizeofRow(i)) <= -5)   %视野内     
                                            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                            midline_coordinate_array(111-i,2) = i;                            
                                        else
                                            right_border_buf(1) = left_border_buf(1) + track_width;
                                            right_border_buf(2) = left_border_buf(2);
                                            if i > special_coordinate(2) - 40
                                                midline_coordinate_array(111-i,1) = floor(0.9*last_midline_coordinate(1)+0.1*(left_border_buf(1) + right_border_buf(1))/2);
                                            else
                                                midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                            end
                                            midline_coordinate_array(111-i,2) = i;
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                        end
                                    end 
                                end
                            else if( (left_border_flag==0) && (right_border_flag==1) )          %右边界寻到，左边界丢失
                                    if( right_border_buf(1)-last_midline_coordinate(1)<4)  %判断是否出现单引导线
                                            midline_coordinate_array(111-i,1) = right_border_buf(1);
                                            midline_coordinate_array(111-i,2) = right_border_buf(2);
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if( right_border_buf(1) - track_width -( 70 - sizeofRow(i)) <= -5 )    %视野外
                                            left_border_buf(1) = right_border_buf(1)-track_width;
                                            left_border_buf(2) = right_border_buf(2);
                                            midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)+5;
                                            midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                        else if(right_border_buf(1) - track_width -( 70 - sizeofRow(i)) >= 5)   %视野内
                                                midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                                midline_coordinate_array(111-i,2) = i;    
                                            else
                                                left_border_buf(1) = right_border_buf(1)-track_width;
                                                left_border_buf(2) = right_border_buf(2);
                                                if i > special_coordinate(2) - 40
                                                    midline_coordinate_array(111-i,1) = floor(0.9*last_midline_coordinate(1)+0.1*(left_border_buf(1) + right_border_buf(1))/2);
                                                else
                                                    midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                                end
                                                midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end   
                end

                if special_coordinate(2) <  110
                    if special_coordinate(2)+10 < 110 
                        for i = special_coordinate(2) : 1 : special_coordinate(2)+10
                            midline_coordinate_array(111-i,1) = floor(0.9* midline_coordinate_array(111-i+1,1)+0.1* midline_coordinate_array(111-i,1));
                        end
                    else
                        for i = special_coordinate(2) : 1 : 110 
                            midline_coordinate_array(111-i,1) = floor(0.9* midline_coordinate_array(111-i+1,1)+0.1* midline_coordinate_array(111-i,1));
                        end
                    end
                end
            end
        end
        
    case 2
        special_coordinate(1) = midline_coordinate_array(110-i,1);                   %记录特殊列
        special_coordinate(2) = i;                  %记录特殊行
        
        %寻找上边界
        for z = 111-special_coordinate(2) : 1 : 107
            i = 111 - z;
            %寻找赛道上(左)边界
            if upside_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i-1,special_coordinate(1))==0 )
                    upside_flag = 1;                                          %标记寻到赛道左边界
                    left_border_buf(1) = special_coordinate(1);               %存左边界x坐标
                    left_border_buf(2) = i;                                   %存左边界y坐标
                end
            else
                break;
            end
        end
        %寻找下边界
        for z = 111-special_coordinate(2) : -1 : 2
            i = 111 - z;
            %寻找赛道下(右)边界
            if below_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i+1,special_coordinate(1))==0 )
                    below_flag = 1;                                            %标记寻到赛道左边界
                    right_border_buf(1) = special_coordinate(1);               %存右边界x坐标
                    right_border_buf(2) = i;                                   %存右边界y坐标
                end
            else
                break;
            end
        end
        
        if (below_flag == 0)&&(upside_flag == 1)                           %没找到下边界
            below_flag  = 1;
            right_border_buf(1) = special_coordinate(1);                    %存左边界x坐标
            right_border_buf(2) = 106;                                      %存左边界y坐标            
        end
        
        if ((upside_flag && below_flag) == 1) && (floor(0.5*(left_border_buf(2) + right_border_buf(2))) > special_coordinate(2)-3)
            midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2))),1) = special_coordinate(1)+3;
            midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2))),2) = floor(0.5*(left_border_buf(2) + right_border_buf(2)));
            
            for i = 1 : 1 : floor(0.5*(left_border_buf(2) + right_border_buf(2))) - special_coordinate(2)
                midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2)))+i,1) = 1;    %清除
                midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2)))+i,2) = 1;    %清除
            end
            
            special_coordinate(2) = midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2))),2);
            
            if 111-floor((special_coordinate(2)-track_width)/2) >= 10
                for i = 1 : 1 : 10
                    if i<6
                        midline_coordinate_array(110-special_coordinate(2)-i,1) = floor(0.8*midline_coordinate_array(110-special_coordinate(2)-i+1,1) + 0.2*midline_coordinate_array(110-special_coordinate(2)-10,1));
                        midline_coordinate_array(110-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                    else if i<9
                            midline_coordinate_array(110-special_coordinate(2)-i,1) = floor(0.75*midline_coordinate_array(110-special_coordinate(2)-i+1,1) + 0.25*midline_coordinate_array(110-special_coordinate(2)-10,1));
                            midline_coordinate_array(110-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                        else
                            midline_coordinate_array(110-special_coordinate(2)-i,1) = floor(0.7*midline_coordinate_array(110-special_coordinate(2)-i+1,1) + 0.3*midline_coordinate_array(110-special_coordinate(2)-10,1));
                            midline_coordinate_array(110-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                        end
                    end
                end
            end 
        end
        
        if upside_flag == 0 %|| (floor(0.5*(left_border_buf(2) + right_border_buf(2))) < special_coordinate(2))
            for i  = special_coordinate(2) : -1 : 45   %往前搜寻中点
                left_border_flag = 0;
                right_border_flag = 0;
                left_margin_loss_flag = 0;            
                right_margin_loss_flag = 0;
                for j = 1:1:sizeofRow(i)*2
                    if( (left_border_flag && right_border_flag)==0 && (left_border_flag && right_margin_loss_flag)==0 && (left_margin_loss_flag && right_border_flag)==0 && (left_margin_loss_flag && right_margin_loss_flag)==0 )
                        if z < 80
                            %寻找赛道左边界
                            if left_border_flag == 0
                                if((last_midline_coordinate(1) - j) > (70 - sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                        left_border_flag = 1;                                           %标记寻到赛道左边界
                                        left_border_buf(1) = last_midline_coordinate(1) - j + 1;        %存左边界x坐标
                                        left_border_buf(2) = i;                                         %存左边界y坐标
                                    end
                                else
                                    left_margin_loss_flag = 1;
                                end
                            end
                            %寻找赛道右边界
                            if right_border_flag == 0
                                if((last_midline_coordinate(1) + j) < (70 + sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                        right_border_flag = 1;                                          %标记寻到赛道右边界
                                        right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                        right_border_buf(2) = i;
                                    end
                                else
                                    right_margin_loss_flag = 1;
                                end
                            end                
                        else
                            %寻找赛道左边界
                            if left_border_flag == 0
                                if((last_midline_coordinate(1) - j) > (75 - sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                        left_border_flag = 1;                                           %标记寻到赛道左边界
                                        left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %存左边界x坐标
                                        left_border_buf(2) = i;                                         %存左边界y坐标
                                    end
                                else
                                    left_margin_loss_flag = 1;
                                end
                            end
                            %寻找赛道右边界
                            if right_border_flag == 0
                                if((last_midline_coordinate(1) + j) < (65 + sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                        right_border_flag = 1;                                          %标记寻到赛道右边界
                                        right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                        right_border_buf(2) = i;
                                    end
                                else
                                    right_margin_loss_flag = 1;
                                end
                            end
                        end                
                    else
                        break;               
                    end       
                end

                if (left_border_flag && right_border_flag)                                  %两边都寻到边界
                    if( last_midline_coordinate(1)-left_border_buf(1)<4)                    %判断是否出现单引导线
                         if( right_border_buf(1)-last_midline_coordinate(1)<4)               %判断是否出现单引导线（两边都找到单引线）
                            midline_coordinate_array(111-i,1) = floor(0.5*(left_border_buf(1)+right_border_buf(1)));
                            midline_coordinate_array(111-i,2) = floor(0.5*(left_border_buf(2)+right_border_buf(2)));
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        else                                                                %判断是否出现单引导线（单引线在左边）
                            midline_coordinate_array(111-i,1) = left_border_buf(1);
                            midline_coordinate_array(111-i,2) = left_border_buf(2);
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        end
                    else if( right_border_buf(1)-last_midline_coordinate(1)<4)              %判断是否出现单引导线（单引线在右边）
                            midline_coordinate_array(111-i,1) = right_border_buf(1);
                            midline_coordinate_array(111-i,2) = right_border_buf(2);
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        else   
                            midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                            midline_coordinate_array(111-i,2) = i;
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        end
                    end               
                else if( (left_border_flag==0) && (right_border_flag==0) )                  %两边都未寻到边界
                        midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                        midline_coordinate_array(111-i,2) = i;
                        left_border_buf(2) = i;
                        right_border_buf(2) = i;
                    else if( (left_border_flag==1) && (right_border_flag==0) )              %左边界寻到，右边界丢失 
                            if( last_midline_coordinate(1)-left_border_buf(1)<4)            %判断是否出现单引导线
                                midline_coordinate_array(111-i,1) = left_border_buf(1);
                                midline_coordinate_array(111-i,2) = left_border_buf(2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            else if( left_border_buf(1) + track_width -( 70 + sizeofRow(i)) >= 5 )      %视野外
                                    right_border_buf(1) = left_border_buf(1) + track_width;
                                    right_border_buf(2) = left_border_buf(2);
                                    midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                    midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if(left_border_buf(1) + track_width -( 70 + sizeofRow(i)) <= -5)   %视野内   
                                        break;
                                        %midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                        %midline_coordinate_array(111-i,2) = i;                            
                                    else
                                        right_border_buf(1) = left_border_buf(1) + track_width;
                                        right_border_buf(2) = left_border_buf(2);
                                        midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                        midline_coordinate_array(111-i,2) = i;
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    end
                                end 
                            end
                        else if( (left_border_flag==0) && (right_border_flag==1) )          %右边界寻到，左边界丢失
                                if( right_border_buf(1)-last_midline_coordinate(1)<4)  %判断是否出现单引导线
                                        midline_coordinate_array(111-i,1) = right_border_buf(1);
                                        midline_coordinate_array(111-i,2) = right_border_buf(2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if( right_border_buf(1) - track_width -( 70 - sizeofRow(i)) <= -5 )    %视野外
                                        left_border_buf(1) = right_border_buf(1)-track_width;
                                        left_border_buf(2) = right_border_buf(2);
                                        midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                        midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if(right_border_buf(1) - track_width -( 70 - sizeofRow(i)) >= 5)   %视野内
                                            %midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                            %midline_coordinate_array(111-i,2) = i;    
                                            break;
                                        else
                                            left_border_buf(1) = right_border_buf(1)-track_width;
                                            left_border_buf(2) = right_border_buf(2);
                                            midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                            midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                        end
                                    end
                                end
                            end
                        end
                    end
                end   
            end
        end
        
    case 3
        for z = z : 1 : 107
            i = 111 - z;
            %寻找赛道上(左)边界
            if upside_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i-1,special_coordinate(1))==0 )
                    upside_flag = 1;                                          %标记寻到赛道左边界
                    left_border_buf(1) = special_coordinate(1);               %存左边界x坐标
                    left_border_buf(2) = i;                                   %存左边界y坐标
                end
            else
                break;
            end
        end
        
        if upside_flag                      %寻找到边界
            midline_coordinate_array(111-floor((special_coordinate(2)+left_border_buf(2))/2),1) = special_coordinate(1);
            midline_coordinate_array(111-floor((special_coordinate(2)+left_border_buf(2))/2),2) = floor((special_coordinate(2)+left_border_buf(2))/2);
            special_coordinate(2) = floor((special_coordinate(2)+left_border_buf(2))/2);
        else
            if floor((special_coordinate(2)-track_width/2)) > 0
                midline_coordinate_array(111-floor((special_coordinate(2)-track_width/2)),1) = special_coordinate(1);
                midline_coordinate_array(111-floor((special_coordinate(2)-track_width/2)),2) = floor((special_coordinate(2)-track_width/2));
                special_coordinate(2) = floor((special_coordinate(2)-track_width/2));
                upside_flag = 1;
            end
        end
        
        if upside_flag
            if 111-floor((special_coordinate(2)-track_width)/2) >= 15
                for i = 1 : 1 : 15      
                    if i<9
                        midline_coordinate_array(111-special_coordinate(2)-i,1) = floor(0.75*midline_coordinate_array(111-special_coordinate(2)-i+1,1) + 0.25*midline_coordinate_array(111-special_coordinate(2)-15,1));
                        midline_coordinate_array(111-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                    else if i<12
                            midline_coordinate_array(111-special_coordinate(2)-i,1) = floor(0.6*midline_coordinate_array(111-special_coordinate(2)-i+1,1) + 0.4*midline_coordinate_array(111-special_coordinate(2)-15,1));
                            midline_coordinate_array(111-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                        else
                            midline_coordinate_array(111-special_coordinate(2)-i,1) = floor(0.4*midline_coordinate_array(111-special_coordinate(2)-i+1,1) + 0.6*midline_coordinate_array(111-special_coordinate(2)-15,1));
                            midline_coordinate_array(111-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                        end
                    end
                end
            end
        end
        
    case 4
        special_coordinate(1) = midline_coordinate_array(110-i,1); %记录特殊列
        special_coordinate(2) = i;                  %记录特殊行
        
        %寻找上边界
        for z = 111-special_coordinate(2) : 1 : 107
            i = 111 - z;
            %寻找赛道上(右)边界
            if upside_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i-1,special_coordinate(1))==0 )
                    upside_flag = 1;                                          %标记寻到赛道左边界
                    right_border_buf(1) = special_coordinate(1);               %存右边界x坐标
                    right_border_buf(2) = i;                                   %存右边界y坐标
                end
            else
                break;
            end
        end
        %寻找下边界
        for z = 111-special_coordinate(2) : -1 : 2
            i = 111 - z;
            %寻找赛道下(左)边界
            if below_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i+1,special_coordinate(1))==0 )
                    below_flag = 1;                                            %标记寻到赛道左边界
                    left_border_buf(1) = special_coordinate(1);                %存左边界x坐标
                    left_border_buf(2) = i;                                    %存左边界y坐标
                end
            else
                break;
            end
        end
        
        if (below_flag == 0)&&(upside_flag == 1)                           %没找到下边界
            below_flag  = 1;
            left_border_buf(1) = special_coordinate(1);                    %存左边界x坐标
            left_border_buf(2) = 106;                                      %存左边界y坐标            
        end
        
        if ((upside_flag && below_flag) == 1) && (floor(0.5*(left_border_buf(2) + right_border_buf(2))) > special_coordinate(2))
            midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2))),1) = special_coordinate(1)-3;
            midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2))),2) = floor(0.5*(left_border_buf(2) + right_border_buf(2)));
            
            for i = 1 : 1 : floor(0.5*(left_border_buf(2) + right_border_buf(2))) - special_coordinate(2)
                midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2)))+i,1) = 1;    %清除
                midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2)))+i,2) = 1;    %清除
            end
            
            special_coordinate(2) = midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2))),2);
            
            if 111-floor((special_coordinate(2)-track_width)/2) >= 10
                for i = 1 : 1 : 10
                    if i<6
                        midline_coordinate_array(110-special_coordinate(2)-i,1) = floor(0.8*midline_coordinate_array(110-special_coordinate(2)-i+1,1) + 0.2*midline_coordinate_array(110-special_coordinate(2)-10,1));
                        midline_coordinate_array(110-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                    else if i<9
                            midline_coordinate_array(110-special_coordinate(2)-i,1) = floor(0.75*midline_coordinate_array(110-special_coordinate(2)-i+1,1) + 0.25*midline_coordinate_array(110-special_coordinate(2)-10,1));
                            midline_coordinate_array(110-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                        else
                            midline_coordinate_array(110-special_coordinate(2)-i,1) = floor(0.7*midline_coordinate_array(110-special_coordinate(2)-i+1,1) + 0.3*midline_coordinate_array(110-special_coordinate(2)-10,1));
                            midline_coordinate_array(110-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                        end
                    end
                end
            end 
        end
        
        if upside_flag == 0
            for i  = special_coordinate(2) : -1 : 45   %往前搜寻中点
                left_border_flag = 0;
                right_border_flag = 0;
                left_margin_loss_flag = 0;            
                right_margin_loss_flag = 0;
                for j = 1:1:sizeofRow(i)*2
                    if( (left_border_flag && right_border_flag)==0 && (left_border_flag && right_margin_loss_flag)==0 && (left_margin_loss_flag && right_border_flag)==0 && (left_margin_loss_flag && right_margin_loss_flag)==0 )
                        if z < 80
                            %寻找赛道左边界
                            if left_border_flag == 0
                                if((last_midline_coordinate(1) - j) > (70 - sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                        left_border_flag = 1;                                           %标记寻到赛道左边界
                                        left_border_buf(1) = last_midline_coordinate(1) - j + 1;        %存左边界x坐标
                                        left_border_buf(2) = i;                                         %存左边界y坐标
                                    end
                                else
                                    left_margin_loss_flag = 1;
                                end
                            end
                            %寻找赛道右边界
                            if right_border_flag == 0
                                if((last_midline_coordinate(1) + j) < (70 + sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                        right_border_flag = 1;                                          %标记寻到赛道右边界
                                        right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                        right_border_buf(2) = i;
                                    end
                                else
                                    right_margin_loss_flag = 1;
                                end
                            end                
                        else
                            %寻找赛道左边界
                            if left_border_flag == 0
                                if((last_midline_coordinate(1) - j) > (75 - sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                        left_border_flag = 1;                                           %标记寻到赛道左边界
                                        left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %存左边界x坐标
                                        left_border_buf(2) = i;                                         %存左边界y坐标
                                    end
                                else
                                    left_margin_loss_flag = 1;
                                end
                            end
                            %寻找赛道右边界
                            if right_border_flag == 0
                                if((last_midline_coordinate(1) + j) < (65 + sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                        right_border_flag = 1;                                          %标记寻到赛道右边界
                                        right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                        right_border_buf(2) = i;
                                    end
                                else
                                    right_margin_loss_flag = 1;
                                end
                            end
                        end                
                    else
                        break;               
                    end       
                end

                if (left_border_flag && right_border_flag)                                  %两边都寻到边界
                    if( last_midline_coordinate(1)-left_border_buf(1)<4)                    %判断是否出现单引导线
                         if( right_border_buf(1)-last_midline_coordinate(1)<4)               %判断是否出现单引导线（两边都找到单引线）
                            midline_coordinate_array(111-i,1) = floor(0.5*(left_border_buf(1)+right_border_buf(1)));
                            midline_coordinate_array(111-i,2) = floor(0.5*(left_border_buf(2)+right_border_buf(2)));
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        else                                                                %判断是否出现单引导线（单引线在左边）
                            midline_coordinate_array(111-i,1) = left_border_buf(1);
                            midline_coordinate_array(111-i,2) = left_border_buf(2);
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        end
                    else if( right_border_buf(1)-last_midline_coordinate(1)<4)              %判断是否出现单引导线（单引线在右边）
                            midline_coordinate_array(111-i,1) = right_border_buf(1);
                            midline_coordinate_array(111-i,2) = right_border_buf(2);
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        else   
                            midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                            midline_coordinate_array(111-i,2) = i;
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        end
                    end               
                else if( (left_border_flag==0) && (right_border_flag==0) )                  %两边都未寻到边界
                        midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                        midline_coordinate_array(111-i,2) = i;
                        left_border_buf(2) = i;
                        right_border_buf(2) = i;
                    else if( (left_border_flag==1) && (right_border_flag==0) )              %左边界寻到，右边界丢失 
                            if( last_midline_coordinate(1)-left_border_buf(1)<4)            %判断是否出现单引导线
                                midline_coordinate_array(111-i,1) = left_border_buf(1);
                                midline_coordinate_array(111-i,2) = left_border_buf(2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            else if( left_border_buf(1) + track_width -( 70 + sizeofRow(i)) >= 5 )      %视野外
                                    right_border_buf(1) = left_border_buf(1) + track_width;
                                    right_border_buf(2) = left_border_buf(2);
                                    midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                    midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if(left_border_buf(1) + track_width -( 70 + sizeofRow(i)) <= -5)   %视野内     
                                        midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                        midline_coordinate_array(111-i,2) = i;                            
                                    else
                                        right_border_buf(1) = left_border_buf(1) + track_width;
                                        right_border_buf(2) = left_border_buf(2);
                                        midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                        midline_coordinate_array(111-i,2) = i;
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    end
                                end 
                            end
                        else if( (left_border_flag==0) && (right_border_flag==1) )          %右边界寻到，左边界丢失
                                if( right_border_buf(1)-last_midline_coordinate(1)<4)  %判断是否出现单引导线
                                        midline_coordinate_array(111-i,1) = right_border_buf(1);
                                        midline_coordinate_array(111-i,2) = right_border_buf(2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if( right_border_buf(1) - track_width -( 70 - sizeofRow(i)) <= -5 )    %视野外
                                        left_border_buf(1) = right_border_buf(1)-track_width;
                                        left_border_buf(2) = right_border_buf(2);
                                        midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                        midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if(right_border_buf(1) - track_width -( 70 - sizeofRow(i)) >= 5)   %视野内
                                            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                            midline_coordinate_array(111-i,2) = i;    
                                        else
                                            left_border_buf(1) = right_border_buf(1)-track_width;
                                            left_border_buf(2) = right_border_buf(2);
                                            midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                            midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                        end
                                    end
                                end
                            end
                        end
                    end
                end   
            end
        end
        
    case 5
        for z = z : 1 : 107
            i = 111 - z;
            %寻找赛道上(右)边界
            if upside_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i-1,special_coordinate(1))==0 )
                    upside_flag = 1;                                           %标记寻到赛道左边界
                    right_border_buf(1) = special_coordinate(1);               %存右边界x坐标
                    right_border_buf(2) = i;                                   %存右边界y坐标
                end
            else
                break;
            end
        end
        
        if upside_flag                      %寻找到边界
            midline_coordinate_array(111-floor((special_coordinate(2)+right_border_buf(2))/2),1) = special_coordinate(1);
            midline_coordinate_array(111-floor((special_coordinate(2)+right_border_buf(2))/2),2) = floor((special_coordinate(2)+right_border_buf(2))/2);
        else
            if floor((special_coordinate(2)-track_width)/2) > 0
                midline_coordinate_array(111-floor((special_coordinate(2)-track_width)/2),1) = special_coordinate(1);
                midline_coordinate_array(111-floor((special_coordinate(2)-track_width)/2),2) = floor((special_coordinate(2)-track_width)/2);
                upside_flag = 1;
            end
        end
        
        if upside_flag
            special_coordinate(2) = floor((special_coordinate(2)+right_border_buf(2))/2);
            if 111-floor((special_coordinate(2)-track_width)/2) >= 15
                for i = 1 : 1 : 15
                    if i<9
                        midline_coordinate_array(111-special_coordinate(2)-i,1) = floor(0.75*midline_coordinate_array(111-special_coordinate(2)-i+1,1) + 0.25*midline_coordinate_array(111-special_coordinate(2)-15,1));
                        midline_coordinate_array(111-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                    else if i<12
                            midline_coordinate_array(111-special_coordinate(2)-i,1) = floor(0.6*midline_coordinate_array(111-special_coordinate(2)-i+1,1) + 0.4*midline_coordinate_array(111-special_coordinate(2)-15,1));
                            midline_coordinate_array(111-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                        else
                            midline_coordinate_array(111-special_coordinate(2)-i,1) = floor(0.4*midline_coordinate_array(111-special_coordinate(2)-i+1,1) + 0.6*midline_coordinate_array(111-special_coordinate(2)-15,1));
                            midline_coordinate_array(111-special_coordinate(2)-i,2) = special_coordinate(2)+i;
                        end
                    end
                end
            end
        end
        
    case 6
        
        special_coordinate(1) = floor(0.5*(right_border_buf(1)+left_border_buf(1))); %记录特殊列
        special_coordinate(2) = i;                  %记录特殊行
        last_midline_coordinate(1) = special_coordinate(1);
        last_midline_coordinate(2) = special_coordinate(2);
        
        if special_coordinate(2)-15 > 30
            %判断是否是出弯道黑横杠
            if((photo(special_coordinate(2)-15,special_coordinate(1)-2)==0)&&(photo(special_coordinate(2)-15,special_coordinate(1)-1)==0)) || ((photo(special_coordinate(2)-15,special_coordinate(1)+1)==0) && (photo(special_coordinate(2)-15,special_coordinate(1)+2)==0))      %判断是否出现黑杠
                special_treatment = 6;                                      %特殊处理 6（直角黑线）
            else  
                for i  = special_coordinate(2)-15 : -1 : 35   %往前搜寻中点

                    left_border_flag = 0;
                    right_border_flag = 0;
                    left_margin_loss_flag = 0;            
                    right_margin_loss_flag = 0;
                    for j = 1:1:sizeofRow(i)*2
                        if( (left_border_flag && right_border_flag)==0 && (left_border_flag && right_margin_loss_flag)==0 && (left_margin_loss_flag && right_border_flag)==0 && (left_margin_loss_flag && right_margin_loss_flag)==0 )
                            if z < 80
                                %寻找赛道左边界
                                if left_border_flag == 0
                                    if((last_midline_coordinate(1) - j) > (70 - sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                            left_border_flag = 1;                                           %标记寻到赛道左边界
                                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;        %存左边界x坐标
                                            left_border_buf(2) = i;                                         %存左边界y坐标
                                        end
                                    else
                                        left_margin_loss_flag = 1;
                                    end
                                end
                                %寻找赛道右边界
                                if right_border_flag == 0
                                    if((last_midline_coordinate(1) + j) < (70 + sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                            right_border_flag = 1;                                          %标记寻到赛道右边界
                                            right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                            right_border_buf(2) = i;
                                        end
                                    else
                                        right_margin_loss_flag = 1;
                                    end
                                end                
                            else
                                %寻找赛道左边界
                                if left_border_flag == 0
                                    if((last_midline_coordinate(1) - j) > (75 - sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                            left_border_flag = 1;                                           %标记寻到赛道左边界
                                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %存左边界x坐标
                                            left_border_buf(2) = i;                                         %存左边界y坐标
                                        end
                                    else
                                        left_margin_loss_flag = 1;
                                    end
                                end
                                %寻找赛道右边界
                                if right_border_flag == 0
                                    if((last_midline_coordinate(1) + j) < (65 + sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                            right_border_flag = 1;                                          %标记寻到赛道右边界
                                            right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                            right_border_buf(2) = i;
                                        end
                                    else
                                        right_margin_loss_flag = 1;
                                    end
                                end
                            end                
                        else
                            break;               
                        end       
                    end

                    if (left_border_flag && right_border_flag)                                  %两边都寻到边界
                        if( last_midline_coordinate(1)-left_border_buf(1)<4)                    %判断是否出现单引导线
                             if( right_border_buf(1)-last_midline_coordinate(1)<4)               %判断是否出现单引导线（两边都找到单引线）
                                midline_coordinate_array(111-i,1) = floor(0.5*(left_border_buf(1)+right_border_buf(1)));
                                midline_coordinate_array(111-i,2) = floor(0.5*(left_border_buf(2)+right_border_buf(2)));
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            else                                                                %判断是否出现单引导线（单引线在左边）
                                midline_coordinate_array(111-i,1) = left_border_buf(1);
                                midline_coordinate_array(111-i,2) = left_border_buf(2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            end
                        else if( right_border_buf(1)-last_midline_coordinate(1)<4)              %判断是否出现单引导线（单引线在右边）
                                midline_coordinate_array(111-i,1) = right_border_buf(1);
                                midline_coordinate_array(111-i,2) = right_border_buf(2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            else   
                                midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                midline_coordinate_array(111-i,2) = i;
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            end
                        end               
                    else if( (left_border_flag==0) && (right_border_flag==0) )                  %两边都未寻到边界
                            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                            midline_coordinate_array(111-i,2) = i;
                            left_border_buf(2) = i;
                            right_border_buf(2) = i;
                        else if( (left_border_flag==1) && (right_border_flag==0) )              %左边界寻到，右边界丢失 
                                if( last_midline_coordinate(1)-left_border_buf(1)<4)            %判断是否出现单引导线
                                    midline_coordinate_array(111-i,1) = left_border_buf(1);
                                    midline_coordinate_array(111-i,2) = left_border_buf(2);
                                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if( left_border_buf(1) + track_width -( 70 + sizeofRow(i)) >= 5 )      %视野外
                                        right_border_buf(1) = left_border_buf(1) + track_width;
                                        right_border_buf(2) = left_border_buf(2);
                                        midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)-5;
                                        midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if(left_border_buf(1) + track_width -( 70 + sizeofRow(i)) <= -5)   %视野内     
                                            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                            midline_coordinate_array(111-i,2) = i;                            
                                        else
                                            right_border_buf(1) = left_border_buf(1) + track_width;
                                            right_border_buf(2) = left_border_buf(2);
                                            midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                            midline_coordinate_array(111-i,2) = i;
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                        end
                                    end 
                                end
                            else if( (left_border_flag==0) && (right_border_flag==1) )          %右边界寻到，左边界丢失
                                    if( right_border_buf(1)-last_midline_coordinate(1)<4)  %判断是否出现单引导线
                                            midline_coordinate_array(111-i,1) = right_border_buf(1);
                                            midline_coordinate_array(111-i,2) = right_border_buf(2);
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if( right_border_buf(1) - track_width -( 70 - sizeofRow(i)) <= -5 )    %视野外
                                            left_border_buf(1) = right_border_buf(1)-track_width;
                                            left_border_buf(2) = right_border_buf(2);
                                            midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)+5;
                                            midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                        else if(right_border_buf(1) - track_width -( 70 - sizeofRow(i)) >= 5)   %视野内
                                                midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                                midline_coordinate_array(111-i,2) = i;    
                                            else
                                                left_border_buf(1) = right_border_buf(1)-track_width;
                                                left_border_buf(2) = right_border_buf(2);
                                                midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                                midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end   
                end
                
                if special_coordinate(2) > 105
                    for i = special_coordinate(2)-15 : 1 : 110    %连续
                       midline_coordinate_array(111-i,1) = floor(0.7* midline_coordinate_array(111-i+1,1)+0.3* special_coordinate(1));
                       midline_coordinate_array(111-i,2) = i;
                    end
                else
                    for i = special_coordinate(2)-15 : 1 : special_coordinate(2)+5    %连续
                       midline_coordinate_array(111-i,1) = floor(0.7* midline_coordinate_array(111-i+1,1)+0.3* midline_coordinate_array(111-special_coordinate(2)-5,1));
                       midline_coordinate_array(111-i,2) = i;
                    end
                end
                
            end
        end
        
    otherwise
        
end

%中点检测
for i = 1 : 1 : 110
    if midline_coordinate_array(i,1) == 1   %判断中点是否超过10点 
        if i <= 10
            special_treatment = 7;  
            break;
        end
    else
        if i > 10
            break;
        end
    end
end

%确定可用中线的长度
for i = 1 : 1 : 110
    if midline_coordinate_array(i) == 1
        break;
    else
        last_mid_point_num = i;
    end
end

% for i=1:1:110
%     photo(midline_coordinate_array(i,2),midline_coordinate_array(i,1)) = 150;
% end

%photo(special_coordinate(2),special_coordinate(1)) = 0;
figure(1),imshow(photo1,[0,255]);
figure(2),imshow(photo,[0,255]);

