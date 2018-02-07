function res = paperPlotSingleVesselTheoryFrequencyResponse(param,vType,isSaveFig)
%绘制直管频率响应
	fs = 400;
	type = 'contourf';
	pressures = oneVesselFrequencyResponse('param',param,'fs',fs,'vType',vType);
	X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];  
	figHandle = figure;
	paperFigureSet('small',6);
	plotWaveWaterFall(pressures,fs,'y',X,'type',type);
	xlim([0,100]);
	xlabel('频率(Hz)','fontSize',paperFontSize());
	ylabel('管线距离(m)','fontSize',paperFontSize());
	if strcmpi(type,'contourf')
		colormap jet;
	end
end
