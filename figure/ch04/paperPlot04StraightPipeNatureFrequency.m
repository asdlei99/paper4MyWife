function paperPlot04StraightPipeNatureFrequency(straightPipeCombineData,isSavePlot)
%?���η??��1��?��2��?��3��??��
	fh = figureExpNatureFrequencyBar(straightPipeCombineData,1,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'��η??1��?���');
	end
	
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,2,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'��η??2��?���');
	end
	
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,3,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'��η??3��?���');
	end
end