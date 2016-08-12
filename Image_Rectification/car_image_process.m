function y = car_image_process( n )
%CAR_IMAGE_PROCESS
%说明：按照北科技术报告尝试的图像处理算法，经 bt_image_process 函数测试后认为此算法切实可行
%     本函数是 bt_image_process 函数的改进版本，输入、输出图像大小均为 140x110
%     本函数增加了对障碍、单引线和直角弯提示黑线的特殊处理
%     输出的图像仅包含提取出的赛道左、右边线及中线
%常用示例：
%     imshow(car_image_process(imread('障碍1 140x110.bmp')));

%==============================%
%移植时尽量用有符号数以防负数的影响
%==============================%

y = ones(110,140)*255;            %用于返回
photo = n;                        % copy 原图像后作为原图像使用

left_line_x = zeros(200);         %左边线的 x 坐标
left_line_y = zeros(200);         %左边线的 y 坐标
left_line_num = int16(0);         %左边线个数
right_line_x = zeros(200);        %右边线的 x 坐标
right_line_y = zeros(200);        %右边线的 y 坐标
right_line_num = int16(0);        %右边线的个数

left_line_search_flag = 0;        %左边线纵向搜索方向
right_line_search_flag = 0;       %右边线纵向搜索方向
left_line_turning_x = 0;          %左边线由横向搜索变为纵向搜索的转折点的 x 坐标
left_line_turning_y = 0;          %左边线由横向搜索变为纵向搜索的转折点的 y 坐标
right_line_turning_x = 0;         %右边线由横向搜索变为纵向搜索的转折点的 x 坐标
right_line_turning_y = 0;         %右边线由横向搜索变为纵向搜索的转折点的 y 坐标
left_line_turning_num = 0;        %左边线由横向搜索变为纵向搜索的转折点时点的序号
right_line_turning_num = 0;       %右边线由横向搜索变为纵向搜索的转折点时点的序号

cross_second_left_line_x = 0;     %十字弯上半部分左边线搜索 x 坐标
cross_second_left_line_y = 0;     %十字弯上半部分左边线搜索 y 坐标
cross_second_right_line_x = 0;    %十字弯上半部分右边线搜索 x 坐标
cross_second_right_line_y = 0;    %十字弯上半部分右边线搜索 y 坐标

mid_point_x = zeros(200);         %中点的 x 坐标
mid_point_y = zeros(200);         %中点的 y 坐标
mid_point_num = int16(0);         %中点的个数

thick_black_line_left_x = 0;      %提示入直角的粗黑线（可想象为一个矩形）左上角点的 x 坐标
thick_black_line_left_y = 0;      %提示入直角的粗黑线（可想象为一个矩形）左上角点的 y 坐标 
thick_black_line_right_x = 0;     %提示入直角的粗黑线（可想象为一个矩形）右上角点的 x 坐标
thick_black_line_right_y = 0;     %提示入直角的粗黑线（可想象为一个矩形）右上角点的 y 坐标 


%1.图像压缩及二值化
for i = 1:1:110
    for j = 1:1:140
        if n(i,j)>100
            photo(i,j) = 255;
        else
            photo(i,j) = 0;
        end
    end
end

%2.记录横、纵向所有跳变点
for i = 110:-1:2
    for j = 1:1:139
        if ((photo(i,j) ~= photo(i,j+1)) || (photo(i,j) ~= photo(i-1,j)))
            y(i,j) = 0;
        else
            y(i,j) = 255;
        end
    end
end

photo = y;        %重新将 photo 作为原始数据

%3.提取左边线
%3.1首先在图像最下端确定起始边线
for i = 70:-1:1
    if photo(110,i) < 100
        left_line_x(1) = 110;
        left_line_y(1) = i;
        left_line_num  = left_line_num + 1;
        break;
    end
    %搜索不到边线则以最左点做边线
    if i == 1
        left_line_x(1) = 110;
        left_line_y(1) = 1;
        left_line_num  = left_line_num + 1;
    end
end

%3.2从下往上搜索边线，搜索到最顶部或丢线为止
for i = 109:-1:1
    %如果在上一行 y 位置右边一个点搜到黑色点则记录位置
    if photo(i,left_line_y(left_line_num) + 1) < 100
        left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
        left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 1;    %记录 y 坐标
        left_line_num = left_line_num + 1;                                  %更新左边线点个数
    %如果在上一行 y 位置右边两个点搜到黑色点则记录位置
    elseif photo(i,left_line_y(left_line_num) + 2) < 100
        left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
        left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 2;    %记录 y 坐标
        left_line_num = left_line_num + 1;                                  %更新左边线点个数
    %如果在上一行 y 位置相同点搜到黑色点则记录位置    
    elseif photo(i,left_line_y(left_line_num)) < 100
        left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
        left_line_y(left_line_num + 1) = left_line_y(left_line_num);        %记录 y 坐标
        left_line_num = left_line_num + 1;                                  %更新左边线点个数
    %如果在上一行 y 位置相同点和右边一、两点没搜到黑色点且上一行的 x 位置为最左边则认为此行左边线点为最左点
    elseif left_line_y(left_line_num) == 1
        left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
        left_line_y(left_line_num + 1) = 1;                                 %记录 y 坐标
        left_line_num = left_line_num + 1;                                  %更新左边线点个数
    %如果在上一行 y 位置左边一个点搜到黑色点则记录位置
    elseif photo(i,left_line_y(left_line_num) - 1) < 100
        left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
        left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 1;    %记录 y 坐标
        left_line_num = left_line_num + 1;                                  %更新左边线点个数
    %如果在上一行 y 位置相同点和右边一、两点、左边一点没搜到黑色点且上一行的 x 位置为最左边起第二点则认为此行左边线点为最左点
    elseif left_line_y(left_line_num) == 2
        left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
        left_line_y(left_line_num + 1) = 1;                                 %记录 y 坐标
        left_line_num = left_line_num + 1;                                  %更新左边线点个数
    %如果在上一行 y 位置左边两个点搜到黑色点则记录位置
    elseif photo(i,left_line_y(left_line_num) - 2) < 100
        left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
        left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 2;    %记录 y 坐标
        left_line_num = left_line_num + 1;                                  %更新左边线点个数
    %如果在上一行 y 位置左边、右边和相同点都搜不到黑色点则认为是丢线
    else
        break;
    end
end
left_line_turning_x = left_line_x(left_line_num);                           %记录左边线转折点 x 坐标
left_line_turning_y = left_line_y(left_line_num);                           %记录左边线转折点 y 坐标
left_line_turning_num = left_line_num;                                      %记录左边线转折点的序号

%3.3横向搜索丢线后纵向搜索
%3.3.1如果左边黑色点比右边少则纵向向右边搜索
if (photo(left_line_x(left_line_num),left_line_y(left_line_num) - 1)...
   +photo(left_line_x(left_line_num),left_line_y(left_line_num) - 2)...
   +photo(left_line_x(left_line_num) - 1,left_line_y(left_line_num) - 1)...
   +photo(left_line_x(left_line_num) - 1,left_line_y(left_line_num) - 2)) >...
   (photo(left_line_x(left_line_num),left_line_y(left_line_num) + 1)...
   +photo(left_line_x(left_line_num),left_line_y(left_line_num) + 2)...
   +photo(left_line_x(left_line_num) - 1,left_line_y(left_line_num) + 1)...
   +photo(left_line_x(left_line_num) - 1,left_line_y(left_line_num) + 2))
    %记录纵向搜寻方向（1：左  2：右）
    left_line_search_flag = 2;
    %从丢线点的 y 位置向右纵向搜索连续的黑点，直到边界或丢线
    for i = left_line_y(left_line_num) + 1:1:140
        %如果在上一列 x 位置上面一个点搜到黑色点则记录位置
        if photo(left_line_x(left_line_num) + 1,i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num) + 1;    %记录 x 坐标
            left_line_y(left_line_num + 1) = i;                                 %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一列 x 位置的相同位置搜到黑色点则记录位置
        elseif photo(left_line_x(left_line_num),i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num);        %记录 x 坐标
            left_line_y(left_line_num + 1) = i;                                 %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一列 x 位置下面一个点搜到黑色点则记录位置
        elseif photo(left_line_x(left_line_num) - 1,i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num) - 1;    %记录 x 坐标
            left_line_y(left_line_num + 1) = i;                                 %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果上中下都搜不到则判断丢线，跳出循环
        else
            break;
        end
    end
   
%3.3.2其他情况则纵向向左边搜索    
else
    %记录纵向搜寻方向（1：左  2：右）
    left_line_search_flag = 1;
    %从丢线点的 y 位置向左纵向搜索连续的黑点，直到边界或丢线
    for i = left_line_y(left_line_num) - 1:-1:1
        %如果在上一列 x 位置上面一个点搜到黑色点则记录位置
        if photo(left_line_x(left_line_num) + 1,i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num) + 1;    %记录 x 坐标
            left_line_y(left_line_num + 1) = i;                                 %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一列 x 位置的相同位置搜到黑色点则记录位置
        elseif photo(left_line_x(left_line_num),i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num);        %记录 x 坐标
            left_line_y(left_line_num + 1) = i;                                 %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一列 x 位置下面一个点搜到黑色点则记录位置
        elseif photo(left_line_x(left_line_num) - 1,i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num) - 1;    %记录 x 坐标
            left_line_y(left_line_num + 1) = i;                                 %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果上中下都搜不到则判断丢线，跳出循环
        else
            break;
        end
    end
end

%4.提取右边线
%4.1首先在图像最下端确定起始边线
for i = 70:1:140
    if photo(110,i) < 100
        right_line_x(1) = 110;
        right_line_y(1) = i;
        right_line_num  = right_line_num + 1;
        break;
    end
    %搜索不到边线则以最左点做边线
    if i == 140
        right_line_x(1) = 110;
        right_line_y(1) = 140;
        right_line_num  = right_line_num + 1;
    end
end

%4.2从下往上搜索边线，搜索到最顶部或丢线为止
for i = 109:-1:1
    %如果在上一行 y 位置左边一个点搜到黑色点则记录位置
    if photo(i,right_line_y(right_line_num) - 1) < 100
        right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
        right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 1;   %记录 y 坐标
        right_line_num = right_line_num + 1;                                   %更新右边线点个数
    %如果在上一行 y 位置左边两个点搜到黑色点则记录位置
    elseif photo(i,right_line_y(right_line_num) - 2) < 100
        right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
        right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 2;   %记录 y 坐标
        right_line_num = right_line_num + 1;                                   %更新右边线点个数
    %如果在上一行 y 位置相同点搜到黑色点则记录位置    
    elseif photo(i,right_line_y(right_line_num)) < 100
        right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
        right_line_y(right_line_num + 1) = right_line_y(right_line_num);       %记录 y 坐标
        right_line_num = right_line_num + 1;                                   %更新右边线点个数
    %如果在上一行 y 位置相同点和左边一、两点没搜到黑色点且上一行的 x 位置为最右边则认为此行右边线点为最右点
    elseif right_line_y(right_line_num) == 140
        right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
        right_line_y(right_line_num + 1) = 140;                                %记录 y 坐标
        right_line_num = right_line_num + 1;                                   %更新右边线点个数
    %如果在上一行 y 位置右边一个点搜到黑色点则记录位置
    elseif photo(i,right_line_y(right_line_num) + 1) < 100
        right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
        right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 1;   %记录 y 坐标
        right_line_num = right_line_num + 1;                                   %更新右边线点个数
    %如果在上一行 y 位置相同点和左边一、两点、右边一点没搜到黑色点且上一行的 x 位置为最右边起第二点则认为此行右边线点为最右点
    elseif right_line_y(right_line_num) == 139
        right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
        right_line_y(right_line_num + 1) = 140;                                %记录 y 坐标
        right_line_num = right_line_num + 1;                                   %更新右边线点个数
    %如果在上一行 y 位置右边两个点搜到黑色点则记录位置
    elseif photo(i,right_line_y(right_line_num) + 2) < 100
        right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
        right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 2;   %记录 y 坐标
        right_line_num = right_line_num + 1;                                   %更新右边线点个数
    %如果在上一行 y 位置左边、右边和相同点都搜不到黑色点则认为是丢线
    else
        break;
    end
end
right_line_turning_x = right_line_x(right_line_num);                        %记录右边线转折点 x 坐标
right_line_turning_y = right_line_y(right_line_num);                        %记录右边线转折点 y 坐标
right_line_turning_num = right_line_num;                                    %记录右边线转折点的序号

%4.3横向搜索丢线后纵向搜索
%4.3.1如果左边黑色点比右边少则纵向向右边搜索
if (photo(right_line_x(right_line_num),right_line_y(right_line_num) - 1)...
   +photo(right_line_x(right_line_num),right_line_y(right_line_num) - 2)...
   +photo(right_line_x(right_line_num) - 1,right_line_y(right_line_num) - 1)...
   +photo(right_line_x(right_line_num) - 1,right_line_y(right_line_num) - 2)) >...
   (photo(right_line_x(right_line_num),right_line_y(right_line_num) + 1)...
   +photo(right_line_x(right_line_num),right_line_y(right_line_num) + 2)...
   +photo(right_line_x(right_line_num) - 1,right_line_y(right_line_num) + 1)...
   +photo(right_line_x(right_line_num) - 1,right_line_y(right_line_num) + 2))
    %记录纵向搜寻方向（1：左  2：右）
    right_line_search_flag = 2;
    %从丢线点的 y 位置向右纵向搜索连续的黑点，直到边界或丢线
    for i = right_line_y(right_line_num) + 1:1:140
        %如果在上一列 x 位置上面一个点搜到黑色点则记录位置
        if photo(right_line_x(right_line_num) + 1,i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num) + 1;    %记录 x 坐标
            right_line_y(right_line_num + 1) = i;                                   %记录 y 坐标
            right_line_num = right_line_num + 1;                                    %更新左边线点个数
        %如果在上一列 x 位置的相同位置搜到黑色点则记录位置
        elseif photo(right_line_x(right_line_num),i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num);        %记录 x 坐标
            right_line_y(right_line_num + 1) = i;                                   %记录 y 坐标
            right_line_num = right_line_num + 1;                                    %更新左边线点个数
        %如果在上一列 x 位置下面一个点搜到黑色点则记录位置
        elseif photo(right_line_x(right_line_num) - 1,i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num) - 1;    %记录 x 坐标
            right_line_y(right_line_num + 1) = i;                                   %记录 y 坐标
            right_line_num = right_line_num + 1;                                    %更新左边线点个数
        %如果上中下都搜不到则判断丢线，跳出循环
        else
            break;
        end
    end
   
%4.3.2其他情况则纵向向左边搜索    
else
    %记录纵向搜寻方向（1：左  2：右）
    right_line_search_flag = 1;
    %从丢线点的 y 位置向左纵向搜索连续的黑点，直到边界或丢线
    for i = right_line_y(right_line_num) - 1:-1:1
        %如果在上一列 x 位置上面一个点搜到黑色点则记录位置
        if photo(right_line_x(right_line_num) + 1,i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num) + 1;    %记录 x 坐标
            right_line_y(right_line_num + 1) = i;                                   %记录 y 坐标
            right_line_num = right_line_num + 1;                                    %更新左边线点个数
        %如果在上一列 x 位置的相同位置搜到黑色点则记录位置
        elseif photo(right_line_x(right_line_num),i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num);        %记录 x 坐标
            right_line_y(right_line_num + 1) = i;                                   %记录 y 坐标
            right_line_num = right_line_num + 1;                                    %更新左边线点个数
        %如果在上一列 x 位置下面一个点搜到黑色点则记录位置
        elseif photo(right_line_x(right_line_num) - 1,i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num) - 1;    %记录 x 坐标
            right_line_y(right_line_num + 1) = i;                                   %记录 y 坐标
            right_line_num = right_line_num + 1;                                    %更新左边线点个数
        %如果上中下都搜不到则判断丢线，跳出循环
        else
            break;
        end
    end
end

%==================================================%
%==================赛道特殊元素处理==================%
%==================================================%

%5.十字弯特殊处理
%仅当【（左边线纵向搜索方向为向左）且（右边线纵向搜索方向为向右）且（左右边线截止点为图像边界 5 个点）】时做直角弯处理
if (left_line_search_flag == 1) && (right_line_search_flag == 2) &&...
   (left_line_y(left_line_num) < 5) && (right_line_y(right_line_num) > 135)
    %5.1搜索十字弯上半部分的左边线
    %5.1.1由左边线向左数第 5 个点向上搜寻十字弯上半部分的边界起始点，如果拐点距离图像最左点不足 5 个点则取最左点
    if left_line_turning_x < 6
        left_line_turning_x = 1;
    end
    for i = left_line_turning_x - 1:-1:2
        if photo(i,left_line_turning_y - 5 )< 100
            cross_second_left_line_x = i;
            cross_second_left_line_y = left_line_turning_y - 5;
            break;
        end
    end
    %5.1.2搜索到起始点后自左向右纵向搜索
    for i = cross_second_left_line_y + 1:1:138
        %如果在上一个点右上方一个点搜到黑色点
        if photo(cross_second_left_line_x - 1,i) < 100
            cross_second_left_line_x = cross_second_left_line_x - 1;
            cross_second_left_line_y = i;
        %如果在上一个点正右方一个点搜到黑色点
        elseif photo(cross_second_left_line_x,i) < 100
            cross_second_left_line_y = i;
        %如果在上一个点右下方一个点搜到黑色点
        elseif photo(cross_second_left_line_x + 1,i) < 100
            cross_second_left_line_x = cross_second_left_line_x + 1;
            cross_second_left_line_y = i;
        %如果都搜索不到则判断此点为转角点
        else
            break;
        end        
    end
    %5.1.3在原图像上将十字弯左边线的两个转角点连线
    %5.1.3.1如果连线的纵向长度大于横向长度（用平方做判断可消除负号影响）
    if (left_line_turning_x - cross_second_left_line_x)*(left_line_turning_x - cross_second_left_line_x)...
      >(left_line_turning_y - cross_second_left_line_y)*(left_line_turning_y - cross_second_left_line_y)
        for i = 0:1:left_line_turning_x - cross_second_left_line_x 
            photo(int16(cross_second_left_line_x + i),...
                  int16(cross_second_left_line_y + i*...
                  (left_line_turning_y - cross_second_left_line_y)/...
                  (left_line_turning_x - cross_second_left_line_x))) = 0;
        end
    %5.1.3.2如果连线的纵向长度小于或等于横向长度且下半部分拐点在上半部分拐点右边    
    elseif left_line_turning_y > cross_second_left_line_y 
        for i = 0:1:left_line_turning_y - cross_second_left_line_y 
            photo(int16(cross_second_left_line_y + i),...
                  int16(cross_second_left_line_x + i*...
                  (left_line_turning_x - cross_second_left_line_x)/...
                  (left_line_turning_y - cross_second_left_line_y))) = 0;
        end
    %5.1.3.3如果连线的纵向长度小于或等于横向长度且下半部分拐点在上半部分拐点左边或 y 坐标相同    
    else
        for i = 0:1:cross_second_left_line_y - left_line_turning_y  
            photo(int16(cross_second_left_line_y + i),...
                  int16(cross_second_left_line_x + i*...
                  (left_line_turning_x - cross_second_left_line_x)/...
                  (left_line_turning_y - cross_second_left_line_y))) = 0;
        end
    end  
    
    %5.2搜索十字弯上半部分的右边线
    %5.2.1由右边线拐点向右第数 5 个点向上搜寻十字弯上半部分的边界起始点，如果拐点距离图像最右点不足 5 个点则取最右点
    if right_line_turning_x > 134
        right_line_turning_x = 140;
    end
    for i = right_line_turning_x - 1:-1:2
        if photo(i,right_line_turning_y + 5 )< 100
            cross_second_right_line_x = i;
            cross_second_right_line_y = right_line_turning_y + 5;
            break;
        end
    end
    %5.2.2搜索到起始点后自右向左纵向搜索
    for i = cross_second_right_line_y - 1:-1:3
        %如果在上一个点左上方一个点搜到黑色点
        if photo(cross_second_right_line_x - 1,i) < 100
            cross_second_right_line_x = cross_second_right_line_x - 1;
            cross_second_right_line_y = i;
        %如果在上一个点正左方一个点搜到黑色点
        elseif photo(cross_second_right_line_x,i) < 100
            cross_second_right_line_y = i;
        %如果在上一个点左下方一个点搜到黑色点
        elseif photo(cross_second_right_line_x + 1,i) < 100
            cross_second_right_line_x = cross_second_right_line_x + 1;
            cross_second_right_line_y = i;
        %如果都搜索不到则判断此点为转角点
        else
            break;
        end        
    end
    %5.2.3在原图像上将十字弯右边线的两个转角点连线
    %5.2.3.1如果连线的纵向长度大于横向长度（用平方做判断可消除负号影响）
    if (right_line_turning_x - cross_second_right_line_x)*(right_line_turning_x - cross_second_right_line_x)...
      >(right_line_turning_y - cross_second_right_line_y)*(right_line_turning_y - cross_second_right_line_y)
        for i = 0:1:right_line_turning_x - cross_second_right_line_x 
            photo(int16(cross_second_right_line_x + i),...
                  int16(cross_second_right_line_y + i*...
                  (right_line_turning_y - cross_second_right_line_y)/...
                  (right_line_turning_x - cross_second_right_line_x))) = 0;
        end
    %5.2.3.2如果连线的纵向长度小于或等于横向长度且下半部分拐点在上半部分拐点右边    
    elseif right_line_turning_y > cross_second_right_line_y 
        for i = 0:1:right_line_turning_y - cross_second_right_line_y 
            photo(int16(cross_second_right_line_y + i),...
                  int16(cross_second_right_line_x + i*...
                  (right_line_turning_x - cross_second_right_line_x)/...
                  (right_line_turning_y - cross_second_right_line_y))) = 0;
        end
    %5.2.3.3如果连线的纵向长度小于或等于横向长度且下半部分拐点在上半部分拐点左边或 y 坐标相同    
    else
        for i = 0:1:cross_second_right_line_y - right_line_turning_y  
            photo(int16(cross_second_right_line_y + i),...
                  int16(cross_second_right_line_x + i*...
                  (right_line_turning_x - cross_second_right_line_x)/...
                  (right_line_turning_y - cross_second_right_line_y))) = 0;
        end
    end
    %5.3重新提取边线
    %5.3.1由左边线拐点起从下往上搜索左边线，搜索到最顶部或丢线为止
    left_line_num = left_line_turning_num;                                      %左边线拐点之后的记录全部删除
    for i = left_line_turning_x - 1:-1:1
        %如果在上一行 y 位置右边一个点搜到黑色点则记录位置
        if photo(i,left_line_y(left_line_num) + 1) < 100
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 1;    %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置右边两个点搜到黑色点则记录位置
        elseif photo(i,left_line_y(left_line_num) + 2) < 100
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 2;    %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置相同点搜到黑色点则记录位置    
        elseif photo(i,left_line_y(left_line_num)) < 100
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = left_line_y(left_line_num);        %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置相同点和右边一、两点没搜到黑色点且上一行的 x 位置为最左边则认为此行左边线点为最左点
        elseif left_line_y(left_line_num) == 1
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = 1;                                 %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置左边一个点搜到黑色点则记录位置
        elseif photo(i,left_line_y(left_line_num) - 1) < 100
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 1;    %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置相同点和右边一、两点、左边一点没搜到黑色点且上一行的 x 位置为最左边起第二点则认为此行左边线点为最左点
        elseif left_line_y(left_line_num) == 2
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = 1;                                 %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置左边两个点搜到黑色点则记录位置
        elseif photo(i,left_line_y(left_line_num) - 2) < 100
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 2;    %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置左边、右边和相同点都搜不到黑色点则认为是丢线
        else
            break;
        end
    end
    %5.3.2由右边线拐点起从下往上搜索右边线，搜索到最顶部或丢线为止
    right_line_num = right_line_turning_num;                                    %右边线拐点之后的记录全部删除
    for i = right_line_turning_x - 1:-1:1
        %如果在上一行 y 位置左边一个点搜到黑色点则记录位置
        if photo(i,right_line_y(right_line_num) - 1) < 100
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 1;   %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置左边两个点搜到黑色点则记录位置
        elseif photo(i,right_line_y(right_line_num) - 2) < 100
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 2;   %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置相同点搜到黑色点则记录位置    
        elseif photo(i,right_line_y(right_line_num)) < 100
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = right_line_y(right_line_num);       %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置相同点和左边一、两点没搜到黑色点且上一行的 x 位置为最右边则认为此行右边线点为最右点
        elseif right_line_y(right_line_num) == 140
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = 140;                                %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置右边一个点搜到黑色点则记录位置
        elseif photo(i,right_line_y(right_line_num) + 1) < 100
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 1;   %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置相同点和左边一、两点、右边一点没搜到黑色点且上一行的 x 位置为最右边起第二点则认为此行右边线点为最右点
        elseif right_line_y(right_line_num) == 139
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = 140;                                %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置右边两个点搜到黑色点则记录位置
        elseif photo(i,right_line_y(right_line_num) + 2) < 100
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 2;   %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置左边、右边和相同点都搜不到黑色点则认为是丢线
        else
            break;
        end
    end
    
%6.入直角弯前粗黑线特殊处理 
%仅当【（左边线向右急拐且拐点距图像底部小于 30 行） 或 （右边线向左急拐且拐点距图像底部小于 30 行）】时判断前方为用于提示直角弯的粗黑线
elseif ((left_line_search_flag == 2) && (left_line_turning_x > 80)) || ...
       ((right_line_search_flag == 1) && (right_line_turning_x > 80))
    %6.1在【原图像】中从图像的中心位置自最下向上搜索黑色点再搜索白色点，搜到白色点则记录其位置
    for i = 109:-1:1
        if n(i,70) < 100
            thick_black_line_left_x = i;
            break;
        end
    end
    for i = thick_black_line_left_x - 1:-1:1
        if n(i,70) > 100
            thick_black_line_left_x = i;
            break;
        end
    end
    thick_black_line_right_x = thick_black_line_left_x;
    thick_black_line_right_y = 70;
    thick_black_line_left_y = 70;
    %6.2首先向左纵向搜索，至拐点停止
    %6.2.1搜索到起始点后自右向左纵向搜索
    for i = thick_black_line_left_y - 1:-1:3
        %如果在上一个点左上方一个点搜到黑色点
        if photo(thick_black_line_left_x - 1,i) < 100
            thick_black_line_left_x = thick_black_line_left_x - 1;
            thick_black_line_left_y = i;
        %如果在上一个点正左方一个点搜到黑色点
        elseif photo(thick_black_line_left_x,i) < 100
            thick_black_line_left_y = i;
        %如果在上一个点左下方一个点搜到黑色点
        elseif photo(thick_black_line_left_x + 1,i) < 100
            thick_black_line_left_x = thick_black_line_left_x + 1;
            thick_black_line_left_y = i;
        %如果都搜索不到则判断此点为转角点
        else
            break;
        end        
    end
    %将之前搜索的左边线删除
    left_line_num = 1;                                                         
    left_line_x(1) = thick_black_line_left_x;
    left_line_y(1) = thick_black_line_left_y;
    %6.2.2由转角点从下往上重新搜左边线
    for i = thick_black_line_left_x - 1:-1:1
        %如果在上一行 y 位置右边一个点搜到黑色点则记录位置
        if photo(i,left_line_y(left_line_num) + 1) < 100
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 1;    %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置右边两个点搜到黑色点则记录位置
        elseif photo(i,left_line_y(left_line_num) + 2) < 100
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 2;    %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置相同点搜到黑色点则记录位置    
        elseif photo(i,left_line_y(left_line_num)) < 100
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = left_line_y(left_line_num);        %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置相同点和右边一、两点没搜到黑色点且上一行的 x 位置为最左边则认为此行左边线点为最左点
        elseif left_line_y(left_line_num) == 1
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = 1;                                 %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置左边一个点搜到黑色点则记录位置
        elseif photo(i,left_line_y(left_line_num) - 1) < 100
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 1;    %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置相同点和右边一、两点、左边一点没搜到黑色点且上一行的 x 位置为最左边起第二点则认为此行左边线点为最左点
        elseif left_line_y(left_line_num) == 2
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = 1;                                 %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置左边两个点搜到黑色点则记录位置
        elseif photo(i,left_line_y(left_line_num) - 2) < 100
            left_line_x(left_line_num + 1) = i;                                 %记录 x 坐标
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 2;    %记录 y 坐标
            left_line_num = left_line_num + 1;                                  %更新左边线点个数
        %如果在上一行 y 位置左边、右边和相同点都搜不到黑色点则认为是丢线
        else
            break;
        end
    end
    %6.3然后向右纵向搜索，至拐点停止
    %6.3.1由起始点后自左向右纵向搜索
    for i = thick_black_line_right_y + 1:1:138
        %如果在上一个点右上方一个点搜到黑色点
        if photo(thick_black_line_right_x - 1,i) < 100
            thick_black_line_right_x = thick_black_line_right_x - 1;
            thick_black_line_right_y = i;
        %如果在上一个点正右方一个点搜到黑色点
        elseif photo(thick_black_line_right_x,i) < 100
            thick_black_line_right_y = i;
        %如果在上一个点右下方一个点搜到黑色点
        elseif photo(thick_black_line_right_x + 1,i) < 100
            thick_black_line_right_x = thick_black_line_right_x + 1;
            thick_black_line_right_y = i;
        %如果都搜索不到则判断此点为转角点
        else
            break;
        end        
    end
    %将之前搜索的右边线删除
    right_line_num = 1;                                                         
    right_line_x(1) = thick_black_line_right_x;
    right_line_y(1) = thick_black_line_right_y;
    %6.2.2由转角点从下往上重新搜右边线
    for i = thick_black_line_right_x - 1:-1:1
        %如果在上一行 y 位置左边一个点搜到黑色点则记录位置
        if photo(i,right_line_y(right_line_num) - 1) < 100
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 1;   %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置左边两个点搜到黑色点则记录位置
        elseif photo(i,right_line_y(right_line_num) - 2) < 100
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 2;   %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置相同点搜到黑色点则记录位置    
        elseif photo(i,right_line_y(right_line_num)) < 100
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = right_line_y(right_line_num);       %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置相同点和左边一、两点没搜到黑色点且上一行的 x 位置为最右边则认为此行右边线点为最右点
        elseif right_line_y(right_line_num) == 140
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = 140;                                %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置右边一个点搜到黑色点则记录位置
        elseif photo(i,right_line_y(right_line_num) + 1) < 100
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 1;   %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置相同点和左边一、两点、右边一点没搜到黑色点且上一行的 x 位置为最右边起第二点则认为此行右边线点为最右点
        elseif right_line_y(right_line_num) == 139
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = 140;                                %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置右边两个点搜到黑色点则记录位置
        elseif photo(i,right_line_y(right_line_num) + 2) < 100
            right_line_x(right_line_num + 1) = i;                                  %记录 x 坐标
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 2;   %记录 y 坐标
            right_line_num = right_line_num + 1;                                   %更新右边线点个数
        %如果在上一行 y 位置左边、右边和相同点都搜不到黑色点则认为是丢线
        else
            break;
        end
    end
end


%=========================%
%C语言移植时注意标志和数组清零
%=========================%

%------------------------------------------------------------------------------------------------%

%清空返回数组
y = ones(110,140)*255;

%矫正两边线长度
if left_line_num > right_line_num + 25
    left_line_num = right_line_num + 25;
elseif right_line_num > left_line_num + 25
    right_line_num = left_line_num + 25;
end

%将左、右边线数组转换到返回数组中
for i = 1:1:left_line_num
    y(left_line_x(i),left_line_y(i)) = 0;
end
for i = 1:1:right_line_num
    y(right_line_x(i),right_line_y(i)) = 0;
end

%计算中点
%如果左边线长度大于右边线
if left_line_num > right_line_num
    for i = 1:1:right_line_num
        mid_point_x(mid_point_num + 1) = int16((left_line_x(int16(right_line_num/left_line_num*i + 1)) + right_line_x(i))/2);
        mid_point_y(mid_point_num + 1) = int16((left_line_y(int16(right_line_num/left_line_num*i + 1)) + right_line_y(i))/2);
        mid_point_num = mid_point_num + 1;
        %y(int16((left_line_x(int16(right_line_num/left_line_num*i)) + right_line_x(i))/2),...
        %  int16((left_line_y(int16(right_line_num/left_line_num*i)) + right_line_y(i))/2))...
        %  = 0;
        y(mid_point_x(mid_point_num),mid_point_y(mid_point_num)) = 0;
    end
else
    for i = 1:1:left_line_num
        %y(int16((right_line_x(int16(left_line_num/right_line_num*i)) + left_line_x(i))/2),...
        %  int16((right_line_y(int16(left_line_num/right_line_num*i)) + left_line_y(i))/2))...
        %  = 0;
        mid_point_x(mid_point_num + 1) = int16((right_line_x(int16(left_line_num/right_line_num*i + 1)) + left_line_x(i))/2);
        mid_point_y(mid_point_num + 1) = int16((right_line_y(int16(left_line_num/right_line_num*i + 1)) + left_line_y(i))/2);
        mid_point_num = mid_point_num + 1;
        y(mid_point_x(mid_point_num),mid_point_y(mid_point_num)) = 0;
    end
end

figure(22);
imshow(photo,[0,255]);
figure(23);


end

