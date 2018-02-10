%% 第七章 绘图 - 双罐理论分析
%第七章画图的参数设置
clear all;
% close all;
clc;
errorType = 'ci';
isSaveFigure = false;
theoryOnly = 0;
dataPath = getDataPath();
%%
if ~theoryOnly
	dvDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\25米管单容顺接0.104mpa');
    [dvDataCells,dvCombineData] = loadExpDataFromFolder(dvDataPath);
end



param.acousticVelocity = 345;%声速
param.isDamping = 1;%是否计算阻尼
param.coeffFriction = 0.003;%管道摩察系数
param.notMach = 0;
detalDis = 0.5;
param.L1 = 13;%L1(m)
param.L2 = 0;%1.5;%双罐串联两罐间距
param.L3 = 13;%4%双罐串联罐二出口管长
param.Dpipe = 0.098;%管道直径（m）%应该是0.106
param.l = 0.01;
param.DV1 = 0.372;%缓冲罐的直径（m）
param.LV1 = 1.1;%缓冲罐总长 （1.1m）
param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
param.LV2 = 1.1;%variant_r(i).*param.DV2;%缓冲罐总长 （1.1m）
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.sectionL1 = 0:detalDis:param.L1;
param.sectionL2 = 0:detalDis:param.L2;
param.sectionL3 = 0:detalDis:param.L3;
param.meanFlowVelocity = 16;
param.mach = param.meanFlowVelocity / param.acousticVelocity;
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;

%% 绘制多组压力脉动
if 0
fh = figureExpPressurePlus(dvCombineData,{'双罐'},'errorType',errorType...
    ,'rang',1:15 ...
    );
end

%% 理论模拟实验
if 0
	paperPlotExpSimTheDoubleVessel(param,isSaveFigure);
end

%% 理论分析
if 0
	paperPlotTheDoubleVessel(param,isSaveFigure);
end

if 1
	paperPlotDoubleVesselTheFrequencyResponse(param,isSaveFigure);
end


if 0
	dataPath = fullfile(dataPath,'模拟数据\扫频数据\入口0.2kgs质量流量出口压力\扫频-双容罐二弯头');
	figureSimFrequencyResponse(dataPath,[],'type','contourf');
    xlim([0,50]);
end









