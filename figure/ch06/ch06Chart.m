%% �����»�ͼ
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% �����м�׹ܻ��������
orificD0_5CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D0.5RPM420���м�');
orificD0_25CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D0.25RPM420���м�');
orificD0_75CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D0.75RPM420���м�');
orificD1CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D1RPM420���м�');
orific28MultHoleD1CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\��׿װ�N28D1RPM420���м�');
%% ͼ6-6 �м�׹ܻ����ѹ��������������

[orificD0_25DataCells,orificD0_25CombineData] = loadExpDataFromFolder(orificD0_25CombineDataPath);
[orificD0_5DataCells,orificD0_5CombineData] = loadExpDataFromFolder(orificD0_5CombineDataPath);
[orificD0_75DataCells,orificD0_75CombineData] = loadExpDataFromFolder(orificD0_75CombineDataPath);
[orificD01DataCells,orificD01CombineData] = loadExpDataFromFolder(orificD1CombineDataPath);
[orific28MultHoleD01DataCells,orific28MultHoleD01CombineData] = loadExpDataFromFolder(orific28MultHoleD1CombineDataPath);
%�Աȵ���
orificDataCells = {orificD0_25CombineData,orificD0_5CombineData,orificD0_75CombineData,orificD01CombineData};
legendLabels = {'0.25D','0.5D','0.75D','1D'};
%% ������������
%ʱƵ������������
Fs = 100;%ʵ�������
STFT.windowSectionPointNums = 256;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
%% ��ͼ
dataNumIndex = 2;%��ȡ��ʵ��������<5
measurePoint = [1,3,7,13];%ʱƵ�������εĲ��
fh = figureExpPressureSTFT(getExpDataStruct(orificD01DataCells,dataNumIndex,baseField),measurePoint,Fs...
    ,'STFT',STFT,'chartType',STFTChartType);
ylim([0,30]);
%����0.25D��ѹ������
fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%���ƶ���ѹ������
fh = figureMultExpPressurePlus(orificDataCells,legendLabels,'showPureVessel',1);
%����0.25D��ѹ������������
fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);
%���ƶ���ѹ������������
fh = figureMultExpSuppressionLevel(orificDataCells,legendLabels,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);
%���ƶ���ѹ����
figureMultExpPressureDrop(orificDataCells,legendLabels,[2,3],'chartType','bar');
%�Բ��1����ʱƵ��������
