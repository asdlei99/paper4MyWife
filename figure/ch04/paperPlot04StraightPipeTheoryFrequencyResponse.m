function res = paperPlot04StraightPipeTheoryFrequencyResponse(param,isSaveFig)
%����ֱ��Ƶ����Ӧ
	fs = 400;
	type = 'contourf';
	pressures = straightPipeFrequencyResponse('param',param,'fs',fs);
	
	figHandle = figure;
	paperFigureSet('small',6);
	plotWaveWaterFall(pressures,fs,'y',param.sectionL,'type',type);
	xlim([0,100]);
	xlabel('Ƶ��(Hz)','fontSize',paperFontSize());
	ylabel('���߾���(m)','fontSize',paperFontSize());
	if strcmpi(type,'contourf')
		colormap jet;
	end
end
