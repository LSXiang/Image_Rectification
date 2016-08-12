function [ Ans ] = m_sqrt( x )
%   M_SQRT 简单的求根函数
%   输入为一个无符号16进制数
%   输出为一个无符号8进制数
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

