function paperFigureSet_normal(h)
% ����ͼƬ�ߴ�ͳһ���ã���ͨ���
    if 0 == nargin
        h = 6;
    end
    set(gcf,'color','w');
    set(gca,'FontName',paperFontName(),'FontSize',paperFontSize());
    set(gcf,'unit','centimeter','position',[8,4,9,h]);
end
