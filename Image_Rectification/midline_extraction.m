% C���ĺ�������ű�

vision = ones(110,1);
sizeofRow = ones(110,1);
a = ones(110,1);
b = ones(110,1);
lateral_correction_array = ones(110,140);

%������������� cm
farSight  = 145; 
nearSight = 0;
farWidth  = 220;
nearWidth = 45;

row = 110;              %�ܹ���110��
column = 30;            %��Զ�� ����cm ��Ӧ column ��

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

%����ϵ����
correction_array = ones(110,1);

%У��ϵ�����
for i = 1 : 1 : 110
    if i < 66
        correction_array(i) = 2*round( 0.25*(sqrt(65*65-(66-i)*(66-i))-i*55/110) ); 
    else
        correction_array(i) = 2*round( 0.25*(sqrt(66*66-(i-66)*(i-66))-i*55/110)+1);
    end
end


%��������sizeofRow
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

%MIDLINE_EXTRACTION �ú���������ȡ��������
%version  1.0
%author   TJiTR__LSXiang
%date     2015-4-30

%�����������ʱ���ں����ⶨ������
track_width = 31;                       %�������Ϊ30�����ص��
midline_coordinate_array = ones(110,2); %������������
left_border_buf = [0 0];                %��߽�����ݴ���
left_border_flag = 0;                   %��߽�Ѱ�ұ�ǡ�1��Ѱ����߽磻 0��δѰ����߽�
right_border_buf = [0 0];               %��߽�����ݴ���
right_border_flag = 0;                  %�ұ߽�Ѱ�ұ�ǡ�1��Ѱ����߽磻 0��δѰ����߽�
last_midline_coordinate = [70 110];     %��һ�е������
special_treatment = 0;                  %���⴦�����
special_coordinate = [0 0];             %����λ��
last_special_row = 0;                   %ǰһ�ε�������
special_count = 0;                      %�����������
left_margin_loss_flag = 0;              %��߽綪ʧ���
right_margin_loss_flag = 0;             %�ұ߽綪ʧ���
upside_flag = 0;                        %�ϱ߽�
below_flag = 0;                         %�±߽�


left_border_buf(1) =  55;
right_border_buf(1) = 85;
%��Ҫ�㷨���£�
for z = 1:1:110
    i = 111 - z;
    left_border_flag = 0;
    right_border_flag = 0;
    left_margin_loss_flag = 0;            
    right_margin_loss_flag = 0;
    for j = 1:1:sizeofRow(i)*2
        if( (left_border_flag && right_border_flag)==0 && (left_border_flag && right_margin_loss_flag)==0 && (left_margin_loss_flag && right_border_flag)==0 && (left_margin_loss_flag && right_margin_loss_flag)==0 )
            if z < 80
                %Ѱ��������߽�
                if left_border_flag == 0
                    if((last_midline_coordinate(1) - j) > (70 - sizeofRow(i)))
                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                            left_border_flag = 1;                                           %���Ѱ��������߽�
                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %����߽�x����
                            left_border_buf(2) = i;                                         %����߽�y����
                        end
                    else
                        left_margin_loss_flag = 1;
                    end
                end
                %Ѱ�������ұ߽�
                if right_border_flag == 0
                    if((last_midline_coordinate(1) + j) < (70 + sizeofRow(i)))
                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                            right_border_flag = 1;                                          %���Ѱ�������ұ߽�
                            right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                            right_border_buf(2) = i;
                        end
                    else
                        right_margin_loss_flag = 1;
                    end
                end                
            else
                %Ѱ��������߽�
                if left_border_flag == 0
                    if((last_midline_coordinate(1) - j) > (75 - sizeofRow(i)))
                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                            left_border_flag = 1;                                           %���Ѱ��������߽�
                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %����߽�x����
                            left_border_buf(2) = i;                                         %����߽�y����
                        end
                    else
                        left_margin_loss_flag = 1;
                    end
                end
                %Ѱ�������ұ߽�
                if right_border_flag == 0
                    if((last_midline_coordinate(1) + j) < (65 + sizeofRow(i)))
                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                            right_border_flag = 1;                                          %���Ѱ�������ұ߽�
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
    
    if (left_border_flag && right_border_flag)                                  %���߶�Ѱ���߽�
        if( last_midline_coordinate(1)-left_border_buf(1)<4)                    %�ж��Ƿ���ֵ�������
            if( right_border_buf(1)-last_midline_coordinate(1)<4)               %�ж��Ƿ���ֵ������ߣ����߶��ҵ������ߣ�
                if(photo(left_border_buf(2),left_border_buf(1)-3)==0)&&(photo(left_border_buf(2),left_border_buf(1)-2)==0) && (photo(right_border_buf(2),right_border_buf(1)+2)==0) && (photo(right_border_buf(2),right_border_buf(1)+3)==0)      %�ж��Ƿ���ֺڸ�
                    special_treatment = 6;                                      %���⴦�� 6��ֱ�Ǻ��ߣ�
                    break;
                else
                    midline_coordinate_array(111-i,1) = floor(0.5*(left_border_buf(1)+right_border_buf(1)));
                    midline_coordinate_array(111-i,2) = floor(0.5*(left_border_buf(2)+right_border_buf(2)));
                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                end
            else                                                                %�ж��Ƿ���ֵ������ߣ�����������ߣ�
                if(photo(left_border_buf(2),left_border_buf(1)-3)==0)&&(photo(left_border_buf(2),left_border_buf(1)-2)==0) && (photo(left_border_buf(2),left_border_buf(1)+2)==0)&&(photo(left_border_buf(2),left_border_buf(1)+3)==0)      %�ж��Ƿ���ֺڸ�
                    special_treatment = 6;                                      %���⴦�� 6��ֱ�Ǻ��ߣ�
                    break;
                else
                    midline_coordinate_array(111-i,1) = left_border_buf(1);
                    midline_coordinate_array(111-i,2) = left_border_buf(2);
                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                end
            end
        else if( right_border_buf(1)-last_midline_coordinate(1)<4)              %�ж��Ƿ���ֵ������ߣ����������ұߣ�
                if(photo(right_border_buf(2),right_border_buf(1)+2)==0) && (photo(right_border_buf(2),right_border_buf(1)+3)==0) && (photo(right_border_buf(2),right_border_buf(1)-2)==0) && (photo(right_border_buf(2),right_border_buf(1)-3)==0)      %�ж��Ƿ���ֺڸ�
                    special_treatment = 6;                                       %���⴦�� 6��ֱ�Ǻ��ߣ�
                    break;
                else
                    midline_coordinate_array(111-i,1) = right_border_buf(1);
                    midline_coordinate_array(111-i,2) = right_border_buf(2);
                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                end
            else if( right_border_buf(1)-left_border_buf(1) <= 20)               %�ж��Ƿ�����ϰ����߳������
                    special_treatment = 1;                                       %���⴦�� 1
                    break;
                else
                    midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                    midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                end
            end
        end               
    else if( (left_border_flag==0) && (right_border_flag==0) )                  %���߶�δѰ���߽�
            if i<100
                midline_coordinate_array(111-i-2,1) = floor((midline_coordinate_array(111-i-2,1)+midline_coordinate_array(111-i-3,1))/2);
                midline_coordinate_array(111-i-1,1) = floor((midline_coordinate_array(111-i-1,1)+midline_coordinate_array(111-i-2,1))/2);
                last_midline_coordinate(1) = midline_coordinate_array(111-i-1,1);
            end
            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
            midline_coordinate_array(111-i,2) = i;
            left_border_buf(2) = i;
            right_border_buf(2) = i;
        else if( (left_border_flag==1) && (right_border_flag==0) )              %��߽�Ѱ�����ұ߽綪ʧ 
                if( last_midline_coordinate(1)-left_border_buf(1)<4)            %�ж��Ƿ���ֵ�������
                    midline_coordinate_array(111-i,1) = left_border_buf(1);
                    midline_coordinate_array(111-i,2) = left_border_buf(2);
                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                %else if( right_border_buf(1)-last_midline_coordinate(1)<4)      %�ж��Ƿ���ֵ�������
                     %   midline_coordinate_array(111-i,1) = right_border_buf(1);
                     %   midline_coordinate_array(111-i,2) = right_border_buf(2);
                     %   last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                     %   last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                    else if( left_border_buf(1) + track_width -( 70 + sizeofRow(i)) >= 5 )      %��Ұ��
                            if i < 100                  %�ų��ϰ�����
                                special_treatment = 2;                              %���⴦�� 2���ұ߽綪ʧ����Ұ��
                                break;
                            else
                                right_border_buf(1) = left_border_buf(1) + track_width;
                                right_border_buf(2) = left_border_buf(2);
                                midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)-2;
                                midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            end
                        else if(left_border_buf(1) + track_width -( 70 + sizeofRow(i)) <= -5)   %��Ұ��                                
                                 if special_count >= 4                          %�����������������¼  ������Ϊ��>=��������1��
                                    special_treatment = 3;                          %���⴦�� 3���ұ߽綪ʧ����Ұ��
                                    break;
                                else
                                    if i == last_special_row - 1           %�ж�������������Ƿ���������������
                                        special_count = special_count + 1;      %��¼����������ִ���
                                        last_special_row = last_special_row -1; %��¼������
                                        midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                        midline_coordinate_array(111-i,2) = i;
                                    else
                                        special_count = 0;                      %�ж�����������ֲ���������0
                                        last_special_row = i;                   %��¼������
                                        special_coordinate(1) = right_border_buf(1); %��¼������
                                        special_coordinate(2) = i;                   %��¼������
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
            else if( (left_border_flag==0) && (right_border_flag==1) )          %�ұ߽�Ѱ������߽綪ʧ
                    %if( last_midline_coordinate(1)-left_border_buf(1)<4)        %�ж��Ƿ���ֵ�������
                        %midline_coordinate_array(111-i,1) = left_border_buf(1);
                        %midline_coordinate_array(111-i,2) = left_border_buf(2);
                        %last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                        %last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                    %else 
                    if( right_border_buf(1)-last_midline_coordinate(1)<4)  %�ж��Ƿ���ֵ�������
                            midline_coordinate_array(111-i,1) = right_border_buf(1);
                            midline_coordinate_array(111-i,2) = right_border_buf(2);
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        else if( right_border_buf(1) - track_width -( 70 - sizeofRow(i)) <= -5 )    %��Ұ��
                                if i < 100           %�ų��ϰ�����
                                    special_treatment = 4;                          %���⴦�� 4����߽綪ʧ����Ұ��
                                    break;
                                else
                                    left_border_buf(1) = right_border_buf(1)-track_width;
                                    left_border_buf(2) = right_border_buf(2);
                                    midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)+2;
                                    midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                end
                            else if(right_border_buf(1) - track_width -( 70 - sizeofRow(i)) >= 5)   %��Ұ��
                                    if special_count >= 4;                          %�����������������¼  ������Ϊ��>=��������1��
                                        special_treatment = 5;                      %���⴦�� 5����߽綪ʧ����Ұ��
                                        break;
                                    else
                                        if i == last_special_row - 1           %�ж�������������Ƿ���������������
                                            special_count = special_count + 1;      %��¼����������ִ���
                                            last_special_row = last_special_row -1; %��¼������
                                            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                                            midline_coordinate_array(111-i,2) = i;
                                        else
                                            special_count = 0;                      %�ж�����������ֲ���������0
                                            last_special_row = i;                   %��¼������
                                            special_coordinate(1) = left_border_buf(1); %��¼������
                                            special_coordinate(2) = i;                  %��¼������
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
    
    if special_treatment ~= 0                   %�������⴦���ǣ����˳�ѭ���������Ӧ���⴦�����
        break;
    end
    
    %���߳�����ͼ��߽磬���˳�ѭ���������ڵ����ߣ�
    if ((midline_coordinate_array(111-i,1) - (70 - sizeofRow(i)) <= 5)) || (((70 + sizeofRow(i) - midline_coordinate_array(111-i,1)) <= 5))
        break;
    end
    
end




switch special_treatment
    case 1
        special_coordinate(1) = floor(0.5*(right_border_buf(1)+left_border_buf(1))); %��¼������
        special_coordinate(2) = i;                  %��¼������
        last_midline_coordinate(1) = special_coordinate(1);
        last_midline_coordinate(2) = special_coordinate(2);
        
        if special_coordinate(2) > 30 
            %�ж��Ƿ��ǳ�����ں��
            if((photo(special_coordinate(2)-15,special_coordinate(1)-2)==0)&&(photo(special_coordinate(2)-15,special_coordinate(1)-1)==0)) || ((photo(special_coordinate(2)-15,special_coordinate(1)+1)==0) && (photo(special_coordinate(2)-15,special_coordinate(1)+2)==0))      %�ж��Ƿ���ֺڸ�
                special_treatment = 7;                                      %���⴦�� 7��������ߣ�
            else  %Ϊ�ϰ�
                for i  = special_coordinate(2) : -1 : 30   %��ǰ��Ѱ�е�

                    left_border_flag = 0;
                    right_border_flag = 0;
                    left_margin_loss_flag = 0;            
                    right_margin_loss_flag = 0;
                    for j = 1:1:sizeofRow(i)*2
                        if( (left_border_flag && right_border_flag)==0 && (left_border_flag && right_margin_loss_flag)==0 && (left_margin_loss_flag && right_border_flag)==0 && (left_margin_loss_flag && right_margin_loss_flag)==0 )
                            if z < 80
                                %Ѱ��������߽�
                                if left_border_flag == 0
                                    if((last_midline_coordinate(1) - j) > (70 - sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                            left_border_flag = 1;                                           %���Ѱ��������߽�
                                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;        %����߽�x����
                                            left_border_buf(2) = i;                                         %����߽�y����
                                        end
                                    else
                                        left_margin_loss_flag = 1;
                                    end
                                end
                                %Ѱ�������ұ߽�
                                if right_border_flag == 0
                                    if((last_midline_coordinate(1) + j) < (70 + sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                            right_border_flag = 1;                                          %���Ѱ�������ұ߽�
                                            right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                            right_border_buf(2) = i;
                                        end
                                    else
                                        right_margin_loss_flag = 1;
                                    end
                                end                
                            else
                                %Ѱ��������߽�
                                if left_border_flag == 0
                                    if((last_midline_coordinate(1) - j) > (75 - sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                            left_border_flag = 1;                                           %���Ѱ��������߽�
                                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %����߽�x����
                                            left_border_buf(2) = i;                                         %����߽�y����
                                        end
                                    else
                                        left_margin_loss_flag = 1;
                                    end
                                end
                                %Ѱ�������ұ߽�
                                if right_border_flag == 0
                                    if((last_midline_coordinate(1) + j) < (65 + sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                            right_border_flag = 1;                                          %���Ѱ�������ұ߽�
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

                    if (left_border_flag && right_border_flag)                                  %���߶�Ѱ���߽�
                        if( last_midline_coordinate(1)-left_border_buf(1)<4)                    %�ж��Ƿ���ֵ�������
                             if( right_border_buf(1)-last_midline_coordinate(1)<4)               %�ж��Ƿ���ֵ������ߣ����߶��ҵ������ߣ�
                                midline_coordinate_array(111-i,1) = floor(0.5*(left_border_buf(1)+right_border_buf(1)));
                                midline_coordinate_array(111-i,2) = floor(0.5*(left_border_buf(2)+right_border_buf(2)));
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            else                                                                %�ж��Ƿ���ֵ������ߣ�����������ߣ�
                                midline_coordinate_array(111-i,1) = left_border_buf(1);
                                midline_coordinate_array(111-i,2) = left_border_buf(2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            end
                        else if( right_border_buf(1)-last_midline_coordinate(1)<4)              %�ж��Ƿ���ֵ������ߣ����������ұߣ�
                                midline_coordinate_array(111-i,1) = right_border_buf(1);
                                midline_coordinate_array(111-i,2) = right_border_buf(2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            else   %���߱ܿ��ϰ��⻬����----------------------------------------------------------------
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
                    else if( (left_border_flag==0) && (right_border_flag==0) )                  %���߶�δѰ���߽�
                            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                            midline_coordinate_array(111-i,2) = i;
                            left_border_buf(2) = i;
                            right_border_buf(2) = i;
                        else if( (left_border_flag==1) && (right_border_flag==0) )              %��߽�Ѱ�����ұ߽綪ʧ 
                                if( last_midline_coordinate(1)-left_border_buf(1)<4)            %�ж��Ƿ���ֵ�������
                                    midline_coordinate_array(111-i,1) = left_border_buf(1);
                                    midline_coordinate_array(111-i,2) = left_border_buf(2);
                                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if( left_border_buf(1) + track_width -( 70 + sizeofRow(i)) >= 5 )      %��Ұ��
                                        right_border_buf(1) = left_border_buf(1) + track_width;
                                        right_border_buf(2) = left_border_buf(2);
                                        midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)-5;
                                        midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if(left_border_buf(1) + track_width -( 70 + sizeofRow(i)) <= -5)   %��Ұ��     
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
                            else if( (left_border_flag==0) && (right_border_flag==1) )          %�ұ߽�Ѱ������߽綪ʧ
                                    if( right_border_buf(1)-last_midline_coordinate(1)<4)  %�ж��Ƿ���ֵ�������
                                            midline_coordinate_array(111-i,1) = right_border_buf(1);
                                            midline_coordinate_array(111-i,2) = right_border_buf(2);
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if( right_border_buf(1) - track_width -( 70 - sizeofRow(i)) <= -5 )    %��Ұ��
                                            left_border_buf(1) = right_border_buf(1)-track_width;
                                            left_border_buf(2) = right_border_buf(2);
                                            midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)+5;
                                            midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                        else if(right_border_buf(1) - track_width -( 70 - sizeofRow(i)) >= 5)   %��Ұ��
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
        special_coordinate(1) = midline_coordinate_array(110-i,1);                   %��¼������
        special_coordinate(2) = i;                  %��¼������
        
        %Ѱ���ϱ߽�
        for z = 111-special_coordinate(2) : 1 : 107
            i = 111 - z;
            %Ѱ��������(��)�߽�
            if upside_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i-1,special_coordinate(1))==0 )
                    upside_flag = 1;                                          %���Ѱ��������߽�
                    left_border_buf(1) = special_coordinate(1);               %����߽�x����
                    left_border_buf(2) = i;                                   %����߽�y����
                end
            else
                break;
            end
        end
        %Ѱ���±߽�
        for z = 111-special_coordinate(2) : -1 : 2
            i = 111 - z;
            %Ѱ��������(��)�߽�
            if below_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i+1,special_coordinate(1))==0 )
                    below_flag = 1;                                            %���Ѱ��������߽�
                    right_border_buf(1) = special_coordinate(1);               %���ұ߽�x����
                    right_border_buf(2) = i;                                   %���ұ߽�y����
                end
            else
                break;
            end
        end
        
        if (below_flag == 0)&&(upside_flag == 1)                           %û�ҵ��±߽�
            below_flag  = 1;
            right_border_buf(1) = special_coordinate(1);                    %����߽�x����
            right_border_buf(2) = 106;                                      %����߽�y����            
        end
        
        if ((upside_flag && below_flag) == 1) && (floor(0.5*(left_border_buf(2) + right_border_buf(2))) > special_coordinate(2)-3)
            midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2))),1) = special_coordinate(1)+3;
            midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2))),2) = floor(0.5*(left_border_buf(2) + right_border_buf(2)));
            
            for i = 1 : 1 : floor(0.5*(left_border_buf(2) + right_border_buf(2))) - special_coordinate(2)
                midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2)))+i,1) = 1;    %���
                midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2)))+i,2) = 1;    %���
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
            for i  = special_coordinate(2) : -1 : 45   %��ǰ��Ѱ�е�
                left_border_flag = 0;
                right_border_flag = 0;
                left_margin_loss_flag = 0;            
                right_margin_loss_flag = 0;
                for j = 1:1:sizeofRow(i)*2
                    if( (left_border_flag && right_border_flag)==0 && (left_border_flag && right_margin_loss_flag)==0 && (left_margin_loss_flag && right_border_flag)==0 && (left_margin_loss_flag && right_margin_loss_flag)==0 )
                        if z < 80
                            %Ѱ��������߽�
                            if left_border_flag == 0
                                if((last_midline_coordinate(1) - j) > (70 - sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                        left_border_flag = 1;                                           %���Ѱ��������߽�
                                        left_border_buf(1) = last_midline_coordinate(1) - j + 1;        %����߽�x����
                                        left_border_buf(2) = i;                                         %����߽�y����
                                    end
                                else
                                    left_margin_loss_flag = 1;
                                end
                            end
                            %Ѱ�������ұ߽�
                            if right_border_flag == 0
                                if((last_midline_coordinate(1) + j) < (70 + sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                        right_border_flag = 1;                                          %���Ѱ�������ұ߽�
                                        right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                        right_border_buf(2) = i;
                                    end
                                else
                                    right_margin_loss_flag = 1;
                                end
                            end                
                        else
                            %Ѱ��������߽�
                            if left_border_flag == 0
                                if((last_midline_coordinate(1) - j) > (75 - sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                        left_border_flag = 1;                                           %���Ѱ��������߽�
                                        left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %����߽�x����
                                        left_border_buf(2) = i;                                         %����߽�y����
                                    end
                                else
                                    left_margin_loss_flag = 1;
                                end
                            end
                            %Ѱ�������ұ߽�
                            if right_border_flag == 0
                                if((last_midline_coordinate(1) + j) < (65 + sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                        right_border_flag = 1;                                          %���Ѱ�������ұ߽�
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

                if (left_border_flag && right_border_flag)                                  %���߶�Ѱ���߽�
                    if( last_midline_coordinate(1)-left_border_buf(1)<4)                    %�ж��Ƿ���ֵ�������
                         if( right_border_buf(1)-last_midline_coordinate(1)<4)               %�ж��Ƿ���ֵ������ߣ����߶��ҵ������ߣ�
                            midline_coordinate_array(111-i,1) = floor(0.5*(left_border_buf(1)+right_border_buf(1)));
                            midline_coordinate_array(111-i,2) = floor(0.5*(left_border_buf(2)+right_border_buf(2)));
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        else                                                                %�ж��Ƿ���ֵ������ߣ�����������ߣ�
                            midline_coordinate_array(111-i,1) = left_border_buf(1);
                            midline_coordinate_array(111-i,2) = left_border_buf(2);
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        end
                    else if( right_border_buf(1)-last_midline_coordinate(1)<4)              %�ж��Ƿ���ֵ������ߣ����������ұߣ�
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
                else if( (left_border_flag==0) && (right_border_flag==0) )                  %���߶�δѰ���߽�
                        midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                        midline_coordinate_array(111-i,2) = i;
                        left_border_buf(2) = i;
                        right_border_buf(2) = i;
                    else if( (left_border_flag==1) && (right_border_flag==0) )              %��߽�Ѱ�����ұ߽綪ʧ 
                            if( last_midline_coordinate(1)-left_border_buf(1)<4)            %�ж��Ƿ���ֵ�������
                                midline_coordinate_array(111-i,1) = left_border_buf(1);
                                midline_coordinate_array(111-i,2) = left_border_buf(2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            else if( left_border_buf(1) + track_width -( 70 + sizeofRow(i)) >= 5 )      %��Ұ��
                                    right_border_buf(1) = left_border_buf(1) + track_width;
                                    right_border_buf(2) = left_border_buf(2);
                                    midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                    midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if(left_border_buf(1) + track_width -( 70 + sizeofRow(i)) <= -5)   %��Ұ��   
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
                        else if( (left_border_flag==0) && (right_border_flag==1) )          %�ұ߽�Ѱ������߽綪ʧ
                                if( right_border_buf(1)-last_midline_coordinate(1)<4)  %�ж��Ƿ���ֵ�������
                                        midline_coordinate_array(111-i,1) = right_border_buf(1);
                                        midline_coordinate_array(111-i,2) = right_border_buf(2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if( right_border_buf(1) - track_width -( 70 - sizeofRow(i)) <= -5 )    %��Ұ��
                                        left_border_buf(1) = right_border_buf(1)-track_width;
                                        left_border_buf(2) = right_border_buf(2);
                                        midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                        midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if(right_border_buf(1) - track_width -( 70 - sizeofRow(i)) >= 5)   %��Ұ��
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
            %Ѱ��������(��)�߽�
            if upside_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i-1,special_coordinate(1))==0 )
                    upside_flag = 1;                                          %���Ѱ��������߽�
                    left_border_buf(1) = special_coordinate(1);               %����߽�x����
                    left_border_buf(2) = i;                                   %����߽�y����
                end
            else
                break;
            end
        end
        
        if upside_flag                      %Ѱ�ҵ��߽�
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
        special_coordinate(1) = midline_coordinate_array(110-i,1); %��¼������
        special_coordinate(2) = i;                  %��¼������
        
        %Ѱ���ϱ߽�
        for z = 111-special_coordinate(2) : 1 : 107
            i = 111 - z;
            %Ѱ��������(��)�߽�
            if upside_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i-1,special_coordinate(1))==0 )
                    upside_flag = 1;                                          %���Ѱ��������߽�
                    right_border_buf(1) = special_coordinate(1);               %���ұ߽�x����
                    right_border_buf(2) = i;                                   %���ұ߽�y����
                end
            else
                break;
            end
        end
        %Ѱ���±߽�
        for z = 111-special_coordinate(2) : -1 : 2
            i = 111 - z;
            %Ѱ��������(��)�߽�
            if below_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i+1,special_coordinate(1))==0 )
                    below_flag = 1;                                            %���Ѱ��������߽�
                    left_border_buf(1) = special_coordinate(1);                %����߽�x����
                    left_border_buf(2) = i;                                    %����߽�y����
                end
            else
                break;
            end
        end
        
        if (below_flag == 0)&&(upside_flag == 1)                           %û�ҵ��±߽�
            below_flag  = 1;
            left_border_buf(1) = special_coordinate(1);                    %����߽�x����
            left_border_buf(2) = 106;                                      %����߽�y����            
        end
        
        if ((upside_flag && below_flag) == 1) && (floor(0.5*(left_border_buf(2) + right_border_buf(2))) > special_coordinate(2))
            midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2))),1) = special_coordinate(1)-3;
            midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2))),2) = floor(0.5*(left_border_buf(2) + right_border_buf(2)));
            
            for i = 1 : 1 : floor(0.5*(left_border_buf(2) + right_border_buf(2))) - special_coordinate(2)
                midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2)))+i,1) = 1;    %���
                midline_coordinate_array(110-floor(0.5*(left_border_buf(2) + right_border_buf(2)))+i,2) = 1;    %���
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
            for i  = special_coordinate(2) : -1 : 45   %��ǰ��Ѱ�е�
                left_border_flag = 0;
                right_border_flag = 0;
                left_margin_loss_flag = 0;            
                right_margin_loss_flag = 0;
                for j = 1:1:sizeofRow(i)*2
                    if( (left_border_flag && right_border_flag)==0 && (left_border_flag && right_margin_loss_flag)==0 && (left_margin_loss_flag && right_border_flag)==0 && (left_margin_loss_flag && right_margin_loss_flag)==0 )
                        if z < 80
                            %Ѱ��������߽�
                            if left_border_flag == 0
                                if((last_midline_coordinate(1) - j) > (70 - sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                        left_border_flag = 1;                                           %���Ѱ��������߽�
                                        left_border_buf(1) = last_midline_coordinate(1) - j + 1;        %����߽�x����
                                        left_border_buf(2) = i;                                         %����߽�y����
                                    end
                                else
                                    left_margin_loss_flag = 1;
                                end
                            end
                            %Ѱ�������ұ߽�
                            if right_border_flag == 0
                                if((last_midline_coordinate(1) + j) < (70 + sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                        right_border_flag = 1;                                          %���Ѱ�������ұ߽�
                                        right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                        right_border_buf(2) = i;
                                    end
                                else
                                    right_margin_loss_flag = 1;
                                end
                            end                
                        else
                            %Ѱ��������߽�
                            if left_border_flag == 0
                                if((last_midline_coordinate(1) - j) > (75 - sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                        left_border_flag = 1;                                           %���Ѱ��������߽�
                                        left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %����߽�x����
                                        left_border_buf(2) = i;                                         %����߽�y����
                                    end
                                else
                                    left_margin_loss_flag = 1;
                                end
                            end
                            %Ѱ�������ұ߽�
                            if right_border_flag == 0
                                if((last_midline_coordinate(1) + j) < (65 + sizeofRow(i)))
                                    if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                        right_border_flag = 1;                                          %���Ѱ�������ұ߽�
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

                if (left_border_flag && right_border_flag)                                  %���߶�Ѱ���߽�
                    if( last_midline_coordinate(1)-left_border_buf(1)<4)                    %�ж��Ƿ���ֵ�������
                         if( right_border_buf(1)-last_midline_coordinate(1)<4)               %�ж��Ƿ���ֵ������ߣ����߶��ҵ������ߣ�
                            midline_coordinate_array(111-i,1) = floor(0.5*(left_border_buf(1)+right_border_buf(1)));
                            midline_coordinate_array(111-i,2) = floor(0.5*(left_border_buf(2)+right_border_buf(2)));
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        else                                                                %�ж��Ƿ���ֵ������ߣ�����������ߣ�
                            midline_coordinate_array(111-i,1) = left_border_buf(1);
                            midline_coordinate_array(111-i,2) = left_border_buf(2);
                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                        end
                    else if( right_border_buf(1)-last_midline_coordinate(1)<4)              %�ж��Ƿ���ֵ������ߣ����������ұߣ�
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
                else if( (left_border_flag==0) && (right_border_flag==0) )                  %���߶�δѰ���߽�
                        midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                        midline_coordinate_array(111-i,2) = i;
                        left_border_buf(2) = i;
                        right_border_buf(2) = i;
                    else if( (left_border_flag==1) && (right_border_flag==0) )              %��߽�Ѱ�����ұ߽綪ʧ 
                            if( last_midline_coordinate(1)-left_border_buf(1)<4)            %�ж��Ƿ���ֵ�������
                                midline_coordinate_array(111-i,1) = left_border_buf(1);
                                midline_coordinate_array(111-i,2) = left_border_buf(2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            else if( left_border_buf(1) + track_width -( 70 + sizeofRow(i)) >= 5 )      %��Ұ��
                                    right_border_buf(1) = left_border_buf(1) + track_width;
                                    right_border_buf(2) = left_border_buf(2);
                                    midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                    midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if(left_border_buf(1) + track_width -( 70 + sizeofRow(i)) <= -5)   %��Ұ��     
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
                        else if( (left_border_flag==0) && (right_border_flag==1) )          %�ұ߽�Ѱ������߽綪ʧ
                                if( right_border_buf(1)-last_midline_coordinate(1)<4)  %�ж��Ƿ���ֵ�������
                                        midline_coordinate_array(111-i,1) = right_border_buf(1);
                                        midline_coordinate_array(111-i,2) = right_border_buf(2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if( right_border_buf(1) - track_width -( 70 - sizeofRow(i)) <= -5 )    %��Ұ��
                                        left_border_buf(1) = right_border_buf(1)-track_width;
                                        left_border_buf(2) = right_border_buf(2);
                                        midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2);
                                        midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if(right_border_buf(1) - track_width -( 70 - sizeofRow(i)) >= 5)   %��Ұ��
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
            %Ѱ��������(��)�߽�
            if upside_flag == 0
                if( photo(i,special_coordinate(1))==0 && photo(i-1,special_coordinate(1))==0 )
                    upside_flag = 1;                                           %���Ѱ��������߽�
                    right_border_buf(1) = special_coordinate(1);               %���ұ߽�x����
                    right_border_buf(2) = i;                                   %���ұ߽�y����
                end
            else
                break;
            end
        end
        
        if upside_flag                      %Ѱ�ҵ��߽�
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
        
        special_coordinate(1) = floor(0.5*(right_border_buf(1)+left_border_buf(1))); %��¼������
        special_coordinate(2) = i;                  %��¼������
        last_midline_coordinate(1) = special_coordinate(1);
        last_midline_coordinate(2) = special_coordinate(2);
        
        if special_coordinate(2)-15 > 30
            %�ж��Ƿ��ǳ�����ں��
            if((photo(special_coordinate(2)-15,special_coordinate(1)-2)==0)&&(photo(special_coordinate(2)-15,special_coordinate(1)-1)==0)) || ((photo(special_coordinate(2)-15,special_coordinate(1)+1)==0) && (photo(special_coordinate(2)-15,special_coordinate(1)+2)==0))      %�ж��Ƿ���ֺڸ�
                special_treatment = 6;                                      %���⴦�� 6��ֱ�Ǻ��ߣ�
            else  
                for i  = special_coordinate(2)-15 : -1 : 35   %��ǰ��Ѱ�е�

                    left_border_flag = 0;
                    right_border_flag = 0;
                    left_margin_loss_flag = 0;            
                    right_margin_loss_flag = 0;
                    for j = 1:1:sizeofRow(i)*2
                        if( (left_border_flag && right_border_flag)==0 && (left_border_flag && right_margin_loss_flag)==0 && (left_margin_loss_flag && right_border_flag)==0 && (left_margin_loss_flag && right_margin_loss_flag)==0 )
                            if z < 80
                                %Ѱ��������߽�
                                if left_border_flag == 0
                                    if((last_midline_coordinate(1) - j) > (70 - sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                            left_border_flag = 1;                                           %���Ѱ��������߽�
                                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;        %����߽�x����
                                            left_border_buf(2) = i;                                         %����߽�y����
                                        end
                                    else
                                        left_margin_loss_flag = 1;
                                    end
                                end
                                %Ѱ�������ұ߽�
                                if right_border_flag == 0
                                    if((last_midline_coordinate(1) + j) < (70 + sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                            right_border_flag = 1;                                          %���Ѱ�������ұ߽�
                                            right_border_buf(1) = last_midline_coordinate(1) + j - 1;
                                            right_border_buf(2) = i;
                                        end
                                    else
                                        right_margin_loss_flag = 1;
                                    end
                                end                
                            else
                                %Ѱ��������߽�
                                if left_border_flag == 0
                                    if((last_midline_coordinate(1) - j) > (75 - sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)-j)==0 && photo(i,last_midline_coordinate(1)-j-1)==0 )
                                            left_border_flag = 1;                                           %���Ѱ��������߽�
                                            left_border_buf(1) = last_midline_coordinate(1) - j + 1;            %����߽�x����
                                            left_border_buf(2) = i;                                         %����߽�y����
                                        end
                                    else
                                        left_margin_loss_flag = 1;
                                    end
                                end
                                %Ѱ�������ұ߽�
                                if right_border_flag == 0
                                    if((last_midline_coordinate(1) + j) < (65 + sizeofRow(i)))
                                        if( photo(i,last_midline_coordinate(1)+j)==0 && photo(i,last_midline_coordinate(1)+j+1)==0 )
                                            right_border_flag = 1;                                          %���Ѱ�������ұ߽�
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

                    if (left_border_flag && right_border_flag)                                  %���߶�Ѱ���߽�
                        if( last_midline_coordinate(1)-left_border_buf(1)<4)                    %�ж��Ƿ���ֵ�������
                             if( right_border_buf(1)-last_midline_coordinate(1)<4)               %�ж��Ƿ���ֵ������ߣ����߶��ҵ������ߣ�
                                midline_coordinate_array(111-i,1) = floor(0.5*(left_border_buf(1)+right_border_buf(1)));
                                midline_coordinate_array(111-i,2) = floor(0.5*(left_border_buf(2)+right_border_buf(2)));
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            else                                                                %�ж��Ƿ���ֵ������ߣ�����������ߣ�
                                midline_coordinate_array(111-i,1) = left_border_buf(1);
                                midline_coordinate_array(111-i,2) = left_border_buf(2);
                                last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                            end
                        else if( right_border_buf(1)-last_midline_coordinate(1)<4)              %�ж��Ƿ���ֵ������ߣ����������ұߣ�
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
                    else if( (left_border_flag==0) && (right_border_flag==0) )                  %���߶�δѰ���߽�
                            midline_coordinate_array(111-i,1) = last_midline_coordinate(1);
                            midline_coordinate_array(111-i,2) = i;
                            left_border_buf(2) = i;
                            right_border_buf(2) = i;
                        else if( (left_border_flag==1) && (right_border_flag==0) )              %��߽�Ѱ�����ұ߽綪ʧ 
                                if( last_midline_coordinate(1)-left_border_buf(1)<4)            %�ж��Ƿ���ֵ�������
                                    midline_coordinate_array(111-i,1) = left_border_buf(1);
                                    midline_coordinate_array(111-i,2) = left_border_buf(2);
                                    last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                    last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                else if( left_border_buf(1) + track_width -( 70 + sizeofRow(i)) >= 5 )      %��Ұ��
                                        right_border_buf(1) = left_border_buf(1) + track_width;
                                        right_border_buf(2) = left_border_buf(2);
                                        midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)-5;
                                        midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                        last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                        last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if(left_border_buf(1) + track_width -( 70 + sizeofRow(i)) <= -5)   %��Ұ��     
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
                            else if( (left_border_flag==0) && (right_border_flag==1) )          %�ұ߽�Ѱ������߽綪ʧ
                                    if( right_border_buf(1)-last_midline_coordinate(1)<4)  %�ж��Ƿ���ֵ�������
                                            midline_coordinate_array(111-i,1) = right_border_buf(1);
                                            midline_coordinate_array(111-i,2) = right_border_buf(2);
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                    else if( right_border_buf(1) - track_width -( 70 - sizeofRow(i)) <= -5 )    %��Ұ��
                                            left_border_buf(1) = right_border_buf(1)-track_width;
                                            left_border_buf(2) = right_border_buf(2);
                                            midline_coordinate_array(111-i,1) = floor((left_border_buf(1) + right_border_buf(1))/2)+5;
                                            midline_coordinate_array(111-i,2) = floor((left_border_buf(2) + right_border_buf(2))/2);
                                            last_midline_coordinate(1) = midline_coordinate_array(111-i,1);
                                            last_midline_coordinate(2) = midline_coordinate_array(111-i,2);
                                        else if(right_border_buf(1) - track_width -( 70 - sizeofRow(i)) >= 5)   %��Ұ��
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
                    for i = special_coordinate(2)-15 : 1 : 110    %����
                       midline_coordinate_array(111-i,1) = floor(0.7* midline_coordinate_array(111-i+1,1)+0.3* special_coordinate(1));
                       midline_coordinate_array(111-i,2) = i;
                    end
                else
                    for i = special_coordinate(2)-15 : 1 : special_coordinate(2)+5    %����
                       midline_coordinate_array(111-i,1) = floor(0.7* midline_coordinate_array(111-i+1,1)+0.3* midline_coordinate_array(111-special_coordinate(2)-5,1));
                       midline_coordinate_array(111-i,2) = i;
                    end
                end
                
            end
        end
        
    otherwise
        
end

%�е���
for i = 1 : 1 : 110
    if midline_coordinate_array(i,1) == 1   %�ж��е��Ƿ񳬹�10�� 
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

%ȷ���������ߵĳ���
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

