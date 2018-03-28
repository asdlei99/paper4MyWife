function res = paperPlotInnerPipeTheoryFrequencyResponse(param,isSaveFig)
%绘制孔管频率响应
	fs = 400;
	type = 'contourf';
	pressures = innerPipeFrequencyResponse('param',param,'fs',fs);
	X =  [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2]; 
	figHandle = figure;
	paperFigureSet('small',6);
	plotWaveWaterFall(pressures,fs,'y',X,'type',type);
    zlim([0,5000]);
	xlim([0,100]);
	xlabel('频率(Hz)','fontSize',paperFontSize());
	ylabel('管线距离(m)','fontSize',paperFontSize());
	if strcmpi(type,'contourf')
		colormap jet;
	end
end
