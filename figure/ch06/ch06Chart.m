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

[~,orificD0_25CombineData] = loadExpDataFromFolder(orificD0_25CombineDataPath);
[~,orificD0_5CombineData] = loadExpDataFromFolder(orificD0_5CombineDataPath);
[~,orificD0_75CombineData] = loadExpDataFromFolder(orificD0_75CombineDataPath);
[~,orificD01CombineData] = loadExpDataFromFolder(orificD1CombineDataPath);
[~,orific28MultHoleD01CombineData] = loadExpDataFromFolder(orific28MultHoleD1CombineDataPath);
%�Աȵ���
orificDataCells = {orificD0_25CombineData,orificD0_5CombineData,orificD0_75CombineData,orificD01CombineData};
legendLabels = {'0.25D','0.5D','0.75D','1D'};
%% ��ͼ

figureExpPressurePlus(orificD0_25CombineData,'errorType',errorType,'showpurevessel',1);
figureMultExpPressurePlus(orificDataCells,legendLabels,'showpurevessel',1);

figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);
figureMultExpSuppressionLevel(orificDataCells,legendLabels,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);

figureMultExpPressureDrop(orificDataCells,legendLabels,[2,3],'chartType','bar');
