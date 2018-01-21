function  paperPlotInnerPipeExpPressureDrop( innerPipeDataCells,legendLabels,isSaveFigure )
    figure
    paperFigureSet('small',5);
    fh = figureExpPressureDrop(innerPipeDataCells,legendLabels,[2,3]...
        ,'chartType','bar'...
        ,'isFigure',false...
        );
    %'chartType'== 'bar' ʱ��������bar����ɫ
    set(fh.barHandle,'FaceColor',getPlotColor(2));
    set(gca,'color','none');
    box on;
    if isSaveFigure
		saveFigure(fullfile(getPlotOutputPath(),'ch06'),'�ڲ��-ʵ��ѹ����');
	end
end

