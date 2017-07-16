function [curHandle,fillHandle] = plotWithError( x,y,up,down,varargin )
%绘制带误差范围的图线
% By:尘中远
%   fre 频率
%   mag 幅值
%   varargin 其它属性设置：
% type 误差带的绘制方式，默认为'area',以区域图形式绘制，若为'errbar',就使用matlab默认函数errorbar
% colorFace 在type='area'时使用，设定填充区域的颜色
% EdgeColor 在type='area'时使用，区域边线的颜色
% FaceAlpha 在type='area'时使用，区域透明度
% EdgeAlpha 在type='area'时使用，区域边线透明度
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
        case 'type' %是否允许补0
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



