function paperFigureSet_normal(h)
% 单幅图片尺寸统一设置，普通半幅
    if 0 == nargin
        h = 6;
    end
    set(gcf,'color','w');
    set(gca,'FontName',paperFontName(),'FontSize',paperFontSize());
    set(gcf,'unit','centimeter','position',[8,4,9,h]);
end
