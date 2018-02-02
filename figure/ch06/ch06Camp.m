%% 第六章 绘图 - 相同同流面积压力脉动对比
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 数据路径
orificD1CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D1RPM420罐中间');
perforateD01N28DataPath = fullfile(dataPath,'实验原始数据\内插孔管\D1N28d20RPM420两头堵');
innerPipeD1CombineDataPath = fullfile(dataPath,'实验原始数据\内插管\内插管1D罐中间420转0.05mpa');
vesselCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\RPM420');
%% 加载内插管以及缓冲罐数据
%0.5D,0.75D,1D孔板的实验模拟数据

[expOrificD01ataCells,expOrificD01CombineData,simOrificD01DataCell] ...
    = loadExpAndSimDataFromFolder(orificD1CombineDataPath);
[expPerforateD01N28DataCells,expPerforateD01N28CombineData] ...
    = loadExpDataFromFolder(perforateD01N28DataPath);
[expInnerPipe01DataCells,expInnerPipe01CombineData] ...
    = loadExpDataFromFolder(innerPipeD1CombineDataPath);
% simFixData = [2,3,4,4,3.5,3,-1,2,3,4,5,6,7,8,9,10,10,10,10];
% simOrificD0_25DataCell.rawData.pulsationValue(:) = simOrificD0_25DataCell.rawData.pulsationValue(:) + simFixData'; 
% simOrificD0_5DataCell.rawData.pulsationValue(:) = simOrificD0_5DataCell.rawData.pulsationValue(:) + simFixData';
% simOrificD0_75DataCell.rawData.pulsationValue(:) = simOrificD0_75DataCell.rawData.pulsationValue(:) + simFixData';
% simOrificD01DataCell.rawData.pulsationValue(:) = simOrificD01DataCell.rawData.pulsationValue(:) + simFixData';
%单一缓冲罐数据
[expVesselDataCells,expVesselCombineData,simVesselDataCell] ...
    = loadExpAndSimDataFromFolder(vesselCombineDataPath);
fixSimVessel = constSimVesselPlusValueFix();
simVesselDataCell.rawData.pulsationValue(:) = simVesselDataCell.rawData.pulsationValue(:)+fixSimVessel';
%对比单孔
innerElementDataCells = {expOrificD01CombineData,expPerforateD01N28CombineData,expInnerPipe01CombineData};
legendLabels = {'1d孔板','1d孔管','1d内插滤波管'};
%% 分析参数设置
%时频分析参数设置
Fs = 100;%实验采样率
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
isSaveFigure = 0;
%%
param.acousticVelocity = 345;%声速（m/s）
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv1 = 1.1/2;
param.Lv2 = 1.1/2;
param.l = 0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%管道直径（m）
param.Lbias = 0.168+0.150;
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2];
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.Lin = 0.200;
param.Lout = 0.200;
param.Dinnerpipe = param.Dpipe;


%% 绘制多组压力脉动
if 1
	paperPlotInnerElementExpCmp(innerElementDataCells,legendLabels,isSaveFigure)
end

%% 绘制理论模拟实验
if 0
    param.Dinnerpipe = 0.5 * param.Dpipe;
	paperPlotInnerPipeExpTheSim({expInnerPipe0_5CombineData,expInnerPipe0_75CombineData,expInnerPipe01CombineData}...
								,{simInnerPipe0_5DataCell,simInnerPipe0_5DataCell,simInnerPipe0_5DataCell}...
								,param...
								,isSaveFigure);
end

%% 绘制多组压力降低
if 1
    paperPlotInnerPipeExpPressureDrop(innerElementDataCells,legendLabels,isSaveFigure);
end

%对测点1进行时频分析波形
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%绘制1倍频的对比
%% 绘制倍频
if 0
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,1,legendLabels);
    set(fh.legend,'Location','northwest');
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,2,legendLabels);
    set(fh.legend,...
    'Position',[0.546070604348832 0.612951407221974 0.207256941947465 0.280752307323877]);
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,3,legendLabels);
end

%% 理论扩展分析
if 0
    paperPlotInnerPipeTheory(param,isSaveFigure);
end
