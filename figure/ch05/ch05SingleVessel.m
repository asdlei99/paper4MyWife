%% ������ ��ͼ - ��һ�����
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% ����·��
vesselSideFontInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\RPM420');%��ǰ��ֱ���
vesselSideFontInSideFontOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\���޲�ǰ����ǰ��420ת0.05mpa');
vesselSideFontInSideBackOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\���޲�ǰ������420ת0.05mpa');
vesselDirectInSideFontOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ����ǰ��420ת0.05mpa');
vesselDirectInSideBackOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ������420ת0.05mpa');
vesselDirectInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ��ֱ��420ת0.05mpa');
%% �����м�װ��Լ����������
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

%�Աȵ���
vesselCombineDataCells = {vesselSideFontInDirectOutCombineData...
    ,vesselSideFontInSideFontOutCombineData...
    ,vesselSideFontInSideBackOutCombineData...
    ,vesselDirectInSideFontOutCombineData...
    ,vesselDirectInSideBackOutCombineData...
    ,vesselDirectInDirectOutCombineData...
    };
legendLabels = {'��ǰ��ֱ��','��ǰ����ǰ��','��ǰ������','ֱ����ǰ��','ֱ������','ֱ��ֱ��'};
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
fh = figureExpPressurePlus(vesselCombineDataCells,legendLabels,'errorType',errorType...
    ,'showPureVessel',0);

%����0.25D��ѹ������������
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% ���ƶ���ѹ������������
%% ���ƶ���ѹ����
fh = figureExpPressureDrop(vesselCombineDataCells,legendLabels,[2,3],'chartType','bar');
%'chartType'== 'bar' ʱ��������bar����ɫ
set(fh.barHandle,'FaceColor',getPlotColor(1));
set(fh.gca,'XTickLabelRotation',30);
%�Բ��1����ʱƵ��������
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%����1��Ƶ�ĶԱ�
%% ���Ʊ�Ƶ
fh = figureExpNatureFrequencyBar(vesselCombineDataCells,1,legendLabels);
fh = figureExpNatureFrequencyBar(vesselCombineDataCells,2,legendLabels);
fh = figureExpNatureFrequencyBar(vesselCombineDataCells,3,legendLabels);