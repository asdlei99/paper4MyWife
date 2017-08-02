%% 第七章 绘图 - 双罐不同接法研究
%第七章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 数据路径
doubleVessel_L_CombineDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\双缓冲罐L型420转0.1mpa');%侧前进直后出
doubleVessel_Z_CombineDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\双缓冲罐Z型420转0.1mpa');
doubleVessel_Straight_CombineDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\双缓冲罐串联420转0.1mpa');
doubleVessel_Elbow_CombineDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\双缓冲罐串联罐二当弯头420转0.1mpa');
doubleVessel_H_CombineDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\双缓冲罐并排L型420转0.1mpa');

%% 加载中间孔板以及缓冲罐数据
[doubleVessel_L_DataCells,doubleVessel_L_CombineData] ...
    = loadExpDataFromFolder(doubleVessel_L_CombineDataPath);
[doubleVessel_Z_DataCells,doubleVessel_Z_CombineData] ...
    = loadExpDataFromFolder(doubleVessel_Z_CombineDataPath);
[doubleVessel_Straight_DataCells,doubleVessel_Straight_CombineData] ...
    = loadExpDataFromFolder(doubleVessel_Straight_CombineDataPath);
[doubleVessel_Elbow_DataCells,doubleVessel_Elbow_CombineData] ...
    = loadExpDataFromFolder(doubleVessel_Elbow_CombineDataPath);
[doubleVessel_H_DataCells,doubleVessel_H_CombineData] ...
    = loadExpDataFromFolder(doubleVessel_H_CombineDataPath);


%对比单孔
doubleVesselCombineDataCells = {doubleVessel_Straight_CombineData...
    ,doubleVessel_Z_CombineData...
    ,doubleVessel_L_CombineData...
    ,doubleVessel_Elbow_CombineData...
    ,doubleVessel_H_CombineData...
    };
legendLabels = {'双罐串联','双罐Z型','双罐L型','双罐串联罐二当弯头','双罐H型'};


%% ===================================================================================
%
%

%% 
fh = figureExpPressureSpectrum(doubleVessel_L_DataCells);

%% 分析参数设置
%时频分析参数设置
Fs = 100;%实验采样率
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
STFTChartType = 'plot3';%contour|plot3
%% 绘图 
%% [1,3,5,7,9,13]测点的时频分析波形
if 1
    dataNumIndex = 2;%读取的实验组数，<5
    measurePoint = [1,3,5,7,9,13];%时频分析波形的测点
    stftLabels = {};
    for i = 1:length(measurePoint)
        stftLabels{i} = sprintf('测点%d',measurePoint(i));
    end
    fh = figureExpPressureSTFT(getExpDataStruct(doubleVessel_L_DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    title('L型');
    fh = figureExpPressureSTFT(getExpDataStruct(doubleVessel_Z_DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(doubleVessel_Straight_DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(doubleVessel_Elbow_DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(doubleVessel_H_DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
end
%绘制0.25D的压力脉动
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% 绘制多组压力脉动
fh = figureExpPressurePlus(doubleVesselCombineDataCells,legendLabels,'errorType',errorType...
    ,'showPureVessel',0);

%绘制0.25D的压力脉动抑制率
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% 绘制多组压力脉动抑制率
%% 绘制多组压力降
fh = figureExpPressureDrop(doubleVesselCombineDataCells,legendLabels,[2,3],'chartType','bar');
%'chartType'== 'bar' 时用于设置bar的颜色
set(fh.barHandle,'FaceColor',getPlotColor(1));
%对测点1进行时频分析波形
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%绘制1倍频的对比
%% 绘制倍频
fh = figureExpNatureFrequencyBar(doubleVesselCombineDataCells,1,legendLabels);
fh = figureExpNatureFrequencyBar(doubleVesselCombineDataCells,2,legendLabels);
fh = figureExpNatureFrequencyBar(doubleVesselCombineDataCells,3,legendLabels);

figureExpPressureMean(doubleVesselCombineDataCells,legendLabels);
