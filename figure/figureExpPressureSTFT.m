function [ curHancle,fillHandle,pressureDropInfo] = figureExpPressureSTFT(dataCells,meaPoint,varargin)
%����ʵ�����ݵĶ�ʱ����Ҷ�任����ͼ
% dataCells��dataStructCells�µľ������������dataStructCells{n,2}
% meaPoint:���
% varargin��ѡ���ԣ�
% chartType����ͼ���ͣ���ѡ��contour����Ĭ�ϣ����ߡ�plot3��
% baseField: ��ͼ�������ͣ�
pp = varargin;
chartType = 'contour';
baseField = 'rawData';
STFT.windowSectionPointNums = 1024;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'stft' %����������
        	STFT = val;
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
pressureDropInfo.mean = y;
-- ����
pressureDropInfo.std = cell2mat(pressureDropStdVal);
pressureDropInfo.max = cell2mat(pressureDropMaxVal);
pressureDropInfo.min = cell2mat(pressureDropMinVal);
pressureDropInfo.muci = [cell2mat(cellfun(@(x) x(1,1),pressureDropMuci,'UniformOutput',0));cell2mat(cellfun(@(x) x(2,1),pressureDropMuci,'UniformOutput',0))];
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
pressureDropInfo.mean = y;

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

