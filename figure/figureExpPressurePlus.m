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
markerStyle = 'haveMarker';%��marker����������Ϊpoint���Ƶ�ͼ
rang = 1:13;
showPureVessel = 0;
showVesselRegion = 1;
pureVesselLegend = {};
showMeasurePoint = 1;
legendLabels = {};
rpm = 420;
isFigure = 1;
expVesselRang = constExpVesselRangDistance();
yFilterFunPtr = [];
%��������İѵ�һ��varargin��Ϊlegend
if 0 ~= mod(length(pp),2)
    legendLabels = pp{1};
    pp=pp(2:end);
end
resetExpVesselRang = false;
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
            resetExpVesselRang = true;
        case 'errorplottype'
            errorPlotType =val;
        case 'isfigure'
            isFigure = val;
        case 'showvesselregion'
            showVesselRegion = val;
        case 'showmeasurepoint'
            showMeasurePoint = val;
        case 'yfilterfunptr'
            yFilterFunPtr = val;
        case 'markerstyle'
            markerStyle = val;
        otherwise
       		error('��������%s',prop);
    end
end
if isFigure
    fh.gcf = figure();
    paperFigureSet('small',6);
end
if ~resetExpVesselRang && length(rang) == 15
    expVesselRang = constExpTwoVesselRangDistance();   
end
if length(rang) == 13
    x = constExpMeasurementPointDistance();%����Ӧ�ľ���
elseif length(rang) == 15 %˫��
    x = constExpTwoVesselMeasurementPointDistance();
end

if showPureVessel && (length(rang) == 13)
    %��Ҫ��ʾ��һ�����
    meanVessel = constExpVesselPressrePlus(rpm);
    fh.vesselHandle =  plot(x,meanVessel(rang),'LineStyle','-','color',[160,162,162]./255);
    hold on;
end

   
for plotCount = 1:length(dataCombineStruct)
    if 2 == plotCount
        hold on;
    end
    yFunPtr = [];
    if(1 == length(dataCombineStruct))
        [y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(dataCombineStruct);
        yFunPtr = yFilterFunPtr;
    else
        [y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(dataCombineStruct{plotCount});
        if ~isempty(yFilterFunPtr)
            yFunPtr = yFilterFunPtr{plotCount};
        end
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

    if isa(yFunPtr,'function_handle')
        [y,yUp,yDown]= yFunPtr(y,yUp,yDown);
    end

    if strcmp(errorType,'none')
        fh.plotHandle(plotCount) = plot(x,y,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    else
        if strcmpi(markerStyle,'haveMarker');
            marker = getMarkStyle(plotCount);
            markerSize = 6;
            lineStyle = '-';
        else
            marker = 'o';
            markerSize = 1;
            lineStyle = getLineStyle(plotCount);
        end
        [fh.plotHandle(plotCount),fh.errFillHandle(plotCount)] ...
            = plotWithError(x,y,yUp,yDown,'color',getPlotColor(plotCount)...
            ,'Marker',marker...
            ,'lineStyle',lineStyle ...
            ,'MarkerSize',markerSize ...
            ,'type',errorPlotType);
    end
end
box on;
if (length(rang) == 13)
    xlim([2,11]);
else
    xlim([6,29]);
end
if ~isempty(legendLabels)
    if (length(rang) == 13)
        if isempty(pureVesselLegend) || ~showPureVessel
            fh.legend = legend(fh.plotHandle,legendLabels,0);
        else
            legendLabels(2:length(legendLabels)+1) = legendLabels;
            legendLabels{1} = pureVesselLegend;
            fh.legend = legend([fh.vesselHandle,fh.plotHandle],legendLabels,0);
        end
    end
end

if  isFigure
%     set(gca,'Position',[0.13 0.18 0.79 0.65]);
    set(gca,'Position',[0.16 0.188819444444444 0.779252283105023 0.641180555555556]);
end
if showVesselRegion
    if 15 == length(rang)
        fh.textarrowVessel = annotation('textarrow',[0.371822916666667 0.409305555555556],...
        [0.766692708333333 0.723697916666667],'String',{'����'},'FontName',paperFontName(),'FontSize',paperFontSize());
    else
        fh.textarrowVessel = annotation('textarrow',[0.38 0.33],...
        [0.744 0.665],'String',{'����'},'FontName',paperFontName(),'FontSize',paperFontSize());
    end
    fh.vesselFillHandle = plotVesselRegion(gca,expVesselRang);
end

ax = axis;
yLabel2Detal = (ax(4) - ax(3))/12;
% ���Ʋ����
if showMeasurePoint
    for i = 1:length(x)
        fh.measurePointGrid(i) = plot([x(i),x(i)],[ax(3),ax(4)],':','color',[160,160,160]./255);
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
        [0.494497716894977 0.907048611111112 0.0998000000000001 0.0911999999999999],...
        'String','���',...
        'FaceAlpha',0,...
        'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
end
xlabel('���߾���(m)','FontSize',paperFontSize());
ylabel('����ѹ�����ֵ(kPa)','FontSize',paperFontSize());
fh.gca = gca;
end



