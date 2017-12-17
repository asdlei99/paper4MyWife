function fh = figureExpPressurePlusSuppressionRate(dataCombineStruct,varargin)
%����ʵ�����ݵ�ѹ��������������ͼ
% dataCombineStruct �������һ��dataCombineStruct�ͻ���һ��ͼ�����Ҫ���ƶ��������һ��dataCombineStructCells
% varargin��ѡ���ԣ�
% errortype:'std':���������Ǳ�׼�'ci'����������95%�������䣬'minmax'����������min��max�������䣬��none������������
% rang������㷶Χ��Ĭ��Ϊ1:13,���Ǹı���˳�򣬷�����Ҫ���
% showpurevessel�����Ƿ���ʾ��һ����ޡ�
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
xlabelText = '���߾���(m)';
xTopText = '���';
ylabelText = '����������(%)';
vesselText = '�����';
isFigure = 1;
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
        case 'rangs'
            rangs = val;
        case 'rpm'
            rpm = val;
        case 'xs'
            xs = val;
        case 'suppressionratebase' %���������ʼ���ķ�ĸ��
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
            xIsMeasurePoint = val;%����������Ϊ1�����ͼʱx��ʱ���
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
       		error('��������%s',prop);
    end
end
if isFigure
    fh.gcf = figure();
    paperFigureSet_normal(figureHeight);
end
if isempty(rangs)
    rangs{1} = 1:13;
end
%�����ʵķ�ĸ��Ŀ
if isempty(suppressionRateBase)
    for plotCount = 1:length(dataCombineStruct)
        suppressionRateBase{plotCount} = constExpVesselPressrePlus(rpm);
        suppressionRateBase{plotCount} = suppressionRateBase{plotCount}(rangs{1});
    end
end
if isempty(xs)
    if ~xIsMeasurePoint
        xs{1} = constExpMeasurementPointDistance();%����Ӧ�ľ���
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
        error('û�л�ȡ�����ݣ���ȷ�����ݽ��й��˹�������ȡ');
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



