function fh = figureExpNatureFrequency(dataCombineStructCells,varargin)
%绘制实验数据的压力脉动和抑制率图
pp = varargin;
errorType = 'ci';%绘制误差带的模式，std：mean+-sd,ci为95%置信区间，minmax为最大最小
rang = 1:13;
yFilterFunPtr = @fixY;
legendLabels = {};
baseField = 'rawData';
natureFre= [1,2];%固有频率，支持[0.5,1,1.5,2,2.5,3]
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
        case 'errortype' %误差带的类型
        	errorType = val;
        case 'rang'
            rang = val;
        case 'yfilterfunptr'
            yFilterFunPtr = val;
        case 'basefield'
            baseField = val;
        case 'naturefre'
            natureFre = val;
        case 'nf'
            natureFre = val;
        otherwise
       		error('参数错误%s',prop);
    end
end


fh.figure = figure;
paperFigureSet_normal();
x = constExpMeasurementPointDistance();%测点对应的距离
%需要显示单一缓冲罐
plotCount = 1;
if showPureVessel
    dataPat = getPureVesselCombineDataPath(rpm);
    st = loadExpCombineDataStrcut(dataPat);
    plotMarker = getMarkStyle(plotCount);
    plotColor = getPlotColor(plotCount);
    for i=1:length(natureFre)
        [y,stdVal,maxVal,minVal,muci] = getExpCombineNatureFrequencyDatas(st);
        
    end
    plot(x,meanVessel(rang),'LineStyle',':','color',[160,162,162]./255);
    hold on;
end

for plotCount = 1:length(dataCombineStructCells)
    [y,stdVal,maxVal,minVal,muci] = getExpCombineReadSuppressionLevelData(dataCombineStructCells{plotCount});
    if isnan(y)
        error('此数据未有进行完全的分析，没有脉动抑制率');
    end
    y = y(rang).*100;

    if strcmp(errorType,'std')
        yUp = y + stdVal(rang).* 100;
        yDown = y - stdVal(rang).* 100;
    elseif strcmp(errorType,'ci')
        yUp = muci(2,rang).* 100;
        yDown = muci(1,rang).* 100;
    elseif strcmp(errorType,'minmax')
        yUp = maxVal(rang).* 100;
        yDown = minVal(rang).* 100;
    end
    getUpDownRang(y,stdVal,maxVal,minVal,muci);
    if isa(yFilterFunPtr,'function_handle')
        [y,yUp,yDown]= yFilterFunPtr(y,yUp,yDown);
    end

    if strcmp(errorType,'none')
        fh.plotHandle(plotCount) = plot(x,y,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    else
        [fh.plotHandle(plotCount),fh.errFillHandle(plotCount)] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    end
end
xlim([2,11]);
fh.legend = legend(fh.plotHandle,legendLabels,0);

set(gca,'Position',[0.13 0.18 0.79 0.65]);
fh.textboxTopAxixTitle = annotation('textbox',...
    [0.48 0.885 0.0998 0.0912],...
    'String','测点',...
    'FaceAlpha',0,...
    'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
fh.textarrow = annotation('textarrow',[0.38 0.33],...
    [0.744 0.665],'String',{'缓冲罐'},'FontName',paperFontName(),'FontSize',paperFontSize());
fh.vesselFillHandle = plotVesselRegion(gca,constExpVesselRangDistance());
ax = axis;
% 绘制测点线
yLabel2Detal = (ax(4) - ax(3))/12;
for i = 1:length(x)
    fh.measurementGridLine(i) = plot([x(i),x(i)],[ax(3),ax(4)],':','color',[160,160,160]./255);
    if 0 == mod(i,2)
        continue;
    end
    if x(i) < 10
        fh.measurementText(i) = text(x(i)-0.15,ax(4)+yLabel2Detal,sprintf('%d',i),'FontName',paperFontName(),'FontSize',paperFontSize());
    else
        fh.measurementText(i) = text(x(i)-0.3,ax(4)+yLabel2Detal,sprintf('%d',i),'FontName',paperFontName(),'FontSize',paperFontSize());           
    end
end
xlabel('管线距离(m)');
ylabel('脉动抑制率(%)');

end

function [yUp,yDown] = getUpDownRang(y,stdVal,maxVal,minVal,muci,errorType,rang)
    if strcmp(errorType,'std')
        yUp = y + stdVal(rang).* 100;
        yDown = y - stdVal(rang).* 100;
    elseif strcmp(errorType,'ci')
        yUp = muci(2,rang).* 100;
        yDown = muci(1,rang).* 100;
    elseif strcmp(errorType,'minmax')
        yUp = maxVal(rang).* 100;
        yDown = minVal(rang).* 100;
    end
end
