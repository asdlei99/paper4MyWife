function layout = makePlotAxesLayout( plotAxesHandle )
%����һ��͸����ͼ�㣬ͼ���С�ͻ�ͼ��Сһ��
%   �˴���ʾ��ϸ˵��
layout = axes('position',get(plotAxesHandle,'position'),...
			'visible','off');
end

