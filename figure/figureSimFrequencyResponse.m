function h = figureSimFrequencyResponse(filePath,y,varargin)
%����ֱ��ģ��Ƶ����Ӧ
	pp = varargin;
	varargin = {};
	fs = 200;
	type = 'contourf';%contourf
	while length(pp)>=2
		prop =pp{1};
		val=pp{2};
		pp=pp(3:end);
		switch lower(prop)
			case 'fs' %��ͼ���Ϳ�ѡ'line'��'bar'
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
	xlabel('Ƶ��(Hz)','fontSize',paperFontSize());
	ylabel('���߾���(m)','fontSize',paperFontSize());
end
