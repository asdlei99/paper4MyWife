function [ curHancle,fillHandle,vesselFillHandle] = plotExpPressurePlus(dataCombineStruct,varargin)
%绘制实验数据的压力脉动和抑制率图
pp = varargin;
errorType = 'std';
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
        case 'showpurevessel'
            showPureVessel = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
figure
paperFigureSet_normal();

[y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(dataCombineStruct);
if isnan(y)
    error('没有获取到数据，请确保数据进行过人工脉动读取');
end
x = constExpMeasurementPointDistance();%测点对应的距离
y = y(rang);
%需要显示单一缓冲罐
if showPureVessel
    meanVessel = constExpVesselPressrePlus(420);
    plot(x,meanVessel(rang),'LineStyle',':','color',[160,162,162]./255);
    hold on;
end
if strcmp(errorType,'std')
    yUp = y + stdVal(rang);
    yDown = y - stdVal(rang);
elseif strcmp(errorType,'ci')
    yUp = muci(2,rang);
    yDown = muci(1,rang);
else 
    yUp = maxVal(rang);
    yDown = minVal(rang);
end
[curHancle,fillHandle] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(1));
xlim([2,11]);

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

