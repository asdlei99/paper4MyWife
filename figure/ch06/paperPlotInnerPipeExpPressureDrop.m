function  paperPlotInnerPipeExpPressureDrop( innerPipeDataCells,legendLabels,isSaveFigure )
    figure
    paperFigureSet('small',5);
    fh = figureExpPressureDrop(innerPipeDataCells,legendLabels,[2,3]...
        ,'chartType','bar'...
        ,'isFigure',false...
        );
    %'chartType'== 'bar' 时用于设置bar的颜色
    set(fh.barHandle,'FaceColor',getPlotColor(2));
    set(gca,'color','none');
    box on;
    if isSaveFigure
		saveFigure(fullfile(getPlotOutputPath(),'ch06'),'内插管-实验压力降');
	end
end

