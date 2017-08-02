%% ������ ��ͼ - ˫�޲�ͬ�ӷ��о�
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% ����·��
doubleVessel_L_CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\˫�����L��420ת0.1mpa');%��ǰ��ֱ���
doubleVessel_Z_CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\˫�����Z��420ת0.1mpa');
doubleVessel_Straight_CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\˫����޴���420ת0.1mpa');
doubleVessel_Elbow_CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\˫����޴����޶�����ͷ420ת0.1mpa');
doubleVessel_H_CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\˫����޲���L��420ת0.1mpa');

%% �����м�װ��Լ����������
[doubleVessel_L_DataCells,doubleVessel_L_CombineData] ...
    = loadExpDataFromFolder(doubleVessel_L_CombineDataPath);
[doubleVessel_Z_DataCells,doubleVessel_Z_CombineData] ...
    = loadExpDataFromFolder(doubleVessel_Z_CombineDataPath);
[doubleVessel_Straight_DataCells,doubleVessel_Straight_CombineData] ...
    = loadExpDataFromFolder(doubleVessel_Straight_CombineDataPath);
[doubleVessel_Elbow_DataCells,doubleVessel_Elbow_CombineData] ...
    = loadExpDataFromFolder(doubleVessel_Elbow_CombineDataPath);
[doubleVessel_H_DataCells,doubleVessel_H_CombineData] ...
    = loadExpDataFromFolder(doubleVessel_H_CombineDataPath);


%�Աȵ���
doubleVesselCombineDataCells = {doubleVessel_Straight_CombineData...
    ,doubleVessel_Z_CombineData...
    ,doubleVessel_L_CombineData...
    ,doubleVessel_Elbow_CombineData...
    ,doubleVessel_H_CombineData...
    };
legendLabels = {'˫�޴���','˫��Z��','˫��L��','˫�޴����޶�����ͷ','˫��H��'};


%% ===================================================================================
%
%

%% 
fh = figureExpPressureSpectrum(doubleVessel_L_DataCells);

%% ������������
%ʱƵ������������
Fs = 100;%ʵ�������
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
STFTChartType = 'plot3';%contour|plot3
%% ��ͼ 
%% [1,3,5,7,9,13]����ʱƵ��������
if 1
    dataNumIndex = 2;%��ȡ��ʵ��������<5
    measurePoint = [1,3,5,7,9,13];%ʱƵ�������εĲ��
    stftLabels = {};
    for i = 1:length(measurePoint)
        stftLabels{i} = sprintf('���%d',measurePoint(i));
    end
    fh = figureExpPressureSTFT(getExpDataStruct(doubleVessel_L_DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    title('L��');
    fh = figureExpPressureSTFT(getExpDataStruct(doubleVessel_Z_DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(doubleVessel_Straight_DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(doubleVessel_Elbow_DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(doubleVessel_H_DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
end
%����0.25D��ѹ������
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% ���ƶ���ѹ������
fh = figureExpPressurePlus(doubleVesselCombineDataCells,legendLabels,'errorType',errorType...
    ,'showPureVessel',0);

%����0.25D��ѹ������������
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% ���ƶ���ѹ������������
%% ���ƶ���ѹ����
fh = figureExpPressureDrop(doubleVesselCombineDataCells,legendLabels,[2,3],'chartType','bar');
%'chartType'== 'bar' ʱ��������bar����ɫ
set(fh.barHandle,'FaceColor',getPlotColor(1));
%�Բ��1����ʱƵ��������
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%����1��Ƶ�ĶԱ�
%% ���Ʊ�Ƶ
fh = figureExpNatureFrequencyBar(doubleVesselCombineDataCells,1,legendLabels);
fh = figureExpNatureFrequencyBar(doubleVesselCombineDataCells,2,legendLabels);
fh = figureExpNatureFrequencyBar(doubleVesselCombineDataCells,3,legendLabels);

figureExpPressureMean(doubleVesselCombineDataCells,legendLabels);
