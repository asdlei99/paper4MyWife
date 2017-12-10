%% ����޵Ļ���
function res = singleVesselExpPlot(CombineData,DataCells,cmpCombineData,cmpDataCells,legendLabels)
%Ҫ������CombineData
%Ҫ������DataCells
%��Ϊ�����ʷ�ĸ��CombineData
%��Ϊ�����ʷ�ĸ��DataCells
baseField = 'rawData';
errorType = 'ci';
legendLabelsAbb = {'A','B'};
pressureDropMeasureRang = [2,3];
leg = {legendLabels,'ֱ��ֱ��'};
%% ʵ��ֱ����ǰ��

%% ������������
%ʱƵ������������
Fs = 100;%ʵ�������
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
% STFTChartType = 'contour';%contour|plot3
STFTChartType = 'plot3';%contour|plot3
STFT.measurePoint = [1,3,5,7,9,13];%ʱƵ�������εĲ��
%% ��ͼ 
%% [1,3,5,7,9,13]����ʱƵ��������
if 1
    dataNumIndex = 2;%��ȡ��ʵ��������<5

    stftLabels = {};
    for i = 1:length(STFT.measurePoint)
        stftLabels{i} = sprintf('���%d',STFT.measurePoint(i));
    end
    fh = figureExpPressureSTFT(getExpDataStruct(DataCells,dataNumIndex,baseField),STFT.measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
end
%����0.25D��ѹ������
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% ���ƶ���ѹ������
if 1
    vesselCombineDataCells = {CombineData,cmpCombineData};
    
    fh = figureExpPressurePlus(vesselCombineDataCells,leg...
        ,'errorType','none'...
        ,'showPureVessel',0);
    set(fh.legend,...
         'Position',[0.168290657927067 0.667473958333333 0.256448925406267 0.128921438212402]);
    set(fh.textarrowVessel,'X',[0.230711805555556 0.294722222222223],'Y',[0.277213541666667 0.231744791666667]);
end
%����0.25D��ѹ������������
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% ���ƶ���ѹ������������
if 1
    ddMean = mean(cmpCombineData.readPlus);
    ddMean = ddMean(1:13);
    suppressionRateBase = {ddMean};
    xlabelText = '����';
    ylabelText = '����������(%)';

    fh = figureExpPressurePlusSuppressionRate(CombineData...
            ,[]...        
            ,'errorDrawType','bar'...
            ,'showVesselRigon',0 ...
            ,'suppressionRateBase',suppressionRateBase...
            ,'xIsMeasurePoint',0 ...
            ,'figureHeight',8 ...
            ,'xlabelText',xlabelText...
            ,'ylabelText',ylabelText...
            );
end
%% ���ƶ���ѹ����
if 0
    
    fh = figureExpPressureDrop(vesselCombineDataCells,legendLabels,pressureDropMeasureRang,'chartType','bar');
    %'chartType'== 'bar' ʱ��������bar����ɫ
    set(fh.barHandle,'FaceColor',getPlotColor(1));
    set(fh.gca,'XTickLabelRotation',30);
end
%�Բ��1����ʱƵ��������
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%����1��Ƶ�ĶԱ�
%% ���Ʊ�Ƶ
if 1
    fh = figureExpNatureFrequencyBar({CombineData,cmpCombineData},1,leg);
    fh = figureExpNatureFrequencyBar({CombineData,cmpCombineData},2,leg);
    fh = figureExpNatureFrequencyBar({CombineData,cmpCombineData},3,leg);
end
end