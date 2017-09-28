function fh = figureExpAndSimPressurePlus(expDataCombineStruct,simDataStruct,varargin)
%����ʵ�����ݵ�ѹ��������������ͼ
% dataCombineStruct �������һ��dataCombineStruct�ͻ���һ��ͼ�����Ҫ���ƶ��������һ��dataCombineStructCells
% varargin��ѡ���ԣ�
% errortype:'std':���������Ǳ�׼�'ci'����������95%�������䣬'minmax'����������min��max�������䣬��none������������
% rang������㷶Χ��Ĭ��Ϊ1:13,���Ǹı���˳�򣬷�����Ҫ���
% showpurevessel�����Ƿ���ʾ��һ����ޡ�
pp = varargin;
errorType = 'ci';
rang = 1:13;
showPureVessel = 0;
pureVesselLegend = {};
legendLabels = {};
rpm = 420;
xSim = nan;
%��������İѵ�һ��varargin��Ϊlegend
if 0 ~= mod(length(pp),2)
    legendLabels = pp{1};
    pp=pp(2:end);
end
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'errortype' %����������
        	errorType = val;
        case 'rang'
            rang = val;
        case 'showpurevessel'
            showPureVessel = val;
        case 'purevessellegend'
            pureVesselLegend = val;
        case 'rpm'
            rpm = val;
        case 'xsim'
            xSim = val;
        otherwise
       		error('��������%s',prop);
    end
end
if isempty(xSim)
    error('xSim����ָ��');
end
figure
paperFigureSet_normal();
x = constExpMeasurementPointDistance();%����Ӧ�ľ���
%��Ҫ��ʾ��һ�����
if showPureVessel
    meanVessel = constExpVesselPressrePlus(rpm);
    fh.vesselHandle =  plot(x,meanVessel(rang),'LineStyle',':','color',[160,162,162]./255);
    hold on;
end

   
for plotCount = 1:length(expDataCombineStruct)
    
    if(1 == length(expDataCombineStruct))
        [y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(expDataCombineStruct);
        ySimVal = simDataStruct.rawData.pulsationValue;
    else
        [y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(expDataCombineStruct{plotCount});
        ySimVal = simDataStruct{plotCount}.rawData.pulsationValue;
    end
    if ~iscell(xSim)
        xSimVal = xSim;
    else
        xSimVal = xSim{plotCount};
    end
    
    if isnan(y)
        error('û�л�ȡ�����ݣ���ȷ�����ݽ��й��˹�������ȡ');
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
        [fh.plotHandle(plotCount),fh.errFillHandle(plotCount)] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    end
    if 1 == plotCount
        hold on;
    end
    fh.plotHandleSim(plotCount) = plot(xSimVal,ySimVal,'color',getPlotColor(plotCount)...
        ,'Marker',getMarkStyle(plotCount),'LineStyle','--');
end

xlim([2,11]);
if ~isempty(legendLabels)
    tmp = legendLabels;
    plotHandle = [];
    if ~isempty(pureVesselLegend)
        legendLabels{1} = pureVesselLegend;
        plotHandle(1) =  fh.vesselHandle;
    end
    
    for i=1:length(expDataCombineStruct)
    	legendLabels{length(legendLabels)+1} = sprintf('ʵ��-%s',tmp{i});
        plotHandle(length(plotHandle)+1) = fh.plotHandle(i);
        legendLabels{length(legendLabels)+1} = sprintf('ģ��-%s',tmp{i});
        plotHandle(length(plotHandle)+1) = fh.plotHandleSim(i);
    end
        
    fh.legend = legend(plotHandle,legendLabels,0);
end

set(gca,'Position',[0.13 0.18 0.79 0.65]);
fh.textboxMeasurePoint = annotation('textbox',...
    [0.48 0.885 0.0998 0.0912],...
    'String','���',...
    'FaceAlpha',0,...
    'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
fh.textarrowVessel = annotation('textarrow',[0.38 0.33],...
    [0.744 0.665],'String',{'�����'},'FontName',paperFontName(),'FontSize',paperFontSize());
vesselFillHandle = plotVesselRegion(gca,constExpVesselRangDistance());
ax = axis;
yLabel2Detal = (ax(4) - ax(3))/12;
% ���Ʋ����
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
xlabel('���߾���(m)');
ylabel('�������ֵ(kPa)');
fh.gca = gca;
end



