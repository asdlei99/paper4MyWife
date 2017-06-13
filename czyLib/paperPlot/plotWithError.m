function [curHandle,fillHandle] = plotWithError( x,y,up,down,varargin )
%���ƴ���Χ��ͼ��
% By:����Զ
%   fre Ƶ��
%   mag ��ֵ
%   varargin �����������ã�
% color ������ɫ
% isFill �Ƿ����
% isMarkPeak �Ƿ��Ƿ�ֵ
% markCount ��ǵķ�ֵ����
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



