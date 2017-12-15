%% ����޵Ļ���
function res = singleVesselExpPlot(CombineDataCells,cmpCombineData,legendLabels)
%Ҫ������CombineData
%Ҫ������DataCells
%��Ϊ�����ʷ�ĸ��CombineData
%��Ϊ�����ʷ�ĸ��DataCells
baseField = 'rawData';
errorType = 'ci';
legendLabelsAbb = {'A','B'};
pressureDropMeasureRang = [2,3];
leg = legendLabels;
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
if 0
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
    vesselCombineDataCells = {CombineDataCells{:},cmpCombineData};
    
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
    ylabelText = 'ѹ������������(%)';

    fh = figureExpPressurePlusSuppressionRate(CombineDataCells...
            ,legendLabels(1:end-1)...        
            ,'errorDrawType','bar'...
            ,'showVesselRigon',0 ...
            ,'suppressionRateBase',suppressionRateBase...
            ,'xIsMeasurePoint',0 ...
            ,'figureHeight',8 ...
            ,'xlabelText',xlabelText...
            ,'ylabelText',ylabelText...
            );
        
end

%�Բ��1����ʱƵ��������
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%����1��Ƶ�ĶԱ�
%% ���Ʊ�Ƶ
if 1
    fh = figureExpNatureFrequencyBar(CombineDataCells,1,legendLabels(1:end-1));
    fh = figureExpNatureFrequencyBar(CombineDataCells,2,legendLabels(1:end-1));
    fh = figureExpNatureFrequencyBar(CombineDataCells,3,legendLabels(1:end-1));
end
end