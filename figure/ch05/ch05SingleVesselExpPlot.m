%% 第五章 绘图 - 单一缓冲罐
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
isSaveFigure = 1;
%% 数据路径
if 0
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
    legendLabels = {'侧前进直出(A)','侧前进侧前出(B)','侧前进侧后出(C)','直进侧前出(D)','直进侧后出(E)','直进直出(F)'};
    legendLabelsAbb = {'A','B','C','D','E','F'};
else
    vesselSideFontInDirectOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\RPM420');%侧前进直后出
    vesselSideFontInSideBackOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐侧前进侧后出420转0.05mpa');
    vesselDirectInSideFontOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进侧前出420转0.05mpa');
    vesselDirectInDirectOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进直出420转0.05mpaModify');
    %% 加载缓冲罐数据
    [vesselSideFontInDirectOutDataCells,vesselSideFontInDirectOutCombineData] ...
        = loadExpDataFromFolder(vesselSideFontInDirectOutCombineDataPath);
    [vesselSideFontInSideBackOutDataCells,vesselSideFontInSideBackOutCombineData] ...
        = loadExpDataFromFolder(vesselSideFontInSideBackOutCombineDataPath);
    [vesselDirectInSideFontOutDataCells,vesselDirectInSideFontOutCombineData] ...
        = loadExpDataFromFolder(vesselDirectInSideFontOutCombineDataPath);
    [vesselDirectInDirectOutDataCells,vesselDirectInDirectOutCombineData] ...
        = loadExpDataFromFolder(vesselDirectInDirectOutCombineDataPath);

    %缓冲罐不同接法的实验数据
    vesselCombineDataCells = {vesselSideFontInDirectOutCombineData...
        ,vesselSideFontInSideBackOutCombineData...
        ,vesselDirectInSideFontOutCombineData...
        ,vesselDirectInDirectOutCombineData...
        };
    %实验数据最后一个测点的值
    legendLabels = {'侧前进直出(A)','侧前进侧后出(B)','直进侧前出(C)','直进直出(D)'};
    legendLabelsAbb = {'A','B','C','D'};
end

vesselDiffLinkLastMeasureMeanValues = cellfun(@(x) mean(x.readPlus(:,13)),vesselCombineDataCells,'UniformOutput',1);
vesselDiffLinkLastMeasureMeanValuesUp = vesselDiffLinkLastMeasureMeanValues;
vesselDiffLinkLastMeasureMeanValuesDown = vesselDiffLinkLastMeasureMeanValues;
for i=1:length(vesselCombineDataCells)
    [~,~,muci,sigmaci] = normfit(vesselCombineDataCells{i}.readPlus(:,13),0.05);
    vesselDiffLinkLastMeasureMeanValuesUp(i) = muci(2,1);
    vesselDiffLinkLastMeasureMeanValuesDown(i) = muci(1,1);
end




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


%% 绘制多组压力脉动及对比图
if 0
	paperPlotSingleVesselExpResult(vesselCombineDataCells,legendLabels,legendLabelsAbb,isSaveFigure);
end

%绘制0.25D的压力脉动抑制率
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% 绘制多组压力脉动抑制率
if 0
    vesselSuppressionRateCells = {vesselSideFontInDirectOutCombineData...
        ,vesselSideFontInSideBackOutCombineData...
        ,vesselDirectInSideFontOutCombineData...
        };
    legendSuppressionRateLabels = {'侧前进直出(A)','侧前进侧后出(B)','直进侧前出(C)'};
    paperPlotSingleVesselExpSuppressionRateResult(vesselDirectInDirectOutCombineData...
        ,vesselSuppressionRateCells...
        ,legendSuppressionRateLabels...
        ,isSaveFigure...
        );
end
%% 绘制多组压力降
if 1
    fh = figureExpPressureDrop(vesselCombineDataCells,legendLabels,pressureDropMeasureRang...
		,'chartType','bar');
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

if 0
	dataPath = fullfile(dataPath,'模拟数据\扫频数据\入口0.2kgs质量流量出口压力\扫频-直径侧前出单罐');
	figureSimFrequencyResponse(dataPath,[],'type','contourf');
    xlim([0,50]);
end