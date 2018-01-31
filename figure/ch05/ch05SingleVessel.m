%% ������ ��ͼ - ��һ�����
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
isSaveFigure = false;
%% ����·��
vesselSideFontInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\RPM420');%��ǰ��ֱ���
vesselSideFontInSideFontOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\���޲�ǰ����ǰ��420ת0.05mpa');
vesselSideFontInSideBackOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\���޲�ǰ������420ת0.05mpa');
vesselDirectInSideFontOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ����ǰ��420ת0.05mpa');
vesselDirectInSideBackOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ������420ת0.05mpa');
vesselDirectInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ��ֱ��420ת0.05mpaModify');
%% ���ػ��������
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

%����޲�ͬ�ӷ���ʵ������
vesselCombineDataCells = {vesselSideFontInDirectOutCombineData...
    ,vesselSideFontInSideFontOutCombineData...
    ,vesselSideFontInSideBackOutCombineData...
    ,vesselDirectInSideFontOutCombineData...
    ,vesselDirectInSideBackOutCombineData...
    ,vesselDirectInDirectOutCombineData...
    };
%ʵ���������һ������ֵ

vesselDiffLinkLastMeasureMeanValues = cellfun(@(x) mean(x.readPlus(:,13)),vesselCombineDataCells,'UniformOutput',1);
vesselDiffLinkLastMeasureMeanValuesUp = vesselDiffLinkLastMeasureMeanValues;
vesselDiffLinkLastMeasureMeanValuesDown = vesselDiffLinkLastMeasureMeanValues;
for i=1:length(vesselCombineDataCells)
    [~,~,muci,sigmaci] = normfit(vesselCombineDataCells{i}.readPlus(:,13),0.05);
    vesselDiffLinkLastMeasureMeanValuesUp(i) = muci(2,1);
    vesselDiffLinkLastMeasureMeanValuesDown(i) = muci(1,1);
end



legendLabels = {'��ǰ��ֱ��(A)','��ǰ����ǰ��(B)','��ǰ������(C)','ֱ����ǰ��(D)','ֱ������(E)','ֱ��ֱ��(F)'};
legendLabelsAbb = {'A','B','C','D','E','F'};
pressureDropMeasureRang = cellfun(@(x) [2,3],legendLabels,'UniformOutput',0);
pressureDropMeasureRang{end} = [2,4];
%% ������������
%ʱƵ������������
Fs = 100;%ʵ�������
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
%% ��ͼ 
%% [1,3,5,7,9,13]����ʱƵ��������
if 0
    dataNumIndex = 2;%��ȡ��ʵ��������<5
    measurePoint = [1,3,5,7,9,13];%ʱƵ�������εĲ��
    stftLabels = {};
    for i = 1:length(measurePoint)
        stftLabels{i} = sprintf('���%d',measurePoint(i));
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
%����0.25D��ѹ������
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% ���ƶ���ѹ������
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
    % saveFigure(fullfile(getPlotOutputPath(),'ch05'),'����޲�ͬ�ӷ��Թ�ϵ����������Ӱ��');
end
%����0.25D��ѹ������������
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% ���ƶ���ѹ������������
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
    legendText = {'��ǰ��ֱ��(A)','��ǰ����ǰ��(B)','��ǰ������(C)','ֱ����ǰ��(D)','ֱ������(E)'};;
    xlabelText = '����';
    ylabelText = '����������(%)';

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
%% ���ƶ���ѹ����
if 0
    
    fh = figureExpPressureDrop(vesselCombineDataCells,legendLabels,pressureDropMeasureRang,'chartType','bar');
    %'chartType'== 'bar' ʱ��������bar����ɫ
    set(fh.barHandle,'FaceColor',getPlotColor(1));
    set(fh.gca,'XTickLabelRotation',30);
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'����޲�ͬ�ӷ���ѹ����');
end
%�Բ��1����ʱƵ��������
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%����1��Ƶ�ĶԱ�
%% ���Ʊ�Ƶ
if 0
    fh = figureExpNatureFrequencyBar(vesselCombineDataCells,1,legendLabels);
    fh = figureExpNatureFrequencyBar(vesselCombineDataCells,2,legendLabels);
    fh = figureExpNatureFrequencyBar(vesselCombineDataCells,3,legendLabels);
end
