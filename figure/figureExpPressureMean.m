function fh = figureExpPressureMean(dataCombineStructCells,varargin)
%����ʵ�����ݵ�ѹ����ͼ
% dataCombineStructCells���������ݽṹ�������
% legendLabels:��Ӧ�������ݽṹ������������
% measureRang:��㷶Χ��1X2���󣩣�ѹ��������meanPressure(measureRang(1)) - meanPressure(measureRang(2))
% varargin��ѡ���ԣ�
% errortype:'std':���������Ǳ�׼�'ci'����������95%�������䣬'minmax'����������min��max�������䣬��none������������
% chartType����ͼ���ͣ���ѡ��bar�����ߡ�line��
pp = varargin;
errorType = 'ci';
baseField = 'rawData';
rang = 1:13;
%��������İѵ�һ��varargin��Ϊlegend
legendLabels = {};
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
        case 'basefield'
            baseField = val;
        case 'rang'
            rang = val;
        otherwise
       		error('��������%s',prop);
    end
end
x = constExpMeasurementPointDistance();%����Ӧ�ľ���
fh.figure = figure;
paperFigureSet_normal();
for i=1:length(dataCombineStructCells)
    [ meanVal(i,:),stdVal(i,:),maxVal(i,:),minVal(i,:),muci,sigmaci] = getExpCombineData(dataCombineStructCells{i},'pressureMean',baseField);
    y = meanVal(i,rang);
    yUp = muci(2,rang);
    yDown = muci(1,rang);
    if strcmp(errorType,'std')
        yUp = meanVal(i,rang) + stdVal(i,rang);
        yDown = meanVal(i,rang) - stdVal(i,rang);
    elseif strcmp(errorType,'minmax')
        yUp = maxVal(i,rang);
        yDown = minVal(i,rang);
    end

    if strcmp(errorType,'none')
        fh.plotHandle(i) = plot(x,meanVal,'color',getPlotColor(i)...
            ,'Marker',getMarkStyle(i));
    else
        [fh.plotHandle(i),fh.errFillHandle(i)] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(i)...
            ,'Marker',getMarkStyle(i));
    end
    if 2 == i
        hold on;
    end

end
xlim([2,11]);
if ~isempty(legendLabels)
    fh.legend = legend(fh.plotHandle,legendLabels,0);
end

set(gca,'Position',[0.13 0.18 0.79 0.65]);
fh.textboxMeasurePoint = annotation('textbox',...
    [0.48 0.885 0.0998 0.0912],...
    'String','���',...
    'FaceAlpha',0,...
    'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
fh.textarrowVessel = annotation('textarrow',[0.38 0.33],...
    [0.744 0.665],'String',{'�����'},'FontName',paperFontName(),'FontSize',paperFontSize());
fh.vesselFillHandle = plotVesselRegion(gca,constExpVesselRangDistance());
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
ylabel('��ѹ(kPa)');

end

