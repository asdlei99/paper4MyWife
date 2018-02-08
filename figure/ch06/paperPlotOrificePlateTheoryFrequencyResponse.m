function res = paperPlotOrificePlateTheoryFrequencyResponse(param,isSaveFig)
%���ƿ׹�Ƶ����Ӧ
	fs = 400;
	type = 'contourf';
	pressures = innerOrificTankFrequencyResponse('param',param,'fs',fs);
	X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2]; 
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
