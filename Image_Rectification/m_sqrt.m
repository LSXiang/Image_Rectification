function [ Ans ] = m_sqrt( x )
%   M_SQRT �򵥵��������
%   ����Ϊһ���޷���16������
%   ���Ϊһ���޷���8������
    Ans = 0;
    p = 128;
    
    while(p ~= 0)
        Ans = Ans + p;
        if( Ans * Ans > x)
            Ans = Ans - p;
        end
        p = uint8(p/2);
    end

end

