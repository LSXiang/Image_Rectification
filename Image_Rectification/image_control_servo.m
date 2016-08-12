left_difference = 0;
left_difference_location = 1; 
right_difference = 0;
right_difference_location = 1;
difference_flag = 0;
k = 0;

if((special_treatment ~= 7) && (last_mid_point_num > 10))
    if special_treatment == 0
        if(last_mid_point_num > 60)
            for i = 1 : 1 : 60
                difference = midline_coordinate_array(i)-midline_coordinate_array(1);
                if((difference_flag == 0) && ((difference <= 5) || (difference >= -5)))
                    if((difference > 0) && (difference >= right_difference))
                        right_difference = difference;
                        right_difference_location = i;
                    else if((difference < 0) && (difference <= left_difference))
                            left_difference = difference;
                            left_difference_location = i;
                        end
                    end
                else
                    difference_flag = 1;
                    if((difference > 0) && (difference >= right_difference))
                        right_difference = difference;
                        right_difference_location = i;
                    else
                        break;
                    end
                    if((difference < 0) && (difference <= left_difference))
                        left_difference = difference;
                        left_difference_location = i;
                    else
                        break;
                    end
                end
            end
            k = right_difference/right_difference_location + left_difference/left_difference_location;
        else
            k = ((((midline_coordinate_array(last_mid_point_num)+midline_coordinate_array(last_mid_point_num-1))/2)-((midline_coordinate_array(1)+midline_coordinate_array(2))/2)) / (last_mid_point_num-2)  );
        end
    else if(special_treatment == 1)
            
        else if((special_treatment == 2) || (special_treatment == 4))
                if(last_mid_point_num < 35)
                     k = ((((midline_coordinate_array(last_mid_point_num)+midline_coordinate_array(last_mid_point_num-1))/2)-((midline_coordinate_array(1)+midline_coordinate_array(2))/2)) / (last_mid_point_num-2)  );
                else
                    for i = 2 : 1 : last_mid_point_num-5
                        difference = midline_coordinate_array(i)-midline_coordinate_array(1);
                        if((difference_flag == 0) && ((difference <= 5) || (difference >= -5)))
                            if((difference > 0) && (difference >= right_difference))
                                right_difference = difference;
                                right_difference_location = i;
                            else if((difference < 0) && (difference <= left_difference))
                                    left_difference = difference;
                                    left_difference_location = i;
                                end
                            end
                        else
                            difference_flag = 1;
                            if((difference > 0) && (difference >= right_difference))
                                right_difference = difference;
                                right_difference_location = i;
                            else
                                break;
                            end
                            if((difference < 0) && (difference <= left_difference))
                                left_difference = difference;
                                left_difference_location = i;
                            else
                                break;
                            end
                        end
                    end
                    k = right_difference/right_difference_location + left_difference/left_difference_location;
                end
            else if((special_treatment == 3) || (special_treatment == 5))
                    if(last_mid_point_num < 40)  
                        k = ((((midline_coordinate_array(last_mid_point_num)+midline_coordinate_array(last_mid_point_num-1))/2)-((midline_coordinate_array(1)+midline_coordinate_array(2))/2)) / (last_mid_point_num-2)  );
                    else
                        for i = 2 : 1 : last_mid_point_num-5
                            difference = midline_coordinate_array(i)-midline_coordinate_array(1);
                            if((difference_flag == 0) && ((difference <= 5) || (difference >= -5)))
                                if((difference > 0) && (difference >= right_difference))
                                    right_difference = difference;
                                    right_difference_location = i;
                                else if((difference < 0) && (difference <= left_difference))
                                        left_difference = difference;
                                        left_difference_location = i;
                                    end
                                end
                            else
                                difference_flag = 1;
                                if((difference > 0) && (difference >= right_difference))
                                    right_difference = difference;
                                    right_difference_location = i;
                                else
                                    break;
                                end
                                if((difference < 0) && (difference <= left_difference))
                                    left_difference = difference;
                                    left_difference_location = i;
                                else
                                    break;
                                end
                            end
                        end
                        k = right_difference/right_difference_location + left_difference/left_difference_location;
                    end
                else if(special_treatment == 6)  
                    else
                        
                    end
                end
            end
        end
    end
end










