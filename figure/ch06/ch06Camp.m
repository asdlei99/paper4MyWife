%% ������ ��ͼ - ��ͬͬ�����ѹ�������Ա�
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
isSaveFigure = 1;
%% ����·��
orificD1CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D1RPM420���м�');
perforateD01N28DataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ�׹�\D1N28d20RPM420��ͷ��');
innerPipeD1CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ��\�ڲ��1D���м�420ת0.05mpa');

orificD0_5CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D0.5RPM420���м�');
perforateD0_5N28DataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ�׹�\D0.5N20RPM420��ͷ��');
innerPipeD0_5CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ��\�ڲ��0.5D�м�420ת0.05mpa');
%% �����ڲ���Լ����������
%0.5D,0.75D,1D�װ��ʵ��ģ������

[expOrificD01ataCells,expOrificD01CombineData] ...
    = loadExpDataFromFolder(orificD1CombineDataPath);
[expPerforateD01N28DataCells,expPerforateD01N28CombineData] ...
    = loadExpDataFromFolder(perforateD01N28DataPath);
[expInnerPipe01DataCells,expInnerPipe01CombineData] ...
    = loadExpDataFromFolder(innerPipeD1CombineDataPath);

[expOrificD0_5ataCells,expOrificD0_5CombineData] ...
    = loadExpDataFromFolder(orificD0_5CombineDataPath);
[expPerforateD0_5N28DataCells,expPerforateD0_5N28CombineData] ...
    = loadExpDataFromFolder(perforateD0_5N28DataPath);
[expInnerPipe0_5DataCells,expInnerPipe0_5CombineData] ...
    = loadExpDataFromFolder(innerPipeD0_5CombineDataPath);

%�Աȵ���
innerElementDataCells1D = {expOrificD01CombineData,expInnerPipe01CombineData,expPerforateD01N28CombineData};
legendLabels1D = {'1D�װ�','1D�ڲ��','1D�ڲ�׹�'};

innerElementDataCells0_5D = {expOrificD0_5CombineData,expInnerPipe0_5CombineData,expPerforateD0_5N28CombineData};
legendLabels0_5D = {'0.5D�װ�','0.5D�ڲ��','0.5D�ڲ�׹�'};


%% ���ƶ���ѹ������
if 1
	paperPlotInnerElementExpCmp1D(innerElementDataCells1D...
        ,legendLabels1D...
        ,isSaveFigure...
        );
end

%% ���ƶ���ѹ������
if 1
    paperPlotInnerElementExpCmp0_5D(innerElementDataCells0_5D...
        ,legendLabels0_5D...
        ,isSaveFigure...
        );
end

