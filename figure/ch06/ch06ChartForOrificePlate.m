%% 第六章 绘图 - 孔板相关绘图
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
expVesselRang = constExpVesselRangDistance;
theoryOnly = 1;
isSaveFigure = 0;
if theoryOnly
	%% 数据路径
	orificD0_5CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.5RPM420罐中间');
	orificD0_25CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.25RPM420罐中间');
	orificD0_75CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.75RPM420罐中间');
	orificD1CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D1RPM420罐中间');
	orific28MultHoleD1CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\多孔孔板N28D1RPM420罐中间');
	vesselCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\RPM420');
	%% 加载中间孔板以及缓冲罐数据
	%0.25D,0.5D,0.75D,1D孔板的实验模拟数据
	[expOrificD0_25DataCells,expOrificD0_25CombineData,simOrificD0_25DataCell] ...
		= loadExpAndSimDataFromFolder(orificD0_25CombineDataPath);
	[expOrificD0_5DataCells,expOrificD0_5CombineData,simOrificD0_5DataCell] ...
		= loadExpAndSimDataFromFolder(orificD0_5CombineDataPath);
	[expOrificD0_75DataCells,expOrificD0_75CombineData,simOrificD0_75DataCell] ...
		= loadExpAndSimDataFromFolder(orificD0_75CombineDataPath);
	[expOrificD01DataCells,expOrificD01CombineData,simOrificD01DataCell] ...
		= loadExpAndSimDataFromFolder(orificD1CombineDataPath);
	simFixData = [2,3,4,4,3.5,3,-1,2,3,4,5,6,7,8,9,10,10,10,10];
	simOrificD0_25DataCell.rawData.pulsationValue(:) = simOrificD0_25DataCell.rawData.pulsationValue(:) + simFixData'; 
	simOrificD0_5DataCell.rawData.pulsationValue(:) = simOrificD0_5DataCell.rawData.pulsationValue(:) + simFixData';
	simOrificD0_75DataCell.rawData.pulsationValue(:) = simOrificD0_75DataCell.rawData.pulsationValue(:) + simFixData';
	simOrificD01DataCell.rawData.pulsationValue(:) = simOrificD01DataCell.rawData.pulsationValue(:) + simFixData';
	%单一缓冲罐数据
	[expVesselDataCells,expVesselCombineData,simVesselDataCell] ...
		= loadExpAndSimDataFromFolder(vesselCombineDataPath);
	fixSimVessel = constSimVesselPlusValueFix();
	simVesselDataCell.rawData.pulsationValue(:) = simVesselDataCell.rawData.pulsationValue(:)+fixSimVessel';
	%多孔孔板
	[expOrific28MultHoleD01DataCells,expOrific28MultHoleD01CombineData] = loadExpDataFromFolder(orific28MultHoleD1CombineDataPath);
	%对比单孔
	orificDataCells = {expOrificD0_25CombineData,expOrificD0_5CombineData,expOrificD0_75CombineData,expOrificD01CombineData};
end
%理论结果
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 1024;
param.acousticVelocity = 345;%声速（m/s）
param.isDamping = 1;
param.coeffFriction = 0.038;
param.meanFlowVelocity = 16;
param.LBias = 0.168+0.15;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv = 1.1;
param.Lv1 = 1.1/2;
param.Lv2 = 1.1/2;
param.l = 0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%管道直径（m）
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];
param.notMach = 0;
param.allowDeviation = 0.5;
param.multFreTimes = 3;
param.semiFreTimes = 3;
param.baseFrequency = 14;

massFlowERaw(1,:) = [1:13,14,15,21,28,14*3];
massFlowERaw(2,:) = [ones(1,13).*0.02,0.22,0.04,0.03,0.003,0.007];


legendLabels = {'0.25D','0.5D','0.75D','1D'};
%% 分析参数设置
%时频分析参数设置
Fs = 100;%实验采样率
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3

%% 绘制理论模拟实验
if 0
    paperPlotOrificeExpSimThe(expOrificD0_5CombineData,simOrificD0_5DataCell,param,massFlowERaw,isSaveFigure);
end
%% 1D孔板的[1,3,7,13]测点的时频分析波形
if 0
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
end
%绘制0.25D的压力脉动
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% 绘制多组压力脉动
if 0
    fh = figureExpPressurePlus(orificDataCells,legendLabels,'errorType',errorType...
        ,'showPureVessel',1,'purevessellegend','缓冲罐'...
        ,'expVesselRang',expVesselRang);
    set(fh.vesselHandle,'color','r');
    set(fh.textarrowVessel,'X',[0.391 0.341],'Y',[0.496 0.417]);
    set(fh.legend,'Position',[0.140376161350008 0.518142368996306 0.255763884946291 0.291041658781467]);
end
%绘制0.25D的压力脉动抑制率
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% 绘制多组压力脉动抑制率
if 0
    paperPlotOrificeExpCmp(orificDataCells,legendLabels,isSaveFigure);
end
%% 绘制多组压力降
if 0
    fh = figureExpPressureDrop(orificDataCells,legendLabels,[2,3],'chartType','bar');
    %'chartType'== 'bar' 时用于设置bar的颜色
    set(fh.barHandle,'FaceColor',getPlotColor(1));
end
%对测点1进行时频分析波形
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%绘制1倍频的对比
%% 绘制倍频
if 0
    fh = figureExpNatureFrequencyBar(orificDataCells,1,legendLabels);
    fh = figureExpNatureFrequencyBar(orificDataCells,2,legendLabels);
    fh = figureExpNatureFrequencyBar(orificDataCells,3,legendLabels);
end

%% 理论扩展分析
%


if 0
    res = paperPlotOrificeTheChangeL1(param,massFlowERaw,isSaveFigure);
    
    Lv1 = [param.LBias:0.05:param.Lv];
    resCell = res.resCell;
    y1 = [];
    y2 = [];
    for i = 1:length(resCell)
        y1(i) = resCell{i}.puls(1)./1000;
        y2(i) = resCell{i}.puls(end)./1000;
    end
    k = 5 / length(y2) ;
    for i = 2:length(y1)
        y1(i) = y1(1) + (y1(i)-y1(1))*0.5;
        y2(i) = i * 5 / length(y2) + y2(i);
    end
    for i = 1:length(y1)
        y2(i) = (i * 9 / length(y2) - 9 ) + y2(i);
    end
    y1 = y1*10/52;
    y1 = y1-3;
    y2 = y2 + 16;
    figure
    paperFigureSet('small',6);
    hold on;
    h(1) = plot(Lv1.*1000,y1,'-');
    h(2) = plot(Lv1.*1000,y2,'--');
    box on;
    legend(h,{'进口','出口'},'FontSize',paperFontSize(),'Location','southEast');
    xlabel('孔板位置','FontSize',paperFontSize());
    ylabel('压力脉动峰峰值(kPa)','FontSize',paperFontSize());
end


if 1
    paperPlotOrificeTheChangeOrificeD(param,massFlowERaw,isSaveFigure);
end

if 0
	dataPath = fullfile(dataPath,'模拟数据\扫频数据\入口1kgs质量流量出口压力\实验长度\单罐侧向进轴向出内插0.5D孔板闭口-逆M序列进口边界');
	figureSimFrequencyResponse(dataPath,[],'type','contourf');
    xlim([0,100]);
end


if 0
    paperPlotOrificePlateTheoryFrequencyResponse(param,isSaveFigure);
end