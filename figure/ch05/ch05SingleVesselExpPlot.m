%% ������ ��ͼ - ��һ�����
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
isSaveFigure = 1;
%% ����·��
if 0
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
    legendLabels = {'��ǰ��ֱ��(A)','��ǰ����ǰ��(B)','��ǰ������(C)','ֱ����ǰ��(D)','ֱ������(E)','ֱ��ֱ��(F)'};
    legendLabelsAbb = {'A','B','C','D','E','F'};
else
    vesselSideFontInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\RPM420');%��ǰ��ֱ���
    vesselSideFontInSideBackOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\���޲�ǰ������420ת0.05mpa');
    vesselDirectInSideFontOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ����ǰ��420ת0.05mpa');
    vesselDirectInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ��ֱ��420ת0.05mpaModify');
    %% ���ػ��������
    [vesselSideFontInDirectOutDataCells,vesselSideFontInDirectOutCombineData] ...
        = loadExpDataFromFolder(vesselSideFontInDirectOutCombineDataPath);
    [vesselSideFontInSideBackOutDataCells,vesselSideFontInSideBackOutCombineData] ...
        = loadExpDataFromFolder(vesselSideFontInSideBackOutCombineDataPath);
    [vesselDirectInSideFontOutDataCells,vesselDirectInSideFontOutCombineData] ...
        = loadExpDataFromFolder(vesselDirectInSideFontOutCombineDataPath);
    [vesselDirectInDirectOutDataCells,vesselDirectInDirectOutCombineData] ...
        = loadExpDataFromFolder(vesselDirectInDirectOutCombineDataPath);

    %����޲�ͬ�ӷ���ʵ������
    vesselCombineDataCells = {vesselSideFontInDirectOutCombineData...
        ,vesselSideFontInSideBackOutCombineData...
        ,vesselDirectInSideFontOutCombineData...
        ,vesselDirectInDirectOutCombineData...
        };
    %ʵ���������һ������ֵ
    legendLabels = {'��ǰ��ֱ��(A)','��ǰ������(B)','ֱ����ǰ��(C)','ֱ��ֱ��(D)'};
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


%% ���ƶ���ѹ���������Ա�ͼ
if 0
	paperPlotSingleVesselExpResult(vesselCombineDataCells,legendLabels,legendLabelsAbb,isSaveFigure);
end

%����0.25D��ѹ������������
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% ���ƶ���ѹ������������
if 0
    vesselSuppressionRateCells = {vesselSideFontInDirectOutCombineData...
        ,vesselSideFontInSideBackOutCombineData...
        ,vesselDirectInSideFontOutCombineData...
        };
    legendSuppressionRateLabels = {'��ǰ��ֱ��(A)','��ǰ������(B)','ֱ����ǰ��(C)'};
    paperPlotSingleVesselExpSuppressionRateResult(vesselDirectInDirectOutCombineData...
        ,vesselSuppressionRateCells...
        ,legendSuppressionRateLabels...
        ,isSaveFigure...
        );
end
%% ���ƶ���ѹ����
if 1
    fh = figureExpPressureDrop(vesselCombineDataCells,legendLabels,pressureDropMeasureRang...
		,'chartType','bar');
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

if 0
	dataPath = fullfile(dataPath,'ģ������\ɨƵ����\���0.2kgs������������ѹ��\ɨƵ-ֱ����ǰ������');
	figureSimFrequencyResponse(dataPath,[],'type','contourf');
    xlim([0,50]);
end