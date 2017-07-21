function fh = figureExpPressureDrop(dataCombineStructCells,legendLabels,measureRang,varargin)
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
        case 'charttype'
            chartType = val;
        case 'basefield'
            baseField = val;
        otherwise
       		error('参数错误%s',prop);
    end
end

fh.figure = figure;
paperFigureSet_normal();

x = 1:length(dataCombineStructCells);
[ pressureDropMeanVal,pressureDropStdVal,pressureDropMaxVal,pressureDropMinVal,pressureDropMuci,~] ...
    = cellfun(@(x) getExpCombinePressureDropData(x,measureRang,baseField),dataCombineStructCells,'UniformOutput',0);

pressureDropInfo.mean = cell2mat(pressureDropMeanVal);
pressureDropInfo.std = cell2mat(pressureDropStdVal);
pressureDropInfo.max = cell2mat(pressureDropMaxVal);
pressureDropInfo.min = cell2mat(pressureDropMinVal);
pressureDropInfo.muci = [cell2mat(cellfun(@(x) x(1,1),pressureDropMuci,'UniformOutput',0));cell2mat(cellfun(@(x) x(2,1),pressureDropMuci,'UniformOutput',0))];
y = pressureDropInfo.mean;
if strcmp(errorType,'std')
    yUp = y + pressureDropInfo.std;
    yDown = y - pressureDropInfo.std;
elseif strcmp(errorType,'ci')
    yUp = pressureDropInfo.muci(2,:);
    yDown = pressureDropInfo.muci(1,:);
elseif strcmp(errorType,'minmax')
    yUp = pressureDropInfo.max;
    yDown = pressureDropInfo.min;
end
y=y';
yUp=yUp';
yDown=yDown';


if strcmp(chartType,'line')
    if strcmp(errorType,'none')
        fh.plotHandle = plot(x,y,'color',getPlotColor(1)...
            ,'Marker',getMarkStyle(1));
    else
        [fh.plotHandle,fh.errFillHandle] = plotWithError(x,y,yUp,yDown,'type','errorbar','color',getPlotColor(1)...
            ,'Marker',getMarkStyle(1));
    end
else
    if strcmp(errorType,'none')
        curHancle = bar(y);
    else
        errY = [y-yDown,yUp-y];
        [fh.barHandle,fh.errBarHandle] = barwitherr(errY, y);    % Plot with errorbars
    end
end
set(gca,'XTick',x,'XTickLabel',legendLabels);
xlabel('类型');
ylabel('压力降(kPa)');

end

