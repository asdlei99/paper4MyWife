function d = paperPlotPerforateSpectrum3D(perforatePipeCombineDataCells,legendLabels,isSaveFigure)
%绘制内置孔管的3d频谱
%% 分析参数设置
%时频分析参数设置
	if nargin < 3
		isSaveFigure = 0;
	end
	Fs = 100;%实验采样率
	for i=1:length(perforatePipeCombineDataCells)
		dataCell = perforatePipeCombineDataCells{i};
		titleName = legendLabels{i};
		fh = figure('Name',titleName);
		paperFigureSet('small',6);
		figureSpectrum3D(dataCell);
		zlim([0,8]);
		set(gca,'ZTick',0:2:8);
		set(gca,'XTick',0:10:50);
		view(32,44);
		box on;
		grid on;
		if isSaveFigure
			set(gcf,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch06'),sprintf('内置孔管-实验数据频率分布-%s',legendLabels{i}));
			close(fh);
		end
	end
end