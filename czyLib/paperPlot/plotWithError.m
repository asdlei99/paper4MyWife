function [curHandle,fillHandle] = plotWithError( x,y,up,down,varargin )
%���ƴ���Χ��ͼ��
% By:����Զ
%   fre Ƶ��
%   mag ��ֵ
%   varargin �����������ã�
% type �����Ļ��Ʒ�ʽ��Ĭ��Ϊ'area',������ͼ��ʽ���ƣ���Ϊ'errbar',��ʹ��matlabĬ�Ϻ���errorbar
% colorFace ��type='area'ʱʹ�ã��趨����������ɫ
% EdgeColor ��type='area'ʱʹ�ã�������ߵ���ɫ
% FaceAlpha ��type='area'ʱʹ�ã�����͸����
% EdgeAlpha ��type='area'ʱʹ�ã��������͸����
%
colorFace = [185,188,188]./255;
EdgeColor = colorFace;
FaceAlpha = 0.5;
EdgeAlpha = 0;
type = 'area';
fillHandle = nan;
while length(varargin)>=2
    prop =varargin{1};
    val=varargin{2};
    varargin=varargin(3:end);
    switch lower(prop)
        case 'type' %�Ƿ�����0
            type = val;
        case 'colorface'
            colorFace = val;
        case 'edgecolor'
            EdgeColor = val;
        case 'facealpha'
            FaceAlpha = val;
        case 'edgealpha'
            EdgeAlpha = val;
    end
end
if strcmp(type,'area')
    xFill = [x,fliplr(x)];
    yFill = [up,fliplr(down)];
    fillHandle = fill(xFill,yFill,colorFace);
    set(fillHandle,'FaceAlpha',FaceAlpha);
    set(fillHandle,'EdgeColor',EdgeColor);
    set(fillHandle,'EdgeAlpha',EdgeAlpha);
    hold on;
    curHandle = plot(x,y,varargin{:});
else
    curHandle = errorbar(x,y,y-down,up-y,varargin{:});
end

end



