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
rang = 1:13;
showPureVessel = 0;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'errortype' %误差带的类型
        	errorType = val;
        case 'rang'
            rang = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
figure
paperFigureSet_normal();
%需要显示单一缓冲罐
x = constExpMeasurementPointDistance();%测点对应的距离
if showPureVessel
    meanVessel = constExpVesselPressrePlus(420);
    plot(x,meanVessel(rang),'LineStyle',':','color',[160,162,162]./255);
    hold on;
end

for plotCount = 1:length(dataCombineStructCells)
    if 2 == plotCount
        hold on;
    end
    [y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(dataCombineStructCells{plotCount});
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
        [curHancle(plotCount),fillHandle(plotCount)] = plot(x,y,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    else
        [curHancle(plotCount),fillHandle(plotCount)] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    end
end
xlim([2,11]);
legend(curHancle,legendLabels,0);

set(gca,'Position',[0.13 0.18 0.79 0.65]);
annotation('textbox',...
    [0.48 0.885 0.0998 0.0912],...
    'String','测点',...
    'FaceAlpha',0,...
    'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
annotation('textarrow',[0.38 0.33],...
    [0.744 0.665],'String',{'缓冲罐'},'FontName',paperFontName(),'FontSize',paperFontSize());
vesselFillHandle = plotVesselRegion(gca,constExpVesselRangDistance());
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
xlabel('管线距离(m)');
ylabel('脉动峰峰值(kPa)');

end

