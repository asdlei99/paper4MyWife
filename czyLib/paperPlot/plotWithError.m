function [curHandle,fillHandle] = plotWithError( x,y,up,down,varargin )
%绘制带误差范围的图线
% By:尘中远
%   fre 频率
%   mag 幅值
%   varargin 其它属性设置：
% color 线条颜色
% isFill 是否填充
% isMarkPeak 是否标记峰值
% markCount 标记的峰值个数
colorFace = [185,188,188]./255;
xFill = [x,fliplr(x)];
yFill = [up,fliplr(down)];
fillHandle = fill(xFill,yFill,colorFace);
set(fillHandle,'FaceAlpha',0.5);
set(fillHandle,'EdgeColor',colorFace);
set(fillHandle,'EdgeAlpha',0);

hold on;

curHandle = plot(x,y,varargin{:});

end



