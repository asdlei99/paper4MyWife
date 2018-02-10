%% 第八章 绘图 - 应用-添加内置孔管相关绘图
%第八章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
isSaveFigure = 0;
dataPath = getDataPath();
theoryOnly = 1;

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
param.L1 = 0.1;%(m)
param.L2 = 5;
param.L3 = 8.5;
param.L4 = 0.2;
param.l  =  0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;%缓冲罐的直径（m）
param.Dv1 = 0.5;%缓冲罐的直径（m）
param.Dv2 = 0.372;%缓冲罐的直径（m）
param.LV2_1 = 1.1/2;%缓冲罐腔1总长
param.LV2_2 =  1.1/2;
param.LV1 = 1.1;%缓冲罐腔1总长
param.LV3 =  1.1;

param.sectionL1 = 0:0.05:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.05:param.L2;%linspace(0,param.L2,14);
param.sectionL3 = 0:0.05:param.L3;%linspace(0,param.L3,14);
param.sectionL4 = 0:0.05:param.L4;%linspace(0,param.L4,14)
param.Dpipe = 0.098;%管道直径（m）
param.Lbias = 0.168+0.150;
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
param.Din  = 0.098;
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
param.pressureBoundary2 = 0;



if 1
	paperPlotFacPerforatePipeTheory(param,isSaveFigure);
end

if 0
	paperPlotPerforateTheoryFrequencyResponse(param,isSaveFigure);
end

if 0
	dataPath = fullfile(dataPath,'模拟数据\扫频数据\入口0.2kgs质量流量出口压力\扫频-内插孔管单侧16个孔0.5d');
	figureSimFrequencyResponse(dataPath,[],'type','contourf');
    xlim([0,50]);
end



