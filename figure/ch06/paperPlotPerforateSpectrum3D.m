function d = paperPlotPerforateSpectrum3D(perforatePipeCombineDataCells,legendLabels,isSaveFigure)
%�������ÿ׹ܵ�3dƵ��
%% ������������
%ʱƵ������������
	if nargin < 3
		isSaveFigure = 0;
	end
	Fs = 100;%ʵ�������
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
			saveFigure(fullfile(getPlotOutputPath(),'ch06'),sprintf('���ÿ׹�-ʵ������Ƶ�ʷֲ�-%s',legendLabels{i}));
			close(fh);
		end
	end
end