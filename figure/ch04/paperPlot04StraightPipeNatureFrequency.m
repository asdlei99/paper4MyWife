function res = paperPlot04StraightPipeNatureFrequency(straightPipeCombineData,legendLabels,isSavePlot)
%绘制倍频
	fh = figureExpNatureFrequencyBar(straightPipeCombineData,1,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'直管1倍频对比');
		close(fh.figure);
	end
	res.fig1 = fh;
	
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,2,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'直管2倍频对比');
		close(fh.figure);
	end
	res.fig2 = fh;
	
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,3,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'直管3倍频对比');
		close(fh.figure);
	end
	res.fig3 = fh;
end