function paperFigureSet_small(h)
% ����ͼƬ�ߴ�ͳһ���ã���ͨȫ��
    if 0 == nargin
        h = 6;
    end
    set(gcf,'color','w');
    set(gcf,'unit','centimeter','position',[8,4,7,h]);
end