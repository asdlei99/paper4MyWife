function res = paperPlotDoubleVesselTheFrequencyResponse(param,isSaveFig)
%绘制孔管频率响应
	fs = 400;
	type = 'contourf';
	pressures = doubleVesselFrequencyResponse('param',param,'fs',fs);
	X = [param.sectionL1...
		,param.L1+param.LV1+2*param.l+param.sectionL2...
		,param.L1+param.LV1+2*param.l+param.L2+param.LV2+2*param.l+param.sectionL3];
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
