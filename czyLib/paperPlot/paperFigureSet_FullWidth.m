% ����ͼƬ�ߴ�ͳһ���ã���ȫ��
function paperFigureSet_FullWidth(h)
    if 0 == nargin
        h = 8;
    end
    set(gcf,'color','w');
    set(gcf,'unit','centimeter','position',[8,4,14.5,h]);
end