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

[~,orificD0_25CombineData] = loadExpDataFromFolder(orificD0_25CombineDataPath);
[~,orificD0_5CombineData] = loadExpDataFromFolder(orificD0_5CombineDataPath);
[~,orificD0_75CombineData] = loadExpDataFromFolder(orificD0_75CombineDataPath);
[~,orificD01CombineData] = loadExpDataFromFolder(orificD1CombineDataPath);
[~,orific28MultHoleD01CombineData] = loadExpDataFromFolder(orific28MultHoleD1CombineDataPath);
%对比单孔
orificDataCells = {orificD0_25CombineData,orificD0_5CombineData,orificD0_75CombineData,orificD01CombineData};
legendLabels = {'0.25D','0.5D','0.75D','1D'};
%% 绘图

figureExpPressurePlus(orificD0_25CombineData,'errorType',errorType,'showpurevessel',1);
figureMultExpPressurePlus(orificDataCells,legendLabels,'showpurevessel',1);

figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);
figureMultExpSuppressionLevel(orificDataCells,legendLabels,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);

figureMultExpPressureDrop(orificDataCells,legendLabels,[2,3],'chartType','bar');
