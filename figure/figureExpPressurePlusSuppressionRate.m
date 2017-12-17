function fh = figureExpPressurePlusSuppressionRate(dataCombineStruct,varargin)
%绘制实验数据的压力脉动和抑制率图
% dataCombineStruct 如果传入一个dataCombineStruct就绘制一个图，如果要绘制多个，传入一个dataCombineStructCells
% varargin可选属性：
% errortype:'std':上下误差带是标准差，'ci'上下误差带是95%置信区间，'minmax'上下误差带是min和max置信区间，‘none’不绘制误差带
% rang：‘测点范围’默认为1:13,除非改变测点顺序，否则不需要变更
% showpurevessel：‘是否显示单一缓冲罐’
% fh = figureExpPressurePlusSuppressionRate({expStraightLinkCombineData,expElbowLinkCombineData}...
%         ,legendText...        
%         ,'errorDrawType','bar'...
%         ,'showVesselRigon',0 ...
%         ,'xs',xSuppressionRate ...
%         ,'rangs',expRang...
%         ,'suppressionRateBase',suppressionRateBase...
%         ,'xIsMeasurePoint',1 ...
%         ,'figureHeight',6 ...
%         ,'xlabelText',xlabelText...
%         ,'xTopText',xTopText...
%         ,'ylabelText',ylabelText...
%         );
pp = varargin;
errorType = 'ci';
errorDrawType = 'area';
rangs = {};
pureVesselLegend = {};
legendLabels = {};
rpm = 420;
xs = {};
suppressionRateBase = {};
xlimRang = [];
ylimRang = [];
showVesselRigon = 1;
xIsMeasurePoint = 0;%
figureHeight = 6;
xlabelText = '管线距离(m)';
xTopText = '测点';
ylabelText = '脉动抑制率(%)';
vesselText = '缓冲罐';
isFigure = 1;
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
        case 'rangs'
            rangs = val;
        case 'rpm'
            rpm = val;
        case 'xs'
            xs = val;
        case 'suppressionratebase' %脉动抑制率计算的分母项
            suppressionRateBase = val;
        case 'xlim'
            xlimRang = val;
        case 'ylim'
            ylimRang = val;
        case 'errordrawtype'
            errorDrawType = val;
        case 'showvesselrigon'
            showVesselRigon = val;
        case 'xismeasurepoint'
            xIsMeasurePoint = val;%此属性设置为1，则绘图时x轴时测点
        case 'figureheight'
            figureHeight = val;
        case 'xlabeltext'
            xlabelText = val;
        case 'ylabeltext'
            ylabelText = val;    
        case 'xtoptext'
            xTopText = val;
        case 'vesseltext'
            vesselText = val;
        case 'isfigure'
            isFigure = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
if isFigure
    fh.gcf = figure();
    paperFigureSet_normal(figureHeight);
end
if isempty(rangs)
    rangs{1} = 1:13;
end
%抑制率的分母项目
if isempty(suppressionRateBase)
    for plotCount = 1:length(dataCombineStruct)
        suppressionRateBase{plotCount} = constExpVesselPressrePlus(rpm);
        suppressionRateBase{plotCount} = suppressionRateBase{plotCount}(rangs{1});
    end
end
if isempty(xs)
    if ~xIsMeasurePoint
        xs{1} = constExpMeasurementPointDistance();%测点对应的距离
    end
end
   
for plotCount = 1:length(dataCombineStruct)
    if 2 == plotCount
        hold on;
    end
    if(1 == length(dataCombineStruct) && ~iscell(dataCombineStruct))
        [y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(dataCombineStruct);
    else
        [y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(dataCombineStruct{plotCount});
    end
    if isnan(y)
        error('没有获取到数据，请确保数据进行过人工脉动读取');
    end
    if 1 == length(xs)
        x = xs{1};
    else
        x = xs{plotCount};
    end
    if 1 == length(rangs)
        rang = rangs{1};
    else
        rang = rangs{plotCount};
    end
    if 1 == length(suppressionRateBase)
        srb = suppressionRateBase{1};
    else
        srb = suppressionRateBase{plotCount};
    end
    y = y(rang);

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
    y = ((srb - y) ./ srb) .* 100;
    yUp = ((srb - yUp) ./ srb) .* 100;
    yDown = ((srb - yDown) ./ srb) .* 100;
    if strcmp(errorType,'none')
        fh.plotHandle(plotCount) = plot(x,y,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    else
        [fh.plotHandle(plotCount),fh.errFillHandle(plotCount)] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount),'type',errorDrawType);
    end
end
if ~isempty(xlimRang)
    xlim(xlimRang);
end
if ~isempty(ylimRang)
    ylim(ylimRang);
end
if ~isempty(legendLabels)
    if isempty(pureVesselLegend)
        fh.legend = legend(fh.plotHandle,legendLabels,0);
    else
        legendLabels(2:length(legendLabels)+1) = legendLabels;
        legendLabels{1} = pureVesselLegend;
        fh.legend = legend([fh.vesselHandle,fh.plotHandle],legendLabels,0);
    end
end
if ~xIsMeasurePoint
    if isFigure
        set(gca,'Position',[0.13 0.18 0.79 0.65]);
        fh.textboxMeasurePoint = annotation('textbox',...
            [0.48 0.885 0.0998 0.0912],...
            'String',xTopText,...
            'FaceAlpha',0,...
            'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
    end
    ax = axis;
    yLabel2Detal = (ax(4) - ax(3))/12;
    % 绘制测点线
    for i = 1:length(x)
        plot([x(i),x(i)],[ax(3),ax(4)],':','color',[160,160,160]./255);
        if 0 == mod(i,2)
            continue;
        end
        if x(i) < 10
            text(x(i)-0.15,ax(4)+yLabel2Detal,sprintf('%d',i),'FontName',paperFontName(),'FontSize',paperFontSize());
        else
            text(x(i)-0.3,ax(4)+yLabel2Detal,sprintf('%d',i),'FontName',paperFontName(),'FontSize',paperFontSize());           
        end
    end
end

xlabel(xlabelText);
if showVesselRigon
    if isFigure
        fh.textarrowVessel = annotation('textarrow',[0.38 0.33],...
        [0.744 0.665],'String',{vesselText},'FontName',paperFontName(),'FontSize',paperFontSize());
    end
    fh.vesselFillHandle = plotVesselRegion(gca,constExpVesselRangDistance());
end
ylabel(ylabelText);
fh.gca = gca;
end



