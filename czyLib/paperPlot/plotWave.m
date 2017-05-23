function [outPut,x,xmin,xmax] = plotWave( wave,fs,varargin )
%����Ƶ��ͼ��Ƶ��ͼ���������
% By:����Զ
%   fre Ƶ��
%   mag ��ֵ
%   varargin �����������ã�
% color ������ɫ
% isFill �Ƿ����
% isMarkPeak �Ƿ��Ƿ�ֵ
% markCount ��ǵķ�ֵ����
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
            error('�����������')
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



