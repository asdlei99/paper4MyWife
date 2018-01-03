function res = paperPlot04StraightPipeNatureFrequency(straightPipeCombineData,legendLabels,isSavePlot)
%���Ʊ�Ƶ
	fh = figureExpNatureFrequencyBar(straightPipeCombineData,1,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'ֱ��1��Ƶ�Ա�');
		close(fh.figure);
	end
	res.fig1 = fh;
	
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,2,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'ֱ��2��Ƶ�Ա�');
		close(fh.figure);
	end
	res.fig2 = fh;
	
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,3,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'ֱ��3��Ƶ�Ա�');
		close(fh.figure);
	end
	res.fig3 = fh;
end