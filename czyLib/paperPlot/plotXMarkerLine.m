function handle = plotXMarkerLine( xval,varargin )
%���ƶ�Ӧxֵ��ֱ��
%   ����һ����xֵ(��ֱ��)
ax = axis();
handle = plot([xval,xval],[ax(3),ax(4)],varargin{:});

end

