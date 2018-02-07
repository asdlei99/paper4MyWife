%% 第六章 绘图 - 内置孔管相关绘图
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
isSaveFigure = 0;
dataPath = getDataPath();
theoryOnly = 1;
%% 数据路径
if ~theoryOnly
	perforateN20DataPath = fullfile(dataPath,'实验原始数据\内插孔管\D0.5N20RPM420两头堵');
	perforateN36DataPath = fullfile(dataPath,'实验原始数据\内插孔管\D0.5N36RPM420两头堵');
	perforateN68DataPath = fullfile(dataPath,'实验原始数据\内插孔管\D0.5N68RPM420两头堵');
	vesselDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\RPM420');
	[expPerforateN20DataCells,expPerforateN20CombineData,simPerforateN20DataCell] ...
		= loadExpAndSimDataFromFolder(perforateN20DataPath);
	[expPerforateN36DataCells,expPerforateN36CombineData,simPerforateN36DataCell] ...
		= loadExpAndSimDataFromFolder(perforateN36DataPath);
	[expPerforateN68DataCells,expPerforateN68CombineData,simPerforateN68DataCell] ...
		= loadExpAndSimDataFromFolder(perforateN68DataPath);
    %单一缓冲罐数据
    [expVesselDataCells,expVesselCombineData,simVesselDataCell] ...
        = loadExpAndSimDataFromFolder(vesselDataPath);
	perforatePipeCombineDataCells = {expPerforateN20CombineData,expPerforateN36CombineData,expPerforateN68CombineData};
	legendLabels = {'N24','N40','N72'};
	expRawDataCells = {expPerforateN20DataCells{2,2}.rawData,expPerforateN36DataCells{2,2}.rawData,expPerforateN68DataCells{2,2}.rawData};
    expCombineDataCells = {expPerforateN20CombineData,expPerforateN36CombineData,expPerforateN68CombineData};
    %模拟数据的修正
    xSim = constSimMeasurementPointDistance();
    index = find(xSim < 2.5);
    simPerforateN20DataCell.rawData.pulsationValue(index) = nan;
    simPerforateN36DataCell.rawData.pulsationValue(index) = nan;
    simPerforateN68DataCell.rawData.pulsationValue(index) = nan;
    
    n20SimY = [nan,nan,nan,nan,8.7357,8.56085,7.89048,2.65308,3.5774,4.80772,5.28376,6.98776,8.21878,9.38138,10.3945,11.2395,11.892,12.3366,12.5647];
    simPerforateN20DataCell.rawData.pulsationValue=n20SimY;
    simDataCells = {simPerforateN20DataCell,simPerforateN36DataCell,simPerforateN68DataCell};
end
%% 绘制多组压力脉动
if 0 && ~theoryOnly
	paperPlotPerforatePipeExpCmp(perforatePipeCombineDataCells,legendLabels,isSaveFigure)
end

%% 绘制频率分布图
if 0 && ~theoryOnly
	paperPlotPerforateSpectrum3D(expRawDataCells,legendLabels,isSaveFigure);
end



%% 数据路径
%缓冲罐中间插入孔管,两端堵死，开孔个数不足以等效为亥姆霍兹共鸣器,缓冲罐入口偏置
%                 L1
%                     |
%                     |
%           l   LBias |                                    L2  
%              _______|_________________________________        
%             |    dp(n1)            |    dp(n2)        |
%             |           ___ _ _ ___|___ _ _ ___ lc    |     
%             |          |___ _ _ ___ ___ _ _ ___|Din   |----------
%             |           la1 lp1 la2|lb1 lp2 lb2       |
%             |______________________|__________________|       
%                             Lin         Lout          l
%                       Lv1                  Lv2
%    Dpipe                       Dv                     Dpipe  
%              
%           
%
% Lin 内插孔管入口段长度 
% Lout内插孔管出口段长度
% lc  孔管壁厚
% dp  孔管每一个孔孔径
% n1  孔管入口段开孔个数；    n2  孔管出口段开孔个数
% la1 孔管入口段距入口长度 
% la2 孔管入口段距隔板长度
% lb1 孔管出口段距隔板长度
% lb2 孔管出口段距开孔长度
% lp1 孔管入口段开孔长度
% lp2 孔管出口段开孔长度
% Din 孔管管径；
% xSection1，xSection2 孔管每圈孔的间距，从0开始算，x的长度为孔管孔的圈数+1，x的值是当前一圈孔和上一圈孔的距离，如果间距一样，那么x里的值都一样
param.acousticVelocity = 345;%声速（m/s）
param.isDamping = 1;
param.coeffFriction = 0.01;
param.meanFlowVelocity = 10;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.l  =  0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;%缓冲罐的直径（m）
param.Lv1 = 1.1/2;%缓冲罐腔1总长
param.Lv2 =  1.1/2;

param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%管道直径（m）
param.Lbias = 0.168+0.150;
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2];
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
%
param.lc   = 0.005;%内插管壁厚
param.dp1  = 0.013;%开孔径
param.dp2  = 0.013;%开孔径
param.lp1  = 0.16;%内插管入口段孔管开孔长度
param.lp2  = 0.16;%内插管出口段孔管开孔长度
param.n1   = 24;%入口段孔数
param.n2   = 24;%出口段孔数
param.la1  = 0.03;%孔管入口段靠近入口长度
param.la2  = 0.06;
param.lb1  = 0.06;
param.lb2  = 0.03;
param.Din  = 0.049;
param.Lout = param.lb1 + param.lp2+ param.lb2;%内插管入口段长度
param.bp1 = calcPerforatingRatios(param.n1,param.dp1,param.Din,param.lp1);
param.bp2 = calcPerforatingRatios(param.n2,param.dp2,param.Din,param.lp2);
param.Lin  = param.la1 + param.lp1+ param.la2;%内插管入口段长度
param.LBias = (0.150+0.168);%缓冲罐偏置距离
param.Dbias = 0;%无内插管
param.sectionNum1 = [1];%对应孔1的组数
param.sectionNum2 = [1];%对应孔2的组数
param.xSection1 = [0,ones(1,param.sectionNum1).*(param.lp1/(param.sectionNum1))];
param.xSection2 = [0,ones(1,param.sectionNum2).*(param.lp2/(param.sectionNum2))];


if 0 && ~theoryOnly
	paperPlotPerforatePipeExpSimThe(param,expCombineDataCells,simDataCells,isSaveFigure);
end

if 0
	paperPlotPerforatePipeTheory(param,isSaveFigure)
end

if 1
	paperPlotPerforateTheoryFrequencyResponse(param,isSaveFigure);
end





