%% 缓冲罐的绘制
function res = singleVesselExpPlot(CombineData,DataCells,cmpCombineData,cmpDataCells,legendLabels)
%要分析的CombineData
%要分析的DataCells
%作为抑制率分母的CombineData
%作为抑制率分母的DataCells
baseField = 'rawData';
errorType = 'ci';
legendLabelsAbb = {'A','B'};
pressureDropMeasureRang = [2,3];
leg = {legendLabels,'直进直出'};
%% 实验直进侧前出

%% 分析参数设置
%时频分析参数设置
Fs = 100;%实验采样率
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
% STFTChartType = 'contour';%contour|plot3
STFTChartType = 'plot3';%contour|plot3
STFT.measurePoint = [1,3,5,7,9,13];%时频分析波形的测点
%% 绘图 
%% [1,3,5,7,9,13]测点的时频分析波形
if 1
    dataNumIndex = 2;%读取的实验组数，<5

    stftLabels = {};
    for i = 1:length(STFT.measurePoint)
        stftLabels{i} = sprintf('测点%d',STFT.measurePoint(i));
    end
    fh = figureExpPressureSTFT(getExpDataStruct(DataCells,dataNumIndex,baseField),STFT.measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
end
%绘制0.25D的压力脉动
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% 绘制多组压力脉动
if 1
    vesselCombineDataCells = {CombineData,cmpCombineData};
    
    fh = figureExpPressurePlus(vesselCombineDataCells,leg...
        ,'errorType','none'...
        ,'showPureVessel',0);
    set(fh.legend,...
         'Position',[0.168290657927067 0.667473958333333 0.256448925406267 0.128921438212402]);
    set(fh.textarrowVessel,'X',[0.230711805555556 0.294722222222223],'Y',[0.277213541666667 0.231744791666667]);
end
%绘制0.25D的压力脉动抑制率
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% 绘制多组压力脉动抑制率
if 1
    ddMean = mean(cmpCombineData.readPlus);
    ddMean = ddMean(1:13);
    suppressionRateBase = {ddMean};
    xlabelText = '距离';
    ylabelText = '脉动抑制率(%)';

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
%% 绘制多组压力降
if 0
    
    fh = figureExpPressureDrop(vesselCombineDataCells,legendLabels,pressureDropMeasureRang,'chartType','bar');
    %'chartType'== 'bar' 时用于设置bar的颜色
    set(fh.barHandle,'FaceColor',getPlotColor(1));
    set(fh.gca,'XTickLabelRotation',30);
end
%对测点1进行时频分析波形
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%绘制1倍频的对比
%% 绘制倍频
if 1
    fh = figureExpNatureFrequencyBar({CombineData,cmpCombineData},1,leg);
    fh = figureExpNatureFrequencyBar({CombineData,cmpCombineData},2,leg);
    fh = figureExpNatureFrequencyBar({CombineData,cmpCombineData},3,leg);
end
end