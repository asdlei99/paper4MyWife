function [ curHancle,fillHandle,vesselFillHandle] = figureMultExpPressureDrop(dataCombineStructCells,legendLabels,measureRang,varargin)
%����ʵ�����ݵ�ѹ����ͼ
% dataCombineStructCells���������ݽṹ�������
% legendLabels:��Ӧ�������ݽṹ������������
% measureRang:��㷶Χ��1X2���󣩣�ѹ��������meanPressure(measureRang(1)) - meanPressure(measureRang(2))
% varargin��ѡ���ԣ�
% errortype:'std':���������Ǳ�׼�'ci'����������95%�������䣬'minmax'����������min��max�������䣬��none������������
% chartType����ͼ���ͣ���ѡ��bar�����ߡ�line��
pp = varargin;
errorType = 'ci';
chartType = 'line';
baseField = 'rawData';
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'errortype' %����������
        	errorType = val;
        case 'chartType'
            chartType = val;
        otherwise
       		error('��������%s',prop);
    end
end
figure
paperFigureSet_normal();

x = 1:length(dataCombineStructCells);

for i=1:length(dataCombineStructCells)
    [y(i),stdVal(i),maxVal(i),minVal(i),muci(i)]=getExpCombinePressureDropData(dataCombineStructCells(i),measureRang,baseField);
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
end


if strcmp(errorType,'none')
    [curHancle(plotCount),fillHandle(plotCount)] = plot(x,y,'color',getPlotColor(1)...
        ,'Marker',getMarkStyle(1));
else
    [curHancle(plotCount),fillHandle(plotCount)] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(1)...
        ,'Marker',getMarkStyle(1));
end

%legend(curHancle,legendLabels,0);

xlabel('����');
ylabel('ѹ����(kPa)');

end

