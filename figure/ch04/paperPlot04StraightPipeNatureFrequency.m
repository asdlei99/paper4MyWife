﻿function res = paperPlot04StraightPipeNatureFrequency(straightPipeCombineData,isSavePlot)
%?���3��?
	fh = figureExpNatureFrequencyBar(straightPipeCombineData,1,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'��η-1��??��');
		close(fh.figure);
	end
	res.fig1 = fh;
	
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,2,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'��η-2��??��');
		close(fh.figure);
	end
	res.fig2 = fh;
	
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,3,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'��η-3��??��');
		close(fh.figure);
	end
	res.fig3 = fh;
end