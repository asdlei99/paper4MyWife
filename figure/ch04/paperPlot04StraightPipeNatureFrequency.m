function res = paperPlot04StraightPipeNatureFrequency(straightPipeCombineData,isSavePlot)
%���Ʊ�Ƶ
    figure;
    paperFigureSet('large',6);
	fh = figureExpNatureFrequencyBar2(straightPipeCombineData,1:3,{'1������Ƶ��','2������Ƶ��','3������Ƶ��'});
    set(fh.legend,'Position',[0.142983160407072 0.621898741198966 0.262729119805357 0.254038172452636]);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutPutPath(),'ch04'),'ֱ��1-2������Ƶ�ʶԱ�');
		close(fh.figure);
    end
end