function paperFigureSet_normal(h)
% ����ͼƬ�ߴ�ͳһ���ã���ͨ���
    if 0 == nargin
        h = 8;
    end
    set(gcf,'color','w');
    set(gcf,'unit','centimeter','position',[8,4,12,h]);
end
