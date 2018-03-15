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
errorPlotType = 'area';
markerStyle = 'haveMarker';%��marker����������Ϊpoint���Ƶ�ͼ
rangs = {};
pureVesselLegend = {};
legendLabels = {};
rpm = 420;
xs = {};
suppressionRateBase = {};
suppressionRateBaseErr = {};%���������ʼ���ķ�ĸ���Ӧ�������ǶԱ�������
xlimRang = [];
ylimRang = [];
showVesselRigon = 1;
xIsMeasurePoint = 0;%
figureHeight = 6;
xlabelText = '���߾���(m)';
xTopText = '���';
ylabelText = '�������������(%)';
vesselText = '����';
isFigure = 1;
showMeasurePoint = 1;
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
        case 'suppressionratebaseerr'%���������ʼ���ķ�ĸ���Ӧ�������ǶԱ�������
            suppressionRateBaseErr = val;
        case 'xlim'
            xlimRang = val;
        case 'ylim'
            ylimRang = val;
        case 'errorplottype'
            errorPlotType = val;
        case 'showvesselrigon'
            showVesselRigon = val;
        case 'showmeasurepoint'
            showMeasurePoint = val;
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
        case 'markerstyle'
            markerStyle = val;
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
    if iscell(rangs)
        if 1 == length(rangs)
            rang = rangs{1};
        else
            rang = rangs{plotCount};
        end
    else
        rang = rangs;
    end
    if iscell(suppressionRateBase)
        if 1 == length(suppressionRateBase)
            srb = suppressionRateBase{1};
        else
            srb = suppressionRateBase{plotCount};
        end
    else
        srb = suppressionRateBase;
    end
    
    
    if iscell(suppressionRateBaseErr) 
        if 1 == length(suppressionRateBaseErr)
            errPa = suppressionRateBase{1};
        else
            errPa = suppressionRateBase{plotCount};
        end
    else
        errPa = suppressionRateBaseErr;
    end
    Pb = y(rang);
    y = ((srb - Pb) ./ srb) .* 100;
    if isempty(suppressionRateBaseErr)
        if strcmp(errorType,'std')
            yUp = Pb + stdVal(rang);
            yDown = Pb - stdVal(rang);
        elseif strcmp(errorType,'ci')
            yUp = muci(2,rang);
            yDown = muci(1,rang);
        elseif strcmp(errorType,'minmax')
            yUp = maxVal(rang);
            yDown = minVal(rang);
        end
        yUp = ((srb - yUp) ./ srb) .* 100;
        yDown = ((srb - yDown) ./ srb) .* 100;
    else
        yUp = muci(2,rang);
        yDown = muci(1,rang);
        errPb = yUp - yDown;
        Pa = srb;
        errSr = errChange(errPa,errPb,Pa,Pb,y);
        yUp = y + (errSr ./ 2);
        yDown = y - (errSr ./ 2);
    end
    
    if strcmpi(markerStyle,'haveMarker')
        marker = getMarkStyle(plotCount);
        lineStyle = '-';
    else
        marker = 'none';
        lineStyle = getLineStyle(plotCount);
    end
    if strcmp(errorType,'none')
        fh.plotHandle(plotCount) = plot(x,y,'color',getPlotColor(plotCount)...
            ,'Marker',marker,'lineStyle',lineStyle);
    else
        [fh.plotHandle(plotCount),fh.errFillHandle(plotCount)] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(plotCount)...
            ,'Marker',marker,'lineStyle',lineStyle,'type',errorPlotType);
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
    end
    ax = axis;
    yLabel2Detal = (ax(4) - ax(3))/12;
    % ���Ʋ����
    if showMeasurePoint
        for i = 1:length(x)
            fh.measurePointGrid(i) = plot([x(i),x(i)],[ax(3),ax(4)],'LineStyle',':','color',[160,160,160]./255);
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
            'String',xTopText,...
            'FaceAlpha',0,...
            'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
    end
end


if showVesselRigon
    if isFigure
        fh.textarrowVessel = annotation('textarrow',[0.38 0.33],...
        [0.744 0.665],'String',{vesselText},'FontName',paperFontName(),'FontSize',paperFontSize());
    end
    fh.vesselFillHandle = plotVesselRegion(gca,constExpVesselRangDistance());
end
xlabel(xlabelText,'fontsize',paperFontSize());
ylabel(ylabelText,'fontsize',paperFontSize());
xlim([2,11]);
box on;
fh.gca = gca;
if isfield(fh,'measurePointGrid')
    for i = 1:length(fh.measurePointGrid)
        set(fh.measurePointGrid(i),'LineStyle',':');
    end
end
end


function err = errChange(ErrPa,ErrPb,Pa,Pb,Psr)
    err = Psr .* ((((ErrPa.^2 + ErrPb.^2) ./ (Pa - Pb).^2 ) + (ErrPa  ./ Pa ).^ 2) .^ 0.5 );
end
