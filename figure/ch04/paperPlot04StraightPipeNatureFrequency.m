function res = paperPlot04StraightPipeNatureFrequency(straightPipeCombineData,isSavePlot)
%绘制倍频
    figure;
    paperFigureSet('large',6);
	fh = figureExpNatureFrequencyBar2(straightPipeCombineData,1:3,{'1倍特征频率','2倍特征频率','3倍特征频率'});
    set(fh.legend,'Position',[0.142983160407072 0.621898741198966 0.262729119805357 0.254038172452636]);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutPutPath(),'ch04'),'直管1-2倍特征频率对比');
		close(fh.figure);
    end
end