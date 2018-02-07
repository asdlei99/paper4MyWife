function res = paperPlotSingleVesselTheoryFrequencyResponse(param,vType,isSaveFig)
%����ֱ��Ƶ����Ӧ
	fs = 400;
	type = 'contourf';
	pressures = oneVesselFrequencyResponse('param',param,'fs',fs,'vType',vType);
	X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];  
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
