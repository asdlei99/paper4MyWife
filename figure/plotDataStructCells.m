function fh = plotDataStructCells( dataStructCells,varargin )
%����dataStructCells������
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
            error('û�л�ȡ������');
        end

        [fh.plotHandle(plotCount)] = plot(x,y,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    end
    if ~isempty(legendLabels)
        fh.legend = legend(fh.plotHandle,legendLabels,0);
    end

    xlabel('���߾���(m)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel('�������ֵ(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
end

