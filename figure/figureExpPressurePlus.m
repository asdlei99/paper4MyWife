function fh = figureExpPressurePlus(dataCombineStruct,varargin)
%绘制实验数据的压力脉动和抑制率图
% dataCombineStruct 如果传入一个dataCombineStruct就绘制一个图，如果要绘制多个，传入一个dataCombineStructCells
% varargin可选属性：
% errortype:'std':上下误差带是标准差，'ci'上下误差带是95%置信区间，'minmax'上下误差带是min和max置信区间，‘none’不绘制误差带
% rang：‘测点范围’默认为1:13,除非改变测点顺序，否则不需要变更
% showpurevessel：‘是否显示单一缓冲罐’
pp = varargin;
errorType = 'ci';
errorPlotType = 'bar';
rang = 1:13;
showPureVessel = 0;
showVesselRegion = 1;
pureVesselLegend = {};
showMeasurePoint = 1;
legendLabels = {};
rpm = 420;
isFigure = 1;
expVesselRang = constExpVesselRangDistance();
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
        case 'showpurevessel'
            showPureVessel = val;
        case 'purevessellegend'
            pureVesselLegend = val;
        case 'rpm'
            rpm = val;
        case 'expvesselrang'
            expVesselRang = val;
        case 'errorplottype'
            errorPlotType =val;
        case 'isfigure'
            isFigure = val;
        case 'showvesselregion'
            showVesselRegion = val;
        case 'showmeasurepoint'
            showMeasurePoint = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
if isFigure
    fh.gcf = figure();
    paperFigureSet_normal();
end
x = constExpMeasurementPointDistance();%测点对应的距离
%需要显示单一缓冲罐
if showPureVessel
    meanVessel = constExpVesselPressrePlus(rpm);
    fh.vesselHandle =  plot(x,meanVessel(rang),'LineStyle',':','color',[160,162,162]./255);
    hold on;
end

   
for plotCount = 1:length(dataCombineStruct)
    if 2 == plotCount
        hold on;
    end
    if(1 == length(dataCombineStruct))
        [y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(dataCombineStruct);
    else
        [y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(dataCombineStruct{plotCount});
    end
    if isnan(y)
        error('没有获取到数据，请确保数据进行过人工脉动读取');
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

    if strcmp(errorType,'none')
        fh.plotHandle(plotCount) = plot(x,y,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    else
        [fh.plotHandle(plotCount),fh.errFillHandle(plotCount)] ...
            = plotWithError(x,y,yUp,yDown,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount)...
            ,'type',errorPlotType);
    end
end
box on;
xlim([2,11]);
if ~isempty(legendLabels)
    if isempty(pureVesselLegend)
        fh.legend = legend(fh.plotHandle,legendLabels,0);
    else
        legendLabels(2:length(legendLabels)+1) = legendLabels;
        legendLabels{1} = pureVesselLegend;
        fh.legend = legend([fh.vesselHandle,fh.plotHandle],legendLabels,0);
    end
end

if  isFigure
    set(gca,'Position',[0.13 0.18 0.79 0.65]);
end
if showVesselRegion
    fh.textarrowVessel = annotation('textarrow',[0.38 0.33],...
        [0.744 0.665],'String',{'缓冲罐'},'FontName',paperFontName(),'FontSize',paperFontSize());
end
if showVesselRegion
    fh.vesselFillHandle = plotVesselRegion(gca,expVesselRang);
end
ax = axis;
yLabel2Detal = (ax(4) - ax(3))/12;
% 绘制测点线
if showMeasurePoint
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
    fh.textboxMeasurePoint = annotation('textbox',...
        [0.48 0.885 0.0998 0.0912],...
        'String','测点',...
        'FaceAlpha',0,...
        'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
end
xlabel('管线距离(m)','FontSize',paperFontSize());
ylabel('压力脉动峰峰值(kPa)','FontSize',paperFontSize());
fh.gca = gca;
end



