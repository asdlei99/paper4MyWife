%% 第六章 绘图 - 孔板相关绘图
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
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
%单一缓冲罐数据
[expVesselDataCells,expVesselCombineData,simVesselDataCell] ...
    = loadExpAndSimDataFromFolder(vesselCombineDataPath);
%多孔孔板
[expOrific28MultHoleD01DataCells,expOrific28MultHoleD01CombineData] = loadExpDataFromFolder(orific28MultHoleD1CombineDataPath);
%对比单孔
orificDataCells = {expOrificD0_25CombineData,expOrificD0_5CombineData,expOrificD0_75CombineData,expOrificD01CombineData};
%理论结果
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 345;%声速（m/s）
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
param.LBias = 0.168+0.15;
param.Dbias = 0;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv = 1.1;
param.l = 0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%管道直径（m）
param.X = [param.sectionL1, param.sectionL1(end) + param.l + param.Lv - param.Dbias + param.sectionL2];
param.notMach = 0;
param.allowDeviation = 0.5;
param.multFreTimes = 3;
param.semiFreTimes = 3;
theDataCells = innerOrificTankChangD();
vesselInBiasResultCell = vesselInBiasPulsationResult('param',param);
legendLabels = {'0.25D','0.5D','0.75D','1D'};
%% 分析参数设置
%时频分析参数设置
Fs = 100;%实验采样率
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
%% 绘图 
hold on;
h(1) = plot(simOrificD01DataCell.rawData.pulsationValue);
h(2) =plot(simOrificD0_25DataCell.rawData.pulsationValue);
h(3) =plot(simOrificD0_5DataCell.rawData.pulsationValue);
h(4) =plot(simOrificD0_75DataCell.rawData.pulsationValue);
h(5) =plot(simVesselDataCell.rawData.pulsationValue);
legend(h,{'1D','0.25D','0.5D','0.75D','vessel'});
%% 绘制理论模拟实验
if 0
    legendText = {'单一缓冲罐','内置孔板缓冲罐'};
    x = constExpMeasurementPointDistance();%测点对应的距离
    xExp = {x,x};
    xSim = {...
        [];
        [0.5,1,1.5,2,2.5,3,3.5,4.802,5.302,5.802,6.302,6.802,7.302,7.802,8.302,8.802,9.302,9.802,10.302] ...%孔板模拟的x尺寸
    };
    xThe = {param.X,theDataCells{3, 3}};
    fh = figureExpAndSimThePressurePlus({expVesselCombineData,expOrificD0_5CombineData}...
                            ,{simVesselDataCell,simOrificD0_5DataCell}...
                            ,{vesselInBiasResultCell,theDataCells{3, 2}}...
                            ,legendText...
                            ,'showMeasurePoint',0 ...
                            ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                            ,'expRang',expRang,'simRang',simRang...
                            ,'showVesselRigion',0,'ylim',[0,40]...
                            ,'xlim',[2,12]);
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
        ,'showPureVessel',1,'purevessellegend','单一缓冲罐');
    set(fh.vesselHandle,'color','r');
end
%绘制0.25D的压力脉动抑制率
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% 绘制多组压力脉动抑制率
if 0
    fh = figureExpSuppressionLevel(orificDataCells,legendLabels,'errorType',errorType...
        ,'yfilterfunptr',@fixInnerOrificY ...
    );
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