function layout = makePlotAxesLayout( plotAxesHandle )
%����һ��͸����ͼ�㣬ͼ���С�ͻ�ͼ��Сһ��
%   �˴���ʾ��ϸ˵��
if 0 == nargin 
    plotAxesHandle = gca;
end
layout = axes('position',get(plotAxesHandle,'position'),...
			'visible','off');
end

