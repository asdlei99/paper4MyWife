function paperPlot04StraightPipeNatureFrequency(straightPipeCombineData,isSavePlot)
%?§Ú¡Œ∑??Ó‹1€√?£¨2€√?£¨3€√??›Ô
	fh = figureExpNatureFrequencyBar(straightPipeCombineData,1,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'Ú¡Œ∑??1€√?›¬‡∞');
	end
	
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,2,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'Ú¡Œ∑??2€√?›¬‡∞');
	end
	
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,3,legendLabels);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'Ú¡Œ∑??3€√?›¬‡∞');
	end
end