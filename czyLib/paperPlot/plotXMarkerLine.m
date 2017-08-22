function handle = plotXMarkerLine( xval,varargin )
%绘制对应x值得直线
%   绘制一个等x值(竖直线)
ax = axis();
handle = plot([xval,xval],[ax(3),ax(4)],varargin{:});

end

