function fh = figureTheoryPressurePlus(dataCells,X,varargin)
%绘制实实验的压力脉动
% 
pp = varargin;
legendLabels = {};
%允许特殊的把地一个varargin作为legend
if 0 ~= mod(length(pp),2)
    legendLabels = pp{1};
    pp=pp(2:end);
end
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        otherwise
       		error('参数错误%s',prop);
    end
end

figure
paperFigureSet_normal();

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

xlabel('管线距离(m)');
ylabel('脉动峰峰值(kPa)');

end



