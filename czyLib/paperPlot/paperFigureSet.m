% 单幅图片尺寸统一设置，大全幅
function paperFigureSet(wType,h)
    if 0 == nargin
        wType = 'normal';
        h = 6;
    elseif 1 == nargin
        h = 6;
    end
    switch lower(wType)
    case 'moresmall'
        set(gcf,'color','w');
        set(gcf,'unit','centimeter','position',[8,4,6,h]);
    case 'small'
        paperFigureSet_small(h);
    case 'normal'
        paperFigureSet_normal(h);
    case 'large'
        paperFigureSet_large(h);
    case 'full'
        paperFigureSet_FullWidth(h);
    case 'fullwidth'
        paperFigureSet_FullWidth(h);
    case 'normal2'
        set(gcf,'color','w');
        set(gcf,'unit','centimeter','position',[8,4,10,h]);
    otherwise%other时wtype应该为数字
        set(gcf,'color','w');
        set(gcf,'unit','centimeter','position',[8,4,wType,h]);
    end

end