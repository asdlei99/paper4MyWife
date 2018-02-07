function h = figureSimFrequencyResponse(filePath,y,varargin)
%绘制直管模拟频率响应
	pp = varargin;
	varargin = {};
	fs = 200;
	type = 'contourf';%contourf
	while length(pp)>=2
		prop =pp{1};
		val=pp{2};
		pp=pp(3:end);
		switch lower(prop)
			case 'fs' %绘图类型可选'line'和'bar'
				fs = val;
			case 'type'
				type = val;
			otherwise
				varargin{length(varargin)+1} = prop;
				varargin{length(varargin)+1} = val;
		end
	end
    dataStructCell = loadSimDataStructCellFromFolderPath(filePath);
    pressures = dataStructCell.rawData.pressure;
	if isempty(y)
        y = 1:size(pressures,2);
    end
	figHandle = figure;
	paperFigureSet('small',6);
	h = plotWaveWaterFall(pressures,fs,'y',y,'type',type);
	xlabel('频率(Hz)','fontSize',paperFontSize());
	ylabel('管线距离(m)','fontSize',paperFontSize());
end
