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
[straightPipeDataCells,straightPipeCombineData,straightPipeSimData] ...
    = loadExpAndSimDataFromFolder(straightPipeDataPath);
end

param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 345;%声速（m/s）
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.L = 3.5+6;
param.l = 0.01;%(m)缓冲罐的连接管长
param.Dpipe = 0.098;%管道直径（m）
param.sectionL = 0:0.5:param.L;%linspace(0,param.L1,14);

%% 绘图 
% 
% 
isSavePlot = 1;

%% 实验数据分析

%% 绘制压力波和频率
if 0
 	paperPlot04StraightPipePressureAndFrequency(straightPipeDataCells{1,2}.subSpectrumData,isSavePlot);
end

%% 绘制所有测点的时频分析
if 0
    paperPlot04StraightPipeSTFT(straightPipeDataCells{1,2}.rawData,isSavePlot);
end

%% 扫频数据分析
if 0
	sweepResult = loadExperimentPressureData(fullfile(dataPath,'纯直管开机450降300转0.05mpa.CSV'));
	%sweepResult = loadExperimentPressureData(fullfile(dataPath,'实验原始数据\纯直管\RPM420-0.1MPa\纯直管开机450降300转0.05mpa.CSV'));
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

%% 理论 - 直管管径对脉动的影响
if 1
	paperPlot04StraightPipeTheory(param,isSavePlot);
end

