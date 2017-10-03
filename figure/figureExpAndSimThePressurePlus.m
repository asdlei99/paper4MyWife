function fh = figureExpAndSimThePressurePlus(expDataCombineStruct,simDataStruct,theDataStruct,varargin)
%绘制实验数据的压力脉动和抑制率图
% dataCombineStruct 如果传入一个dataCombineStruct就绘制一个图，如果要绘制多个，传入一个dataCombineStructCells
% varargin可选属性：
% errortype:'std':上下误差带是标准差，'ci'上下误差带是95%置信区间，'minmax'上下误差带是min和max置信区间，‘none’不绘制误差带
% expRang：‘测点范围’默认为1:13,除非改变测点顺序，否则不需要变更
% showpurevessel：‘是否显示单一缓冲罐’
pp = varargin;
errorType = 'ci';
errorBarType = 'bar';
expRang = 1:13;
simRang = {};
theRang = {};
showPureVessel = 0;
pureVesselLegend = {};
legendLabels = {};
rpm = 420;
xSim = {};
xExp = {};
xThe = {};
xLimVal = [];
yLimVal = [];
showVesselRigion = 1;%是否显示缓冲罐区域
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
        case 'errorbartype' %误差带的绘制形式 - bar 误差棒，area 误差带
        	errorBarType = val;
        case 'exprang'
            expRang = val;
        case 'showpurevessel'
            showPureVessel = val;
        case 'purevessellegend'
            pureVesselLegend = val;
        case 'rpm'
            rpm = val;
        case 'xsim'
            xSim = val;
        case 'xexp'
            xExp = val;
        case 'showvesselrigion'
            showVesselRigion = val;
        case 'xlim'
            xLimVal = val;
        case 'ylim'
            yLimVal = val;
        case 'simrang'
            simRang = val;
        case 'therang'
            theRang = val;
        case 'xthe'
            xThe = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
if isempty(xSim)
    error('xSim必须指定');
end
if isempty(xThe)
    error('xSim必须指定');
end
fh.figure = figure();
paperFigureSet_normal();
if isempty(xExp)
    for i = 1:length(expDataCombineStruct)
        xExp{i} = constExpMeasurementPointDistance();%测点对应的距离
    end
end
%需要显示单一缓冲罐
if showPureVessel
    meanVessel = constExpVesselPressrePlus(rpm);
    rang = getCellRang(expRang,1,1:length(meanVessel));
    fh.vesselHandle =  plot(xExp{1},meanVessel(rang),'LineStyle',':','color',[160,162,162]./255);
    hold on;
end

   
for plotCount = 1:length(expDataCombineStruct)
    if(1 == length(expDataCombineStruct))
        [y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(expDataCombineStruct);
        ySimVal = simDataStruct.rawData.pulsationValue;
        yTheVal = theDataStruct.pulsationValue;
        yTheVal = yTheVal ./ 1000;
    else
        [y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(expDataCombineStruct{plotCount});
        ySimVal = simDataStruct{plotCount}.rawData.pulsationValue;
        yTheVal = theDataStruct{plotCount}.pulsationValue;
        yTheVal = yTheVal ./ 1000;
    end

    if ~iscell(xSim)
        xSimVal = xSim;
    else
        xSimVal = xSim{plotCount};
    end
    if ~iscell(xThe)
        xTheVal = xThe;
    else
        xTheVal = xThe{plotCount};
    end
    if ~iscell(xExp)
        x = xExp;
    else
        x = xExp{plotCount};
    end
    if isnan(y)
        error('没有获取到数据，请确保数据进行过人工脉动读取');
    end

    rang = getCellRang(expRang,plotCount,1:length(y));
    y = y(rang);
    
    rangSim = getCellRang(simRang,plotCount,1:length(ySimVal));
    ySimVal = ySimVal(rangSim);
    
    rangThe = getCellRang(theRang,plotCount,1:length(yTheVal));
    yTheVal = yTheVal(rangThe);
    
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
    
    if strcmp(errorType,'none')
        fh.plotHandle(plotCount) = plot(x,y,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    else
        [fh.plotHandle(plotCount),fh.errFillHandle(plotCount)] = plotWithError(x,y,yUp,yDown...
            ,'color',getPlotColor(plotCount)...
            ,'LineStyle','-'...
            ,'Marker',getMarkStyle(plotCount)...
            ,'type',errorBarType);
    end
    if 1 == plotCount
        hold on;
    end
    fh.plotHandleSim(plotCount) = plot(xSimVal,ySimVal,'color',getPlotColor(plotCount)...
        ,'Marker',getMarkStyle(plotCount),'LineStyle','--');
    fh.plotHandleThe(plotCount) = plot(xTheVal,yTheVal,'color',getPlotColor(plotCount)...
        ,'LineStyle','-.');
end
if ~isempty(xLimVal)
    xlim(xLimVal);
else
    xlim([2,11]);
end
if ~isempty(yLimVal)
    ylim(yLimVal);
end
if ~isempty(legendLabels)
    tmp = legendLabels;
    legendLabels = {};
    plotHandle = [];
    if ~isempty(pureVesselLegend)
        legendLabels{1} = pureVesselLegend;
        plotHandle(1) =  fh.vesselHandle;
    end
    
    for i=1:length(expDataCombineStruct)
    	legendLabels{length(legendLabels)+1} = sprintf('实验-%s',tmp{i});
        plotHandle(length(plotHandle)+1) = fh.plotHandle(i);
        legendLabels{length(legendLabels)+1} = sprintf('模拟-%s',tmp{i});
        plotHandle(length(plotHandle)+1) = fh.plotHandleSim(i);
    end
        
    fh.legend = legend(plotHandle,legendLabels,0);
end

set(gca,'Position',[0.13 0.18 0.79 0.65]);

if showVesselRigion
    fh.textarrowVessel = annotation('textarrow',[0.38 0.33],...
        [0.744 0.665],'String',{'缓冲罐'},'FontName',paperFontName(),'FontSize',paperFontSize());
    vesselFillHandle = plotVesselRegion(gca,constExpVesselRangDistance());
end
ax = axis;
yLabel2Detal = (ax(4) - ax(3))/12;
% 绘制测点线
fh.textboxMeasurePoint = annotation('textbox',...
    [0.48 0.885 0.0998 0.0912],...
    'String','测点',...
    'FaceAlpha',0,...
    'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
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
xlabel('管线距离(m)');
ylabel('脉动峰峰值(kPa)');
fh.gca = gca;
end

function r = getCellRang(rang,i,defaultRang)
    if iscell(rang)
        if isempty(rang)
            r = defaultRang;
            return;
        end
        r = rang{i};
    else
        r = rang;
    end
    
    if isempty(r)
        r = defaultRang;
    end
end

