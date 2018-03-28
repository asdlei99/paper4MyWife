% ����ͼƬ�ߴ�ͳһ���ã���ȫ��
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
    otherwise%otherʱwtypeӦ��Ϊ����
        set(gcf,'color','w');
        set(gcf,'unit','centimeter','position',[8,4,wType,h]);
    end

end