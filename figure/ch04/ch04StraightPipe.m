%% ������ ��ͼ - ֱ��

clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% ����·��
straightPipeDataPath = fullfile(dataPath,'ʵ��ԭʼ����\��ֱ��\RPM420-0.1MPa');%ֱ��

%% ��������
[straightPipeDataCells,straightPipeCombineData] ...
    = loadExpDataFromFolder(straightPipeDataPath);


legendLabels = {'ֱ��'};

%% ������������
%ʱƵ������������
Fs = 100;%ʵ�������
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
%% ��ͼ 
%% [1,3,5,7,9,13]����ʱƵ��������
if 1
    dataNumIndex = 2;%��ȡ��ʵ��������<5
    measurePoint = [1,3,5,7,9,13];%ʱƵ�������εĲ��
    stftLabels = {};
    for i = 1:length(measurePoint)
        stftLabels{i} = sprintf('���%d',measurePoint(i));
    end
    fh = figureExpPressureSTFT(getExpDataStruct(straightPipeDataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
end
if 1
    dataNumIndex = 2;%��ȡ��ʵ��������<5
    measurePoint = [1,13];%ʱƵ�������εĲ��
    stftLabels = {};
    for i = 1:length(measurePoint)
        stftLabels{i} = sprintf('���%d',measurePoint(i));
    end
    viewVal = [41,23];
    isShowColorBar = 0;
    fh = figureExpPressureSTFT(getExpDataStruct(straightPipeDataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',1,'subplotcol',2,'figureHeight',6 ...
        ,'chartType','plot3'...
        ,'view',viewVal...
        ,'isShowColorBar',isShowColorBar...
        ,'simpleLabel',0 ...
    );
end
%����0.25D��ѹ������
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% ���ƶ���ѹ������
if 1
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

%�Բ��1����ʱƵ��������
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%����1��Ƶ�ĶԱ�
%% ���Ʊ�Ƶ
if 1
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,1,legendLabels);
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,2,legendLabels);
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,3,legendLabels);
end
