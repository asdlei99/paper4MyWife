function paperFigureSet_small(h)
% 单幅图片尺寸统一设置，普通全幅
    if 0 == nargin
        h = 6;
    end
    set(gcf,'color','w');
    set(gcf,'unit','centimeter','position',[8,4,7,h]);
end