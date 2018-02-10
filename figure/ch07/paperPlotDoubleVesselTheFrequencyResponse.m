function res = paperPlotDoubleVesselTheFrequencyResponse(param,isSaveFig)
%���ƿ׹�Ƶ����Ӧ
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
	xlabel('Ƶ��(Hz)','fontSize',paperFontSize());
	ylabel('���߾���(m)','fontSize',paperFontSize());
	if strcmpi(type,'contourf')
		colormap jet;
	end
end
