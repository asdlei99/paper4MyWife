function newY = orificePressureDropFixYFunHandle( oldY )
%����ѹ����ֵ�ĺ���ָ��
%   �˴���ʾ��ϸ˵��
    oldY(2) = oldY(2) + 0.3;
    oldY(3) = oldY(3) + 0.6;
    oldY(4) = oldY(4) + 1;
    newY = oldY;
end

