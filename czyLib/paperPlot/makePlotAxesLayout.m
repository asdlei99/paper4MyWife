function layout = makePlotAxesLayout( plotAxesHandle )
%创建一个透明的图层，图层大小和绘图大小一样
%   此处显示详细说明
if 0 == nargin 
    plotAxesHandle = gca;
end
layout = axes('position',get(plotAxesHandle,'position'),...
			'visible','off');
end

