%% 第五章 绘图 - 单一缓冲罐
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
isSaveFigure = false;
%% 数据路径
vesselSideFontInDirectOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\RPM420');%侧前进直后出
vesselSideFontInSideFontOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐侧前进侧前出420转0.05mpa');
vesselSideFontInSideBackOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐侧前进侧后出420转0.05mpa');
vesselDirectInSideFontOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进侧前出420转0.05mpa');
vesselDirectInSideBackOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进侧后出420转0.05mpa');
vesselDirectInDirectOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进直出420转0.05mpaModify');
%% 加载缓冲罐数据
[vesselSideFontInDirectOutDataCells,vesselSideFontInDirectOutCombineData] ...
    = loadExpDataFromFolder(vesselSideFontInDirectOutCombineDataPath);
[vesselSideFontInSideFontOutDataCells,vesselSideFontInSideFontOutCombineData] ...
    = loadExpDataFromFolder(vesselSideFontInSideFontOutCombineDataPath);
[vesselSideFontInSideBackOutDataCells,vesselSideFontInSideBackOutCombineData] ...
    = loadExpDataFromFolder(vesselSideFontInSideBackOutCombineDataPath);
[vesselDirectInSideFontOutDataCells,vesselDirectInSideFontOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInSideFontOutCombineDataPath);
[vesselDirectInSideBackOutDataCells,vesselDirectInSideBackOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInSideBackOutCombineDataPath);
[vesselDirectInDirectOutDataCells,vesselDirectInDirectOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInDirectOutCombineDataPath);

%缓冲罐不同接法的实验数据
vesselCombineDataCells = {vesselSideFontInDirectOutCombineData...
    ,vesselSideFontInSideFontOutCombineData...
    ,vesselSideFontInSideBackOutCombineData...
    ,vesselDirectInSideFontOutCombineData...
    ,vesselDirectInSideBackOutCombineData...
    ,vesselDirectInDirectOutCombineData...
    };
%实验数据最后一个测点的值

vesselDiffLinkLastMeasureMeanValues = cellfun(@(x) mean(x.readPlus(:,13)),vesselCombineDataCells,'UniformOutput',1);
vesselDiffLinkLastMeasureMeanValuesUp = vesselDiffLinkLastMeasureMeanValues;
vesselDiffLinkLastMeasureMeanValuesDown = vesselDiffLinkLastMeasureMeanValues;
for i=1:length(vesselCombineDataCells)
    [~,~,muci,sigmaci] = normfit(vesselCombineDataCells{i}.readPlus(:,13),0.05);
    vesselDiffLinkLastMeasureMeanValuesUp(i) = muci(2,1);
    vesselDiffLinkLastMeasureMeanValuesDown(i) = muci(1,1);
end



legendLabels = {'侧前进直出(A)','侧前进侧前出(B)','侧前进侧后出(C)','直进侧前出(D)','直进侧后出(E)','直进直出(F)'};
legendLabelsAbb = {'A','B','C','D','E','F'};
pressureDropMeasureRang = cellfun(@(x) [2,3],legendLabels,'UniformOutput',0);
pressureDropMeasureRang{end} = [2,4];
%% 分析参数设置
%时频分析参数设置
Fs = 100;%实验采样率
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
%% 绘图 
%% [1,3,5,7,9,13]测点的时频分析波形
if 0
    dataNumIndex = 2;%读取的实验组数，<5
    measurePoint = [1,3,5,7,9,13];%时频分析波形的测点
    stftLabels = {};
    for i = 1:length(measurePoint)
        stftLabels{i} = sprintf('测点%d',measurePoint(i));
    end
    fh = figureExpPressureSTFT(getExpDataStruct(vesselSideFontInDirectOutDataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(vesselSideFontInSideFontOutDataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(vesselSideFontInSideBackOutDataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(vesselDirectInSideFontOutDataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(vesselDirectInSideBackOutDataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(vesselDirectInDirectOutDataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
end
%绘制0.25D的压力脉动
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% 绘制多组压力脉动
if 1
	paperPlotSingleVesselExpResult(vesselCombineDataCells,legendLabels,isSaveFigure);
    % fh = figureExpPressurePlus(vesselCombineDataCells,legendLabels...
        % ,'errorType','none'...
        % ,'showPureVessel',0);
    % set(fh.legend,...
        % 'Position',[0.197702551027417 0.469635426128899 0.282222217491105 0.346163184982204]);
    % set(fh.textarrowVessel,'X',[0.230711805555556 0.294722222222223],'Y',[0.277213541666667 0.231744791666667]);
    % annotation(fh.gcf,'ellipse',...
        % [0.857892361111112 0.674088541666667 0.0430972222222221 0.171979166666667]);
    % annotation(fh.gcf,'arrow',[0.865638766519824 0.814977973568282],...
        % [0.675567656765677 0.564356435643564]);
    % set(gca,'color','none');
    % ax = axes('Parent',fh.gcf...
        % ,'Position',[0.618767361111111 0.257369791666667 0.275208333333337 0.29765625]...
        % ,'color','w');
    % box(ax,'on');
    % err = [vesselDiffLinkLastMeasureMeanValues'-vesselDiffLinkLastMeasureMeanValuesDown'...
        % ,vesselDiffLinkLastMeasureMeanValuesUp'-vesselDiffLinkLastMeasureMeanValues'];
    % barHandle = barwitherr(err,vesselDiffLinkLastMeasureMeanValues');
    % ylim([30,40]);
    % xlim([0,7]);
    % set(barHandle,'FaceColor',getPlotColor(1));
    % set(ax,'XTickLabel',legendLabelsAbb);
    % set(gca,'color','none');
    % saveFigure(fullfile(getPlotOutputPath(),'ch05'),'缓冲罐不同接法对管系气流脉动的影响');
end
%绘制0.25D的压力脉动抑制率
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% 绘制多组压力脉动抑制率
if 0
    dataCells = {vesselSideFontInDirectOutCombineData...
        ,vesselSideFontInSideFontOutCombineData...
        ,vesselSideFontInSideBackOutCombineData...
        ,vesselDirectInSideFontOutCombineData...
        ,vesselDirectInSideBackOutCombineData...
        };
    ddMean = mean(vesselDirectInDirectOutCombineData.readPlus);
    ddMean = ddMean(1:13);
    suppressionRateBase = {ddMean};
    legendText = {'侧前进直出(A)','侧前进侧前出(B)','侧前进侧后出(C)','直进侧前出(D)','直进侧后出(E)'};;
    xlabelText = '距离';
    ylabelText = '脉动抑制率(%)';

    fh = figureExpPressurePlusSuppressionRate(dataCells...
            ,legendText...        
            ,'errorDrawType','bar'...
            ,'showVesselRigon',0 ...
            ,'suppressionRateBase',suppressionRateBase...
            ,'xIsMeasurePoint',0 ...
            ,'figureHeight',8 ...
            ,'xlabelText',xlabelText...
            ,'ylabelText',ylabelText...
            );
    set(fh.legend,...
        'Position',[0.62103588547782 0.561137160662973 0.319704855262923 0.291041658781467]);
    %set(gca,'color','none');
    
end
%% 绘制多组压力降
if 0
    
    fh = figureExpPressureDrop(vesselCombineDataCells,legendLabels,pressureDropMeasureRang,'chartType','bar');
    %'chartType'== 'bar' 时用于设置bar的颜色
    set(fh.barHandle,'FaceColor',getPlotColor(1));
    set(fh.gca,'XTickLabelRotation',30);
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'缓冲罐不同接法的压力降');
end
%对测点1进行时频分析波形
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%绘制1倍频的对比
%% 绘制倍频
if 0
    fh = figureExpNatureFrequencyBar(vesselCombineDataCells,1,legendLabels);
    fh = figureExpNatureFrequencyBar(vesselCombineDataCells,2,legendLabels);
    fh = figureExpNatureFrequencyBar(vesselCombineDataCells,3,legendLabels);
end
