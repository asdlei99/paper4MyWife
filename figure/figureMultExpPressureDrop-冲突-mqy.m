function [ curHancle,fillHandle,vesselFillHandle] = figureMultExpPressureDrop(dataCombineStructCells,legendLabels,measureRang,varargin)
%绘制实验数据的压力降图
% dataCombineStructCells：联合数据结构体的数组
% legendLabels:对应联合数据结构体的数组的名称
% measureRang:测点范围（1X2矩阵），压力降就是meanPressure(measureRang(1)) - meanPressure(measureRang(2))
% varargin可选属性：
% errortype:'std':上下误差带是标准差，'ci'上下误差带是95%置信区间，'minmax'上下误差带是min和max置信区间，‘none’不绘制误差带
% chartType：绘图类型，可选‘bar’或者‘line’
pp = varargin;
errorType = 'ci';
chartType = 'line';
baseField = 'rawData';
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'errortype' %误差带的类型
        	errorType = val;
        case 'chartType'
            chartType = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
figure
paperFigureSet_normal();

x = 1:length(dataCombineStructCells);

for i=1:length(dataCombineStructCells)
    [y(i),stdVal(i),maxVal(i),minVal(i),muci(i)]=getExpCombinePressureDropData(dataCombineStructCells(i),measureRang,baseField);
    if strcmp(errorType,'std')
        yUp = y + stdVal(rang);
        yDown = y - stdVal(rang);
    elseif strcmp(errorType,'ci')
        yUp = muci(2,rang);
        yDown = muci(1,rang);
    elseif strcmp(errorType,'minmax')
        yUp = maxVal(rang);
        yDown = minVal(rang);
    end
end


if strcmp(errorType,'none')
    [curHancle(plotCount),fillHandle(plotCount)] = plot(x,y,'color',getPlotColor(1)...
        ,'Marker',getMarkStyle(1));
else
    [curHancle(plotCount),fillHandle(plotCount)] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(1)...
        ,'Marker',getMarkStyle(1));
end

%legend(curHancle,legendLabels,0);

xlabel('类型');
ylabel('压力降(kPa)');

end

