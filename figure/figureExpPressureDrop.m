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
isUseDropRate=false;%这个为true时，绘制的是压力损失率
isFigure = true;
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
        case 'isfigure'
            isFigure = val;
        case 'isusedroprate'
            isUseDropRate = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
if isFigure
    fh.figure = figure;
    paperFigureSet('small',6);
end

x = 1:length(dataCombineStructCells);
if iscell(measureRang)
    for i=1:length(dataCombineStructCells)
         [ pressureDropMeanVal,pressureDropStdVal,pressureDropMaxVal,pressureDropMinVal,pressureDropMuci,~] ...
        = getExpCombinePressureDropData(dataCombineStructCells{i},measureRang{i},baseField);
        
        pressureDropInfo.mean(i) = pressureDropMeanVal;
        pressureDropInfo.std(i) = pressureDropStdVal;
        pressureDropInfo.max(i) = pressureDropMaxVal;
        pressureDropInfo.min(i) = pressureDropMinVal;
        pressureDropInfo.muci(:,i) = pressureDropMuci(:);
        
        [ pressureMeanVal,pressureStdVal,pressureMaxVal,pressureMinVal,pressureMuci,~] ...
            = getExpCombinePressureData(dataCombineStructCells{i});
        mr = measureRang{i};
        pressureMeanVal = pressureMeanVal(mr);
        pressureMeanVal = mean(pressureMeanVal);
        pressureDropInfo.pressureMean(i) = pressureMeanVal;
    end
    
    if isUseDropRate
        y = pressureDropInfo.mean./pressureDropInfo.pressureMean;
    else  
        y = pressureDropInfo.mean;
    end
    
else
    [ pressureDropMeanVal,pressureDropStdVal,pressureDropMaxVal,pressureDropMinVal,pressureDropMuci,~] ...
        = cellfun(@(x) getExpCombinePressureDropData(x,measureRang,baseField),dataCombineStructCells,'UniformOutput',0);
    [ pressureMeanVal,pressureStdVal,pressureMaxVal,pressureMinVal,pressureMuci,~] ...
        = cellfun(@(x) getExpCombinePressureData(x,baseField),dataCombineStructCells,'UniformOutput',0);
    pressureDropInfo.mean = cell2mat(pressureDropMeanVal);
    pressureDropInfo.std = cell2mat(pressureDropStdVal);
    pressureDropInfo.max = cell2mat(pressureDropMaxVal);
    pressureDropInfo.min = cell2mat(pressureDropMinVal);
    pressureDropInfo.muci = [cell2mat(cellfun(@(x) x(1,1),pressureDropMuci,'UniformOutput',0))...
        ;cell2mat(cellfun(@(x) x(2,1),pressureDropMuci,'UniformOutput',0))];
    
    
    pressureDropInfo.pressureMean = cellfun(@(x) mean(x(measureRang)),pressureMeanVal);
    clear pressureStdVal;clear pressureMaxVal;clear pressureMinVal;clear pressureMuci;
    
    if isUseDropRate
        y = pressureDropInfo.mean./pressureDropInfo.pressureMean;
        y = y.*100;
    else  
        y = pressureDropInfo.mean;
    end
end

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
    
if isUseDropRate
    yUp = yUp ./ pressureDropInfo.pressureMean;
    yDown = yDown ./ pressureDropInfo.pressureMean;
    yUp = yUp.*100;
    yDown = yDown.*100;
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
xlabel('类型','fontsize',paperFontSize());
if isUseDropRate
    ylabel('压力损失百分比(%)','fontsize',paperFontSize());
else
    ylabel('压力降(kPa)','fontsize',paperFontSize());
end
fh.gca = gca;
end

