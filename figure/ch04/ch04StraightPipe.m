%% 第四章 绘图 - 直管

clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 数据路径
if 1
straightPipeDataPath = fullfile(dataPath,'实验原始数据\纯直管\RPM420-0.1MPa');%直管

%% 加载数据
[straightPipeDataCells,straightPipeCombineData] ...
    = loadExpDataFromFolder(straightPipeDataPath);
end


%% 绘图 
isSavePlot = 0;

%% 实验数据分析

%% 绘制压力波和频率
if 0
 	paperPlot04StraightPipePressureAndFrequency(straightPipeDataCells{1,2}.subSpectrumData,isSavePlot);
end

%% 绘制所有测点的时频分析
if 1
    paperPlot04StraightPipeSTFT(straightPipeDataCells{1,2}.rawData,isSavePlot);
end

%% 扫频数据分析
if 0
	%sweepResult = loadExperimentPressureData(fullfile(dataPath,'纯直管开机450降300转0.05mpa.CSV'));
	sweepResult = loadExperimentPressureData(fullfile(dataPath,'实验原始数据\纯直管\RPM420-0.1MPa\纯直管开机450降300转0.05mpa.CSV'));
	paperPlot04StraightPipeSweepFrequency(sweepResult,isSavePlot);
end


if 0
    fh = figureExpPressurePlus(straightPipeCombineData...
        ,'errorType','ci'...
        ,'showPureVessel',0);
end

%绘制1倍频的对比
%% 绘制倍频
if 0
	paperPlot04StraightPipeNatureFrequency(straightPipeCombineData,{},isSavePlot);
end
