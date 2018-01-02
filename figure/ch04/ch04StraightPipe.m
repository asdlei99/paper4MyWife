%% 第四章 绘图 - 直管

clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 数据路径
straightPipeDataPath = fullfile(dataPath,'实验原始数据\纯直管\RPM420-0.1MPa');%直管

%% 加载数据
[straightPipeDataCells,straightPipeCombineData] ...
    = loadExpDataFromFolder(straightPipeDataPath);


legendLabels = {'直管'};

%% 绘图 
isSavePlot = 1;

%% 绘制压力波和频率
if 0
 	paperPlot04StraightPipePressureAndFrequency(straightPipeDataCells{1,2}.subSpectrumData,isSavePlot);
end
%% 绘制所有测点的时频分析
if 1
    paperPlot04StraightPipeSTFT(straightPipeDataCells{1,2}.rawData,isSavePlot);
end

%% 扫频数据分析
if 0
	paperPlot04StraightPipeSweepFrequency(isSavePlot);
end


if 0
    fh = figureExpPressurePlus(straightPipeCombineData...
        ,'errorType','ci'...
        ,'showPureVessel',0);
    % set(fh.legend,...
    %     'Position',[0.197702551027417 0.469635426128899 0.282222217491105 0.346163184982204]);
    % set(fh.textarrowVessel,'X',[0.230711805555556 0.294722222222223],'Y',[0.277213541666667 0.231744791666667]);
    % annotation(fh.gcf,'ellipse',...
    %     [0.857892361111112 0.674088541666667 0.0430972222222221 0.171979166666667]);
    % annotation(fh.gcf,'arrow',[0.865638766519824 0.814977973568282],...
    %     [0.675567656765677 0.564356435643564]);
    % ax = axes('Parent',fh.gcf...
    %     ,'Position',[0.618767361111111 0.257369791666667 0.275208333333337 0.29765625]...
    %     ,'color','w');
    % box(ax,'on');
    % err = [vesselDiffLinkLastMeasureMeanValues'-vesselDiffLinkLastMeasureMeanValuesDown'...
    %     ,vesselDiffLinkLastMeasureMeanValuesUp'-vesselDiffLinkLastMeasureMeanValues'];
    % barHandle = barwitherr(err,vesselDiffLinkLastMeasureMeanValues');
    % ylim([30,40]);
    % xlim([0,7]);
    % set(barHandle,'FaceColor',getPlotColor(1));
    % set(ax,'XTickLabel',legendLabelsAbb);
end

%对测点1进行时频分析波形
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%绘制1倍频的对比
%% 绘制倍频
if 0
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,1,legendLabels);
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,2,legendLabels);
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,3,legendLabels);
end
