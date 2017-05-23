function [outPut,x,xmin,xmax] = plotWave( wave,fs,varargin )
%绘制频谱图，频谱图会填充区域
% By:尘中远
%   fre 频率
%   mag 幅值
%   varargin 其它属性设置：
% color 线条颜色
% isFill 是否填充
% isMarkPeak 是否标记峰值
% markCount 标记的峰值个数
pp=varargin;
figureHandle = nan;
showFigure = 1;
lineColor = 'b';

while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch prop
        case 'color'
            lineColor=val;
        case 'figureHandle'
            figureHandle = val;
        case 'showFigure'
            showFigure = val;
        otherwise
            error('参数输入错误！')
    end
end

if ~ishandle(figureHandle)
    if showFigure
       figureHandle = figure;
    else
       figureHandle = figure('visible','off');
    end
end


outPut.figure = figureHandle;

x = 0:length(wave)-1;
x = x * (1/fs);
xmin = x(1);
xmax = x(end);
outPut.waveH = plot(x,wave,'-','color',lineColor);
hold on;
grid on;

set(gcf,'color','w');
%ylim(axisData(3:4));
end



