
for i = 0 : 1 : 110*140-1 
    if ddd(i+1,1)<0
        ddd(i+1,1)=0;
    end
    if ddd(i+1,2)<0
        ddd(i+1,2)=0;
    end
    if ddd(i+1,1)>139
        ddd(i+1,1)=139;
    end
    if ddd(i+1,2)>109
        ddd(i+1,2)=109;
    end
    if ddd(i+1,2) == 75
       if ddd(i+1,1)==38
           ddd(i+1,2) = 74;
       end
       if ddd(i+1,1)==39
           ddd(i+1,2) = 74;
       end
       if ddd(i+1,1)==40
           ddd(i+1,2) = 74;
       end
       if ddd(i+1,1)==41
           ddd(i+1,2) = 74;
       end
    end
end