%% 第六章绘图
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 加载中间孔管缓冲罐数据
orificD0_5CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.5RPM420罐中间');
orificD0_25CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.25RPM420罐中间');
orificD0_75CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.75RPM420罐中间');
orificD1CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D1RPM420罐中间');
orific28MultHoleD1CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\多孔孔板N28D1RPM420罐中间');
%% 图6-6 中间孔管缓冲罐压力脉动及抑制率

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
STFT.windowSectionPointNums = 256;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
%% 绘图
dataNumIndex = 2;%读取的实验组数，<5
measurePoint = [1,3,7,13];%时频分析波形的测点
fh = figureExpPressureSTFT(getExpDataStruct(orificD01DataCells,dataNumIndex,baseField),measurePoint,Fs...
    ,'STFT',STFT,'chartType',STFTChartType);
ylim([0,30]);
%绘制0.25D的压力脉动
fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%绘制多组压力脉动
fh = figureMultExpPressurePlus(orificDataCells,legendLabels,'showPureVessel',1);
%绘制0.25D的压力脉动抑制率
fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);
%绘制多组压力脉动抑制率
fh = figureMultExpSuppressionLevel(orificDataCells,legendLabels,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);
%绘制多组压力降
figureMultExpPressureDrop(orificDataCells,legendLabels,[2,3],'chartType','bar');
%对测点1进行时频分析波形
