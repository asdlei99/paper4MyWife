function res = paperPlot04StraightPipeTheoryFrequencyResponse(param,isSaveFig)
%绘制直管频率响应
	fs = 400;
	type = 'contourf';
	pressures = straightPipeFrequencyResponse('param',param,'fs',fs);
	
	figHandle = figure;
	paperFigureSet('small',6);
	plotWaveWaterFall(pressures,fs,'y',param.sectionL,'type',type);
	xlim([0,100]);
	xlabel('频率(Hz)','fontSize',paperFontSize());
	ylabel('管线距离(m)','fontSize',paperFontSize());
	if strcmpi(type,'contourf')
		colormap jet;
	end
end
