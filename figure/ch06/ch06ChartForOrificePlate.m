%% 第六章 绘图 - 孔板相关绘图
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 数据路径
orificD0_5CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.5RPM420罐中间');
orificD0_25CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.25RPM420罐中间');
orificD0_75CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.75RPM420罐中间');
orificD1CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D1RPM420罐中间');
orific28MultHoleD1CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\多孔孔板N28D1RPM420罐中间');
%% 加载中间孔板以及缓冲罐数据
[orificD0_25DataCells,orificD0_25CombineData] = loadExpDataFromFolder(orificD0_25CombineDataPath);
[orificD0_5DataCells,orificD0_5CombineData] = loadExpDataFromFolder(orificD0_5CombineDataPath);
[orificD0_75DataCells,orificD0_75CombineData] = loadExpDataFromFolder(orificD0_75CombineDataPath);
[orificD01DataCells,orificD01CombineData] = loadExpDataFromFolder(orificD1CombineDataPath);
[orific28MultHoleD01DataCells,orific28MultHoleD01CombineData] = loadExpDataFromFolder(orific28MultHoleD1CombineDataPath);
%对比单孔
orificDataCells = {orificD0_25CombineData,orificD0_5CombineData,orificD0_75CombineData,orificD01CombineData};
legendLabels = {'0.25D','0.5D','0.75D','1D'};
%% 分析参数设置
%时频分析参数设置
Fs = 100;%实验采样率
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
%% 绘图 
%% 1D孔板的[1,3,7,13]测点的时频分析波形
dataNumIndex = 2;%读取的实验组数，<5
measurePoint = [1,3,5,7,9,13];%时频分析波形的测点
stftLabels = {};
for i = 1:length(measurePoint)
    stftLabels{i} = sprintf('测点%d',measurePoint(i));
end
fh = figureExpPressureSTFT(getExpDataStruct(orificD0_25DataCells,dataNumIndex,baseField),measurePoint,Fs...
    ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
    ,'subplotRow',2,'figureHeight',10);
fh = figureExpPressureSTFT(getExpDataStruct(orificD01DataCells,dataNumIndex,baseField),measurePoint,Fs...
    ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
    ,'subplotRow',2,'figureHeight',10);

%绘制0.25D的压力脉动
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% 绘制多组压力脉动
fh = figureExpPressurePlus(orificDataCells,legendLabels,'errorType',errorType...
    ,'showPureVessel',1,'purevessellegend','单一缓冲罐');
set(fh.vesselHandle,'color','r');
%绘制0.25D的压力脉动抑制率
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% 绘制多组压力脉动抑制率
fh = figureExpSuppressionLevel(orificDataCells,legendLabels,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);
%% 绘制多组压力降
fh = figureExpPressureDrop(orificDataCells,legendLabels,[2,3],'chartType','bar');
%'chartType'== 'bar' 时用于设置bar的颜色
set(fh.barHandle,'FaceColor',getPlotColor(1));
%对测点1进行时频分析波形
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%绘制1倍频的对比
%% 绘制倍频
fh = figureExpNatureFrequencyBar(orificDataCells,1,legendLabels);
fh = figureExpNatureFrequencyBar(orificDataCells,2,legendLabels);
fh = figureExpNatureFrequencyBar(orificDataCells,3,legendLabels);