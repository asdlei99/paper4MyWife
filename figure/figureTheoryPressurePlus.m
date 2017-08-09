function fh = figureTheoryPressurePlus(dataCells,X,varargin)
%绘制实实验的压力脉动
% 
pp = varargin;
legendLabels = {};
yLabelText = '';
Y = nan;%如果Y赋值，将会以3d形式绘制
%允许特殊的把地一个varargin作为legend
chartType = 'plot3';
if 0 ~= mod(length(pp),2)
    legendLabels = pp{1};
    pp=pp(2:end);
end
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'y'
            Y = val;
        case 'charttype'
            chartType = val;
        case 'ylabeltext'
            yLabelText = val;
        otherwise
       		error('参数错误%s',prop);
    end
end

figure
paperFigureSet_normal();
if isnan(Y)
    for plotCount = 1:length(dataCells)
        if 2 == plotCount
            hold on;
        end
        if(1 == length(dataCells))
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
else
    if strcmp(chartType,'plot3')
        hold on;
        for i = 1:length(dataCells)
            z = dataCells{i}.pulsationValue;
            z = z ./ 1000;
            if size(X,1) > 1
                x = X{i,:};
            else
                x = X;
            end
            fh.plotHandle(i) = plot3(x,Y(i).*ones(lenght(x),1),z);
        end
        xlabel('管线距离(m)','FontName',paperFontName(),'FontSize',paperFontSize());
        ylabel(yLabelText,'FontName',paperFontName(),'FontSize',paperFontSize());
        zlabel('脉动峰峰值(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
    elseif
        
    end

    
        
    
end

end



