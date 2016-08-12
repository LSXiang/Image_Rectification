function y = car_image_process( n )
%CAR_IMAGE_PROCESS
%˵�������ձ��Ƽ������波�Ե�ͼ�����㷨���� bt_image_process �������Ժ���Ϊ���㷨��ʵ����
%     �������� bt_image_process �����ĸĽ��汾�����롢���ͼ���С��Ϊ 140x110
%     �����������˶��ϰ��������ߺ�ֱ������ʾ���ߵ����⴦��
%     �����ͼ���������ȡ�����������ұ��߼�����
%����ʾ����
%     imshow(car_image_process(imread('�ϰ�1 140x110.bmp')));

%==============================%
%��ֲʱ�������з������Է�������Ӱ��
%==============================%

y = ones(110,140)*255;            %���ڷ���
photo = n;                        % copy ԭͼ�����Ϊԭͼ��ʹ��

left_line_x = zeros(200);         %����ߵ� x ����
left_line_y = zeros(200);         %����ߵ� y ����
left_line_num = int16(0);         %����߸���
right_line_x = zeros(200);        %�ұ��ߵ� x ����
right_line_y = zeros(200);        %�ұ��ߵ� y ����
right_line_num = int16(0);        %�ұ��ߵĸ���

left_line_search_flag = 0;        %�����������������
right_line_search_flag = 0;       %�ұ���������������
left_line_turning_x = 0;          %������ɺ���������Ϊ����������ת�۵�� x ����
left_line_turning_y = 0;          %������ɺ���������Ϊ����������ת�۵�� y ����
right_line_turning_x = 0;         %�ұ����ɺ���������Ϊ����������ת�۵�� x ����
right_line_turning_y = 0;         %�ұ����ɺ���������Ϊ����������ת�۵�� y ����
left_line_turning_num = 0;        %������ɺ���������Ϊ����������ת�۵�ʱ������
right_line_turning_num = 0;       %�ұ����ɺ���������Ϊ����������ת�۵�ʱ������

cross_second_left_line_x = 0;     %ʮ�����ϰ벿����������� x ����
cross_second_left_line_y = 0;     %ʮ�����ϰ벿����������� y ����
cross_second_right_line_x = 0;    %ʮ�����ϰ벿���ұ������� x ����
cross_second_right_line_y = 0;    %ʮ�����ϰ벿���ұ������� y ����

mid_point_x = zeros(200);         %�е�� x ����
mid_point_y = zeros(200);         %�е�� y ����
mid_point_num = int16(0);         %�е�ĸ���

thick_black_line_left_x = 0;      %��ʾ��ֱ�ǵĴֺ��ߣ�������Ϊһ�����Σ����Ͻǵ�� x ����
thick_black_line_left_y = 0;      %��ʾ��ֱ�ǵĴֺ��ߣ�������Ϊһ�����Σ����Ͻǵ�� y ���� 
thick_black_line_right_x = 0;     %��ʾ��ֱ�ǵĴֺ��ߣ�������Ϊһ�����Σ����Ͻǵ�� x ����
thick_black_line_right_y = 0;     %��ʾ��ֱ�ǵĴֺ��ߣ�������Ϊһ�����Σ����Ͻǵ�� y ���� 


%1.ͼ��ѹ������ֵ��
for i = 1:1:110
    for j = 1:1:140
        if n(i,j)>100
            photo(i,j) = 255;
        else
            photo(i,j) = 0;
        end
    end
end

%2.��¼�ᡢ�������������
for i = 110:-1:2
    for j = 1:1:139
        if ((photo(i,j) ~= photo(i,j+1)) || (photo(i,j) ~= photo(i-1,j)))
            y(i,j) = 0;
        else
            y(i,j) = 255;
        end
    end
end

photo = y;        %���½� photo ��Ϊԭʼ����

%3.��ȡ�����
%3.1������ͼ�����¶�ȷ����ʼ����
for i = 70:-1:1
    if photo(110,i) < 100
        left_line_x(1) = 110;
        left_line_y(1) = i;
        left_line_num  = left_line_num + 1;
        break;
    end
    %���������������������������
    if i == 1
        left_line_x(1) = 110;
        left_line_y(1) = 1;
        left_line_num  = left_line_num + 1;
    end
end

%3.2���������������ߣ��������������Ϊֹ
for i = 109:-1:1
    %�������һ�� y λ���ұ�һ�����ѵ���ɫ�����¼λ��
    if photo(i,left_line_y(left_line_num) + 1) < 100
        left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
        left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 1;    %��¼ y ����
        left_line_num = left_line_num + 1;                                  %��������ߵ����
    %�������һ�� y λ���ұ��������ѵ���ɫ�����¼λ��
    elseif photo(i,left_line_y(left_line_num) + 2) < 100
        left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
        left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 2;    %��¼ y ����
        left_line_num = left_line_num + 1;                                  %��������ߵ����
    %�������һ�� y λ����ͬ���ѵ���ɫ�����¼λ��    
    elseif photo(i,left_line_y(left_line_num)) < 100
        left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
        left_line_y(left_line_num + 1) = left_line_y(left_line_num);        %��¼ y ����
        left_line_num = left_line_num + 1;                                  %��������ߵ����
    %�������һ�� y λ����ͬ����ұ�һ������û�ѵ���ɫ������һ�е� x λ��Ϊ���������Ϊ��������ߵ�Ϊ�����
    elseif left_line_y(left_line_num) == 1
        left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
        left_line_y(left_line_num + 1) = 1;                                 %��¼ y ����
        left_line_num = left_line_num + 1;                                  %��������ߵ����
    %�������һ�� y λ�����һ�����ѵ���ɫ�����¼λ��
    elseif photo(i,left_line_y(left_line_num) - 1) < 100
        left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
        left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 1;    %��¼ y ����
        left_line_num = left_line_num + 1;                                  %��������ߵ����
    %�������һ�� y λ����ͬ����ұ�һ�����㡢���һ��û�ѵ���ɫ������һ�е� x λ��Ϊ�������ڶ�������Ϊ��������ߵ�Ϊ�����
    elseif left_line_y(left_line_num) == 2
        left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
        left_line_y(left_line_num + 1) = 1;                                 %��¼ y ����
        left_line_num = left_line_num + 1;                                  %��������ߵ����
    %�������һ�� y λ������������ѵ���ɫ�����¼λ��
    elseif photo(i,left_line_y(left_line_num) - 2) < 100
        left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
        left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 2;    %��¼ y ����
        left_line_num = left_line_num + 1;                                  %��������ߵ����
    %�������һ�� y λ����ߡ��ұߺ���ͬ�㶼�Ѳ�����ɫ������Ϊ�Ƕ���
    else
        break;
    end
end
left_line_turning_x = left_line_x(left_line_num);                           %��¼�����ת�۵� x ����
left_line_turning_y = left_line_y(left_line_num);                           %��¼�����ת�۵� y ����
left_line_turning_num = left_line_num;                                      %��¼�����ת�۵�����

%3.3�����������ߺ���������
%3.3.1�����ߺ�ɫ����ұ������������ұ�����
if (photo(left_line_x(left_line_num),left_line_y(left_line_num) - 1)...
   +photo(left_line_x(left_line_num),left_line_y(left_line_num) - 2)...
   +photo(left_line_x(left_line_num) - 1,left_line_y(left_line_num) - 1)...
   +photo(left_line_x(left_line_num) - 1,left_line_y(left_line_num) - 2)) >...
   (photo(left_line_x(left_line_num),left_line_y(left_line_num) + 1)...
   +photo(left_line_x(left_line_num),left_line_y(left_line_num) + 2)...
   +photo(left_line_x(left_line_num) - 1,left_line_y(left_line_num) + 1)...
   +photo(left_line_x(left_line_num) - 1,left_line_y(left_line_num) + 2))
    %��¼������Ѱ����1����  2���ң�
    left_line_search_flag = 2;
    %�Ӷ��ߵ�� y λ�������������������ĺڵ㣬ֱ���߽����
    for i = left_line_y(left_line_num) + 1:1:140
        %�������һ�� x λ������һ�����ѵ���ɫ�����¼λ��
        if photo(left_line_x(left_line_num) + 1,i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num) + 1;    %��¼ x ����
            left_line_y(left_line_num + 1) = i;                                 %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� x λ�õ���ͬλ���ѵ���ɫ�����¼λ��
        elseif photo(left_line_x(left_line_num),i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num);        %��¼ x ����
            left_line_y(left_line_num + 1) = i;                                 %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� x λ������һ�����ѵ���ɫ�����¼λ��
        elseif photo(left_line_x(left_line_num) - 1,i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num) - 1;    %��¼ x ����
            left_line_y(left_line_num + 1) = i;                                 %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %��������¶��Ѳ������ж϶��ߣ�����ѭ��
        else
            break;
        end
    end
   
%3.3.2����������������������    
else
    %��¼������Ѱ����1����  2���ң�
    left_line_search_flag = 1;
    %�Ӷ��ߵ�� y λ�������������������ĺڵ㣬ֱ���߽����
    for i = left_line_y(left_line_num) - 1:-1:1
        %�������һ�� x λ������һ�����ѵ���ɫ�����¼λ��
        if photo(left_line_x(left_line_num) + 1,i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num) + 1;    %��¼ x ����
            left_line_y(left_line_num + 1) = i;                                 %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� x λ�õ���ͬλ���ѵ���ɫ�����¼λ��
        elseif photo(left_line_x(left_line_num),i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num);        %��¼ x ����
            left_line_y(left_line_num + 1) = i;                                 %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� x λ������һ�����ѵ���ɫ�����¼λ��
        elseif photo(left_line_x(left_line_num) - 1,i) < 100
            left_line_x(left_line_num + 1) = left_line_x(left_line_num) - 1;    %��¼ x ����
            left_line_y(left_line_num + 1) = i;                                 %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %��������¶��Ѳ������ж϶��ߣ�����ѭ��
        else
            break;
        end
    end
end

%4.��ȡ�ұ���
%4.1������ͼ�����¶�ȷ����ʼ����
for i = 70:1:140
    if photo(110,i) < 100
        right_line_x(1) = 110;
        right_line_y(1) = i;
        right_line_num  = right_line_num + 1;
        break;
    end
    %���������������������������
    if i == 140
        right_line_x(1) = 110;
        right_line_y(1) = 140;
        right_line_num  = right_line_num + 1;
    end
end

%4.2���������������ߣ��������������Ϊֹ
for i = 109:-1:1
    %�������һ�� y λ�����һ�����ѵ���ɫ�����¼λ��
    if photo(i,right_line_y(right_line_num) - 1) < 100
        right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
        right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 1;   %��¼ y ����
        right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
    %�������һ�� y λ������������ѵ���ɫ�����¼λ��
    elseif photo(i,right_line_y(right_line_num) - 2) < 100
        right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
        right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 2;   %��¼ y ����
        right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
    %�������һ�� y λ����ͬ���ѵ���ɫ�����¼λ��    
    elseif photo(i,right_line_y(right_line_num)) < 100
        right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
        right_line_y(right_line_num + 1) = right_line_y(right_line_num);       %��¼ y ����
        right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
    %�������һ�� y λ����ͬ������һ������û�ѵ���ɫ������һ�е� x λ��Ϊ���ұ�����Ϊ�����ұ��ߵ�Ϊ���ҵ�
    elseif right_line_y(right_line_num) == 140
        right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
        right_line_y(right_line_num + 1) = 140;                                %��¼ y ����
        right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
    %�������һ�� y λ���ұ�һ�����ѵ���ɫ�����¼λ��
    elseif photo(i,right_line_y(right_line_num) + 1) < 100
        right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
        right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 1;   %��¼ y ����
        right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
    %�������һ�� y λ����ͬ������һ�����㡢�ұ�һ��û�ѵ���ɫ������һ�е� x λ��Ϊ���ұ���ڶ�������Ϊ�����ұ��ߵ�Ϊ���ҵ�
    elseif right_line_y(right_line_num) == 139
        right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
        right_line_y(right_line_num + 1) = 140;                                %��¼ y ����
        right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
    %�������һ�� y λ���ұ��������ѵ���ɫ�����¼λ��
    elseif photo(i,right_line_y(right_line_num) + 2) < 100
        right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
        right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 2;   %��¼ y ����
        right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
    %�������һ�� y λ����ߡ��ұߺ���ͬ�㶼�Ѳ�����ɫ������Ϊ�Ƕ���
    else
        break;
    end
end
right_line_turning_x = right_line_x(right_line_num);                        %��¼�ұ���ת�۵� x ����
right_line_turning_y = right_line_y(right_line_num);                        %��¼�ұ���ת�۵� y ����
right_line_turning_num = right_line_num;                                    %��¼�ұ���ת�۵�����

%4.3�����������ߺ���������
%4.3.1�����ߺ�ɫ����ұ������������ұ�����
if (photo(right_line_x(right_line_num),right_line_y(right_line_num) - 1)...
   +photo(right_line_x(right_line_num),right_line_y(right_line_num) - 2)...
   +photo(right_line_x(right_line_num) - 1,right_line_y(right_line_num) - 1)...
   +photo(right_line_x(right_line_num) - 1,right_line_y(right_line_num) - 2)) >...
   (photo(right_line_x(right_line_num),right_line_y(right_line_num) + 1)...
   +photo(right_line_x(right_line_num),right_line_y(right_line_num) + 2)...
   +photo(right_line_x(right_line_num) - 1,right_line_y(right_line_num) + 1)...
   +photo(right_line_x(right_line_num) - 1,right_line_y(right_line_num) + 2))
    %��¼������Ѱ����1����  2���ң�
    right_line_search_flag = 2;
    %�Ӷ��ߵ�� y λ�������������������ĺڵ㣬ֱ���߽����
    for i = right_line_y(right_line_num) + 1:1:140
        %�������һ�� x λ������һ�����ѵ���ɫ�����¼λ��
        if photo(right_line_x(right_line_num) + 1,i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num) + 1;    %��¼ x ����
            right_line_y(right_line_num + 1) = i;                                   %��¼ y ����
            right_line_num = right_line_num + 1;                                    %��������ߵ����
        %�������һ�� x λ�õ���ͬλ���ѵ���ɫ�����¼λ��
        elseif photo(right_line_x(right_line_num),i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num);        %��¼ x ����
            right_line_y(right_line_num + 1) = i;                                   %��¼ y ����
            right_line_num = right_line_num + 1;                                    %��������ߵ����
        %�������һ�� x λ������һ�����ѵ���ɫ�����¼λ��
        elseif photo(right_line_x(right_line_num) - 1,i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num) - 1;    %��¼ x ����
            right_line_y(right_line_num + 1) = i;                                   %��¼ y ����
            right_line_num = right_line_num + 1;                                    %��������ߵ����
        %��������¶��Ѳ������ж϶��ߣ�����ѭ��
        else
            break;
        end
    end
   
%4.3.2����������������������    
else
    %��¼������Ѱ����1����  2���ң�
    right_line_search_flag = 1;
    %�Ӷ��ߵ�� y λ�������������������ĺڵ㣬ֱ���߽����
    for i = right_line_y(right_line_num) - 1:-1:1
        %�������һ�� x λ������һ�����ѵ���ɫ�����¼λ��
        if photo(right_line_x(right_line_num) + 1,i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num) + 1;    %��¼ x ����
            right_line_y(right_line_num + 1) = i;                                   %��¼ y ����
            right_line_num = right_line_num + 1;                                    %��������ߵ����
        %�������һ�� x λ�õ���ͬλ���ѵ���ɫ�����¼λ��
        elseif photo(right_line_x(right_line_num),i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num);        %��¼ x ����
            right_line_y(right_line_num + 1) = i;                                   %��¼ y ����
            right_line_num = right_line_num + 1;                                    %��������ߵ����
        %�������һ�� x λ������һ�����ѵ���ɫ�����¼λ��
        elseif photo(right_line_x(right_line_num) - 1,i) < 100
            right_line_x(right_line_num + 1) = right_line_x(right_line_num) - 1;    %��¼ x ����
            right_line_y(right_line_num + 1) = i;                                   %��¼ y ����
            right_line_num = right_line_num + 1;                                    %��������ߵ����
        %��������¶��Ѳ������ж϶��ߣ�����ѭ��
        else
            break;
        end
    end
end

%==================================================%
%==================��������Ԫ�ش���==================%
%==================================================%

%5.ʮ�������⴦��
%�������������������������Ϊ�����ң��ұ���������������Ϊ���ң��ң����ұ��߽�ֹ��Ϊͼ��߽� 5 ���㣩��ʱ��ֱ���䴦��
if (left_line_search_flag == 1) && (right_line_search_flag == 2) &&...
   (left_line_y(left_line_num) < 5) && (right_line_y(right_line_num) > 135)
    %5.1����ʮ�����ϰ벿�ֵ������
    %5.1.1��������������� 5 ����������Ѱʮ�����ϰ벿�ֵı߽���ʼ�㣬����յ����ͼ������㲻�� 5 ������ȡ�����
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
    %5.1.2��������ʼ�������������������
    for i = cross_second_left_line_y + 1:1:138
        %�������һ�������Ϸ�һ�����ѵ���ɫ��
        if photo(cross_second_left_line_x - 1,i) < 100
            cross_second_left_line_x = cross_second_left_line_x - 1;
            cross_second_left_line_y = i;
        %�������һ�������ҷ�һ�����ѵ���ɫ��
        elseif photo(cross_second_left_line_x,i) < 100
            cross_second_left_line_y = i;
        %�������һ�������·�һ�����ѵ���ɫ��
        elseif photo(cross_second_left_line_x + 1,i) < 100
            cross_second_left_line_x = cross_second_left_line_x + 1;
            cross_second_left_line_y = i;
        %����������������жϴ˵�Ϊת�ǵ�
        else
            break;
        end        
    end
    %5.1.3��ԭͼ���Ͻ�ʮ��������ߵ�����ת�ǵ�����
    %5.1.3.1������ߵ����򳤶ȴ��ں��򳤶ȣ���ƽ�����жϿ���������Ӱ�죩
    if (left_line_turning_x - cross_second_left_line_x)*(left_line_turning_x - cross_second_left_line_x)...
      >(left_line_turning_y - cross_second_left_line_y)*(left_line_turning_y - cross_second_left_line_y)
        for i = 0:1:left_line_turning_x - cross_second_left_line_x 
            photo(int16(cross_second_left_line_x + i),...
                  int16(cross_second_left_line_y + i*...
                  (left_line_turning_y - cross_second_left_line_y)/...
                  (left_line_turning_x - cross_second_left_line_x))) = 0;
        end
    %5.1.3.2������ߵ����򳤶�С�ڻ���ں��򳤶����°벿�ֹյ����ϰ벿�ֹյ��ұ�    
    elseif left_line_turning_y > cross_second_left_line_y 
        for i = 0:1:left_line_turning_y - cross_second_left_line_y 
            photo(int16(cross_second_left_line_y + i),...
                  int16(cross_second_left_line_x + i*...
                  (left_line_turning_x - cross_second_left_line_x)/...
                  (left_line_turning_y - cross_second_left_line_y))) = 0;
        end
    %5.1.3.3������ߵ����򳤶�С�ڻ���ں��򳤶����°벿�ֹյ����ϰ벿�ֹյ���߻� y ������ͬ    
    else
        for i = 0:1:cross_second_left_line_y - left_line_turning_y  
            photo(int16(cross_second_left_line_y + i),...
                  int16(cross_second_left_line_x + i*...
                  (left_line_turning_x - cross_second_left_line_x)/...
                  (left_line_turning_y - cross_second_left_line_y))) = 0;
        end
    end  
    
    %5.2����ʮ�����ϰ벿�ֵ��ұ���
    %5.2.1���ұ��߹յ����ҵ��� 5 ����������Ѱʮ�����ϰ벿�ֵı߽���ʼ�㣬����յ����ͼ�����ҵ㲻�� 5 ������ȡ���ҵ�
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
    %5.2.2��������ʼ�������������������
    for i = cross_second_right_line_y - 1:-1:3
        %�������һ�������Ϸ�һ�����ѵ���ɫ��
        if photo(cross_second_right_line_x - 1,i) < 100
            cross_second_right_line_x = cross_second_right_line_x - 1;
            cross_second_right_line_y = i;
        %�������һ��������һ�����ѵ���ɫ��
        elseif photo(cross_second_right_line_x,i) < 100
            cross_second_right_line_y = i;
        %�������һ�������·�һ�����ѵ���ɫ��
        elseif photo(cross_second_right_line_x + 1,i) < 100
            cross_second_right_line_x = cross_second_right_line_x + 1;
            cross_second_right_line_y = i;
        %����������������жϴ˵�Ϊת�ǵ�
        else
            break;
        end        
    end
    %5.2.3��ԭͼ���Ͻ�ʮ�����ұ��ߵ�����ת�ǵ�����
    %5.2.3.1������ߵ����򳤶ȴ��ں��򳤶ȣ���ƽ�����жϿ���������Ӱ�죩
    if (right_line_turning_x - cross_second_right_line_x)*(right_line_turning_x - cross_second_right_line_x)...
      >(right_line_turning_y - cross_second_right_line_y)*(right_line_turning_y - cross_second_right_line_y)
        for i = 0:1:right_line_turning_x - cross_second_right_line_x 
            photo(int16(cross_second_right_line_x + i),...
                  int16(cross_second_right_line_y + i*...
                  (right_line_turning_y - cross_second_right_line_y)/...
                  (right_line_turning_x - cross_second_right_line_x))) = 0;
        end
    %5.2.3.2������ߵ����򳤶�С�ڻ���ں��򳤶����°벿�ֹյ����ϰ벿�ֹյ��ұ�    
    elseif right_line_turning_y > cross_second_right_line_y 
        for i = 0:1:right_line_turning_y - cross_second_right_line_y 
            photo(int16(cross_second_right_line_y + i),...
                  int16(cross_second_right_line_x + i*...
                  (right_line_turning_x - cross_second_right_line_x)/...
                  (right_line_turning_y - cross_second_right_line_y))) = 0;
        end
    %5.2.3.3������ߵ����򳤶�С�ڻ���ں��򳤶����°벿�ֹյ����ϰ벿�ֹյ���߻� y ������ͬ    
    else
        for i = 0:1:cross_second_right_line_y - right_line_turning_y  
            photo(int16(cross_second_right_line_y + i),...
                  int16(cross_second_right_line_x + i*...
                  (right_line_turning_x - cross_second_right_line_x)/...
                  (right_line_turning_y - cross_second_right_line_y))) = 0;
        end
    end
    %5.3������ȡ����
    %5.3.1������߹յ������������������ߣ��������������Ϊֹ
    left_line_num = left_line_turning_num;                                      %����߹յ�֮��ļ�¼ȫ��ɾ��
    for i = left_line_turning_x - 1:-1:1
        %�������һ�� y λ���ұ�һ�����ѵ���ɫ�����¼λ��
        if photo(i,left_line_y(left_line_num) + 1) < 100
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 1;    %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ���ұ��������ѵ���ɫ�����¼λ��
        elseif photo(i,left_line_y(left_line_num) + 2) < 100
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 2;    %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ����ͬ���ѵ���ɫ�����¼λ��    
        elseif photo(i,left_line_y(left_line_num)) < 100
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = left_line_y(left_line_num);        %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ����ͬ����ұ�һ������û�ѵ���ɫ������һ�е� x λ��Ϊ���������Ϊ��������ߵ�Ϊ�����
        elseif left_line_y(left_line_num) == 1
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = 1;                                 %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ�����һ�����ѵ���ɫ�����¼λ��
        elseif photo(i,left_line_y(left_line_num) - 1) < 100
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 1;    %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ����ͬ����ұ�һ�����㡢���һ��û�ѵ���ɫ������һ�е� x λ��Ϊ�������ڶ�������Ϊ��������ߵ�Ϊ�����
        elseif left_line_y(left_line_num) == 2
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = 1;                                 %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ������������ѵ���ɫ�����¼λ��
        elseif photo(i,left_line_y(left_line_num) - 2) < 100
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 2;    %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ����ߡ��ұߺ���ͬ�㶼�Ѳ�����ɫ������Ϊ�Ƕ���
        else
            break;
        end
    end
    %5.3.2���ұ��߹յ���������������ұ��ߣ��������������Ϊֹ
    right_line_num = right_line_turning_num;                                    %�ұ��߹յ�֮��ļ�¼ȫ��ɾ��
    for i = right_line_turning_x - 1:-1:1
        %�������һ�� y λ�����һ�����ѵ���ɫ�����¼λ��
        if photo(i,right_line_y(right_line_num) - 1) < 100
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 1;   %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ������������ѵ���ɫ�����¼λ��
        elseif photo(i,right_line_y(right_line_num) - 2) < 100
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 2;   %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ����ͬ���ѵ���ɫ�����¼λ��    
        elseif photo(i,right_line_y(right_line_num)) < 100
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = right_line_y(right_line_num);       %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ����ͬ������һ������û�ѵ���ɫ������һ�е� x λ��Ϊ���ұ�����Ϊ�����ұ��ߵ�Ϊ���ҵ�
        elseif right_line_y(right_line_num) == 140
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = 140;                                %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ���ұ�һ�����ѵ���ɫ�����¼λ��
        elseif photo(i,right_line_y(right_line_num) + 1) < 100
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 1;   %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ����ͬ������һ�����㡢�ұ�һ��û�ѵ���ɫ������һ�е� x λ��Ϊ���ұ���ڶ�������Ϊ�����ұ��ߵ�Ϊ���ҵ�
        elseif right_line_y(right_line_num) == 139
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = 140;                                %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ���ұ��������ѵ���ɫ�����¼λ��
        elseif photo(i,right_line_y(right_line_num) + 2) < 100
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 2;   %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ����ߡ��ұߺ���ͬ�㶼�Ѳ�����ɫ������Ϊ�Ƕ���
        else
            break;
        end
    end
    
%6.��ֱ����ǰ�ֺ������⴦�� 
%����������������Ҽ����ҹյ��ͼ��ײ�С�� 30 �У� �� ���ұ������󼱹��ҹյ��ͼ��ײ�С�� 30 �У���ʱ�ж�ǰ��Ϊ������ʾֱ����Ĵֺ���
elseif ((left_line_search_flag == 2) && (left_line_turning_x > 80)) || ...
       ((right_line_search_flag == 1) && (right_line_turning_x > 80))
    %6.1�ڡ�ԭͼ���д�ͼ�������λ������������������ɫ����������ɫ�㣬�ѵ���ɫ�����¼��λ��
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
    %6.2���������������������յ�ֹͣ
    %6.2.1��������ʼ�������������������
    for i = thick_black_line_left_y - 1:-1:3
        %�������һ�������Ϸ�һ�����ѵ���ɫ��
        if photo(thick_black_line_left_x - 1,i) < 100
            thick_black_line_left_x = thick_black_line_left_x - 1;
            thick_black_line_left_y = i;
        %�������һ��������һ�����ѵ���ɫ��
        elseif photo(thick_black_line_left_x,i) < 100
            thick_black_line_left_y = i;
        %�������һ�������·�һ�����ѵ���ɫ��
        elseif photo(thick_black_line_left_x + 1,i) < 100
            thick_black_line_left_x = thick_black_line_left_x + 1;
            thick_black_line_left_y = i;
        %����������������жϴ˵�Ϊת�ǵ�
        else
            break;
        end        
    end
    %��֮ǰ�����������ɾ��
    left_line_num = 1;                                                         
    left_line_x(1) = thick_black_line_left_x;
    left_line_y(1) = thick_black_line_left_y;
    %6.2.2��ת�ǵ�������������������
    for i = thick_black_line_left_x - 1:-1:1
        %�������һ�� y λ���ұ�һ�����ѵ���ɫ�����¼λ��
        if photo(i,left_line_y(left_line_num) + 1) < 100
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 1;    %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ���ұ��������ѵ���ɫ�����¼λ��
        elseif photo(i,left_line_y(left_line_num) + 2) < 100
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) + 2;    %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ����ͬ���ѵ���ɫ�����¼λ��    
        elseif photo(i,left_line_y(left_line_num)) < 100
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = left_line_y(left_line_num);        %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ����ͬ����ұ�һ������û�ѵ���ɫ������һ�е� x λ��Ϊ���������Ϊ��������ߵ�Ϊ�����
        elseif left_line_y(left_line_num) == 1
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = 1;                                 %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ�����һ�����ѵ���ɫ�����¼λ��
        elseif photo(i,left_line_y(left_line_num) - 1) < 100
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 1;    %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ����ͬ����ұ�һ�����㡢���һ��û�ѵ���ɫ������һ�е� x λ��Ϊ�������ڶ�������Ϊ��������ߵ�Ϊ�����
        elseif left_line_y(left_line_num) == 2
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = 1;                                 %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ������������ѵ���ɫ�����¼λ��
        elseif photo(i,left_line_y(left_line_num) - 2) < 100
            left_line_x(left_line_num + 1) = i;                                 %��¼ x ����
            left_line_y(left_line_num + 1) = left_line_y(left_line_num) - 2;    %��¼ y ����
            left_line_num = left_line_num + 1;                                  %��������ߵ����
        %�������һ�� y λ����ߡ��ұߺ���ͬ�㶼�Ѳ�����ɫ������Ϊ�Ƕ���
        else
            break;
        end
    end
    %6.3Ȼ�������������������յ�ֹͣ
    %6.3.1����ʼ�������������������
    for i = thick_black_line_right_y + 1:1:138
        %�������һ�������Ϸ�һ�����ѵ���ɫ��
        if photo(thick_black_line_right_x - 1,i) < 100
            thick_black_line_right_x = thick_black_line_right_x - 1;
            thick_black_line_right_y = i;
        %�������һ�������ҷ�һ�����ѵ���ɫ��
        elseif photo(thick_black_line_right_x,i) < 100
            thick_black_line_right_y = i;
        %�������һ�������·�һ�����ѵ���ɫ��
        elseif photo(thick_black_line_right_x + 1,i) < 100
            thick_black_line_right_x = thick_black_line_right_x + 1;
            thick_black_line_right_y = i;
        %����������������жϴ˵�Ϊת�ǵ�
        else
            break;
        end        
    end
    %��֮ǰ�������ұ���ɾ��
    right_line_num = 1;                                                         
    right_line_x(1) = thick_black_line_right_x;
    right_line_y(1) = thick_black_line_right_y;
    %6.2.2��ת�ǵ���������������ұ���
    for i = thick_black_line_right_x - 1:-1:1
        %�������һ�� y λ�����һ�����ѵ���ɫ�����¼λ��
        if photo(i,right_line_y(right_line_num) - 1) < 100
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 1;   %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ������������ѵ���ɫ�����¼λ��
        elseif photo(i,right_line_y(right_line_num) - 2) < 100
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) - 2;   %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ����ͬ���ѵ���ɫ�����¼λ��    
        elseif photo(i,right_line_y(right_line_num)) < 100
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = right_line_y(right_line_num);       %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ����ͬ������һ������û�ѵ���ɫ������һ�е� x λ��Ϊ���ұ�����Ϊ�����ұ��ߵ�Ϊ���ҵ�
        elseif right_line_y(right_line_num) == 140
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = 140;                                %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ���ұ�һ�����ѵ���ɫ�����¼λ��
        elseif photo(i,right_line_y(right_line_num) + 1) < 100
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 1;   %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ����ͬ������һ�����㡢�ұ�һ��û�ѵ���ɫ������һ�е� x λ��Ϊ���ұ���ڶ�������Ϊ�����ұ��ߵ�Ϊ���ҵ�
        elseif right_line_y(right_line_num) == 139
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = 140;                                %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ���ұ��������ѵ���ɫ�����¼λ��
        elseif photo(i,right_line_y(right_line_num) + 2) < 100
            right_line_x(right_line_num + 1) = i;                                  %��¼ x ����
            right_line_y(right_line_num + 1) = right_line_y(right_line_num) + 2;   %��¼ y ����
            right_line_num = right_line_num + 1;                                   %�����ұ��ߵ����
        %�������һ�� y λ����ߡ��ұߺ���ͬ�㶼�Ѳ�����ɫ������Ϊ�Ƕ���
        else
            break;
        end
    end
end


%=========================%
%C������ֲʱע���־����������
%=========================%

%------------------------------------------------------------------------------------------------%

%��շ�������
y = ones(110,140)*255;

%���������߳���
if left_line_num > right_line_num + 25
    left_line_num = right_line_num + 25;
elseif right_line_num > left_line_num + 25
    right_line_num = left_line_num + 25;
end

%�����ұ�������ת��������������
for i = 1:1:left_line_num
    y(left_line_x(i),left_line_y(i)) = 0;
end
for i = 1:1:right_line_num
    y(right_line_x(i),right_line_y(i)) = 0;
end

%�����е�
%�������߳��ȴ����ұ���
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

