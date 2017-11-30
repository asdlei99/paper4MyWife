function fh = plotDataStructCells( dataStructCells,varargin )
%绘制dataStructCells的内容
    for i = 1:length(dataStructCells)
        if 2 == i
            hold on;
        end
        if(1 == length(dataStructCells))
            y = dataCells.pulsationValue;
        else
            y = dataCells{plotCount}.pulsationValue;
        end
        y = y./1000;
        if size(X,1) > 1
            x = X{plotCount,:};
        else
            x = X;
        end
        if isnan(y)
            error('没有获取到数据');
        end

        [fh.plotHandle(plotCount)] = plot(x,y,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    end
    if ~isempty(legendLabels)
        fh.legend = legend(fh.plotHandle,legendLabels,0);
    end

    xlabel('管线距离(m)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel('脉动峰峰值(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
end

