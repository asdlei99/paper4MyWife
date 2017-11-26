%% 第六章 绘图 - 内插管相关绘图
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
expVesselRang = [3.75,4.5];
%% 数据路径
innerPipeD0_5CombineDataPath = fullfile(dataPath,'实验原始数据\内插管\内插管0.5D中间420转0.05mpa');
innerPipeD0_75CombineDataPath = fullfile(dataPath,'实验原始数据\内插管\内插管0.75D中间420转0.06mpa');
innerPipeD1CombineDataPath = fullfile(dataPath,'实验原始数据\内插管\内插管1D罐中间420转0.05mpa');
vesselCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\RPM420');
%% 加载内插管以及缓冲罐数据
%0.5D,0.75D,1D孔板的实验模拟数据

[expInnerPipe0_5DataCells,expInnerPipe0_5CombineData,simInnerPipe0_5DataCell] ...
    = loadExpAndSimDataFromFolder(innerPipeD0_5CombineDataPath);
[expInnerPipe0_75DataCells,expInnerPipe0_75CombineData] ...
    = loadExpDataFromFolder(innerPipeD0_75CombineDataPath);
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
innerPipeDataCells = {expInnerPipe0_5CombineData,expInnerPipe0_75CombineData,expInnerPipe01CombineData};
legendLabels = {'0.5D','0.75D','1D'};
%% 分析参数设置
%时频分析参数设置
Fs = 100;%实验采样率
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
%% 绘制多组压力脉动
if 1
    fh = figureExpPressurePlus(innerPipeDataCells,legendLabels,'errorType',errorType...
        ,'showPureVessel',1,'purevessellegend','单一缓冲罐'...
        ,'expVesselRang',expVesselRang);
    set(fh.vesselHandle,'color','r');
    set(fh.textarrowVessel,'X',[0.391 0.341],'Y',[0.496 0.417]);
    set(fh.legend,'Position',[0.140376161350008 0.518142368996306 0.255763884946291 0.291041658781467]);
end
%% 绘制理论模拟实验
if 0
    legendText = {'单一缓冲罐','内插管缓冲罐'};
    x = constExpMeasurementPointDistance();%测点对应的距离
    xExp = {x,x};
    x = constSimMeasurementPointDistance();%模拟测点对应的距离
    xSim = {x,x};
    xThe = {param.X,theDataCells{3, 3}};
    
    vesselInBiasResultCell.pulsationValue(1:8) = vesselInBiasResultCell.pulsationValue(1:8) + ones(1,8).*6e3;
    theDataCells{3, 2}.pulsationValue(1:8) = theDataCells{3, 2}.pulsationValue(1:8) + ones(1,8).*6e3;
    
    fh = figureExpAndSimThePressurePlus({expVesselCombineData,expOrificD0_5CombineData}...
                            ,{simVesselDataCell,simOrificD0_5DataCell}...
                            ,{vesselInBiasResultCell,theDataCells{3, 2}}...
                            ,legendText...
                            ,'showMeasurePoint',1 ...
                            ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                            ,'showVesselRigion',1,'ylim',[0,40]...
                            ,'xlim',[2,12]...
                            ,'figureHeight',9 ...
                            ,'expVesselRang',expVesselRang);
    set(fh.legend,'Position',[0.12935185921137 0.520347230633097 0.37041665930715 0.307700608873072]);
    set(fh.textarrowVessel,'X',[0.336545138888889 0.30795138888889],'Y',[0.440439814814815 0.391597222222223]);
end


%% 绘制多组压力脉动抑制率
if 1
    fh = figureExpSuppressionLevel(innerPipeDataCells,legendLabels,'errorType',errorType...
        ,'expVesselRang',expVesselRang...
    );
    set(fh.legend,...
        'Position',[0.140376159707257 0.618463546693475 0.200642358811262 0.190720481084297]);
    set(fh.textarrow,...
        'X',[0.303472222222222 0.314496527777778],'Y',[0.545104166666667 0.4525]);
end
%% 绘制多组压力降
if 1
    fh = figureExpPressureDrop(innerPipeDataCells,legendLabels,[2,3],'chartType','bar');
    %'chartType'== 'bar' 时用于设置bar的颜色
    set(fh.barHandle,'FaceColor',getPlotColor(1));
end
%对测点1进行时频分析波形
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%绘制1倍频的对比
%% 绘制倍频
if 1
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,1,legendLabels);
    set(fh.legend,'Location','northwest');
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,2,legendLabels);
    set(fh.legend,...
    'Position',[0.546070604348832 0.612951407221974 0.207256941947465 0.280752307323877]);
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,3,legendLabels);
end

%% 理论扩展分析
%无明显变化
if 0
    resCell = innerOrificTankChangLv1(0.5);
    figure
    for i = 2:size(resCell,1)
        if 2 == i
            hold on;
        end
        plot(resCell{i,3},resCell{i, 2}.pulsationValue);
        
    end
end
