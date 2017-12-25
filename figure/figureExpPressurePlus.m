function fh = figureExpPressurePlus(dataCombineStruct,varargin)
%����ʵ�����ݵ�ѹ��������������ͼ
% dataCombineStruct �������һ��dataCombineStruct�ͻ���һ��ͼ�����Ҫ���ƶ��������һ��dataCombineStructCells
% varargin��ѡ���ԣ�
% errortype:'std':���������Ǳ�׼�'ci'����������95%�������䣬'minmax'����������min��max�������䣬��none������������
% rang������㷶Χ��Ĭ��Ϊ1:13,���Ǹı���˳�򣬷�����Ҫ���
% showpurevessel�����Ƿ���ʾ��һ����ޡ�
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
       		error('��������%s',prop);
    end
end
if isFigure
    fh.gcf = figure();
    paperFigureSet_normal();
end
x = constExpMeasurementPointDistance();%����Ӧ�ľ���
%��Ҫ��ʾ��һ�����
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
        [0.744 0.665],'String',{'�����'},'FontName',paperFontName(),'FontSize',paperFontSize());
end
if showVesselRegion
    fh.vesselFillHandle = plotVesselRegion(gca,expVesselRang);
end
ax = axis;
yLabel2Detal = (ax(4) - ax(3))/12;
% ���Ʋ����
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
        'String','���',...
        'FaceAlpha',0,...
        'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
end
xlabel('���߾���(m)','FontSize',paperFontSize());
ylabel('ѹ���������ֵ(kPa)','FontSize',paperFontSize());
fh.gca = gca;
end



