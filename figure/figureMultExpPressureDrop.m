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
        case 'charttype'
            chartType = val;
        case 'basefield'
            baseField = val;
        otherwise
       		error('��������%s',prop);
    end
end

figure
paperFigureSet_normal();

x = 1:length(dataCombineStructCells);
[ pressureDropMeanVal,pressureDropStdVal,pressureDropMaxVal,pressureDropMinVal,pressureDropMuci,~] ...
    = cellfun(@(x) getExpCombinePressureDropData(x,measureRang,baseField),dataCombineStructCells,'UniformOutput',0);
y = cell2mat(pressureDropMeanVal);

if strcmp(errorType,'std')
    yUp = y + cell2mat(pressureDropStdVal);
    yDown = y - cell2mat(pressureDropStdVal);
elseif strcmp(errorType,'ci')
    yUp = cell2mat(cellfun(@(x) x(2,1),pressureDropMuci,'UniformOutput',0));
    yDown = cell2mat(cellfun(@(x) x(1,1),pressureDropMuci,'UniformOutput',0));
elseif strcmp(errorType,'minmax')
    yUp = cell2mat(pressureDropMaxVal);
    yDown = cell2mat(pressureDropMinVal);
end
y=y';
yUp=yUp';
yDown=yDown';

if strcmp(chartType,'line')
    if strcmp(errorType,'none')
        [curHancle] = plot(x,y,'color',getPlotColor(1)...
            ,'Marker',getMarkStyle(1));
    else
        [curHancle,fillHandle] = plotWithError(x,y,yUp,yDown,'type','errorbar','color',getPlotColor(1)...
            ,'Marker',getMarkStyle(1));
    end
else
    if strcmp(errorType,'none')
        curHancle = bar(y);
    else
        errY = [y-yDown,yUp-y];
        barwitherr(errY, y);    % Plot with errorbars
    end
end

%legend(curHancle,legendLabels,0);

set(gca,'XTick',x,'XTickLabel',legendLabels)
xlabel('����');
ylabel('ѹ����(kPa)');

end
