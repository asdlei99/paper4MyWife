%% ������ ��ͼ - ��һ�����ֱ����ǰ(��)��
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
vesselDirectInSideFontOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ����ǰ��420ת0.05mpa');
vesselDirectInSideBackOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ������420ת0.05mpa');
vesselDirectInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ��ֱ��420ת0.05mpaModify');
%% �����м�װ��Լ����������
[vesselSideFontInDirectOutDataCells,vesselSideFontInDirectOutCombineData] ...
    = loadExpDataFromFolder(vesselSideFontInDirectOutCombineDataPath);
[vesselSideFontInSideFontOutDataCells,vesselSideFontInSideFontOutCombineData] ...
    = loadExpDataFromFolder(vesselSideFontInSideFontOutCombineDataPath);
[vesselDirectInSideFontOutDataCells,vesselDirectInSideFontOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInSideFontOutCombineDataPath);
[vesselDirectInSideBackOutDataCells,vesselDirectInSideBackOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInSideBackOutCombineDataPath);
[vesselDirectInDirectOutDataCells,vesselDirectInDirectOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInDirectOutCombineDataPath);

%����޲�ͬ�ӷ���ʵ������
vesselCombineDataCells = {vesselSideFontInDirectOutCombineData...
    ,vesselSideFontInSideFontOutCombineData...
    ,vesselDirectInSideFontOutCombineData...
    ,vesselDirectInSideBackOutCombineData...
    ,vesselDirectInDirectOutCombineData...
    };
%ʵ���������һ������ֵ

singleVesselExpPlot(vesselDirectInSideFontOutCombineData,vesselDirectInSideFontOutDataCells...
    ,vesselDirectInDirectOutCombineData,vesselDirectInDirectOutDataCells,'ֱ����ǰ��');

%����ʵ�����
singleVesselThePlot();