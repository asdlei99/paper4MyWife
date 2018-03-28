function newY = orificePressureDropFixYFunHandle( oldY )
%修正压力降值的函数指针
%   此处显示详细说明
    oldY(2) = oldY(2) + 0.3;
    oldY(3) = oldY(3) + 0.6;
    oldY(4) = oldY(4) + 1;
    newY = oldY;
end

