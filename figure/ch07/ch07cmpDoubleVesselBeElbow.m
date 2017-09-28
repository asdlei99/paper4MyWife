%% ������ ��ͼ - ˫�޹޶�����ͷ���۷����Ա�
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% ����ʵ������
expStraightLinkCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\˫����޴���420ת0.1mpa');
expElbowLinkCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\˫����޴����޶�����ͷ420ת0.1mpa');
%����ʵ������ �� ģ������
[expStraightLinkDataCells,expStraightLinkCombineData,simStraightLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expStraightLinkCombineDataPath);
[expElbowLinkDataCells,expElbowLinkCombineData,simElbowLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expElbowLinkCombineDataPath);
legendText = {'˫����޴���','˫�������ͷ����'};
%% ����ʵ��Աȷ���
xSim = {};
figureExpPressurePlus({expStraightLinkCombineData,expElbowLinkCombineData});
xSim{1} = 1:length(simStraightLinkDataCells.rawData.pulsationValue);
xSim{1} = xSim{1}.*0.5;
xSim{2} = 1:length(simElbowLinkDataCells.rawData.pulsationValue);
xSim{2} = xSim{2}.*0.5;
figureExpAndSimPressurePlus({expStraightLinkCombineData,expElbowLinkCombineData}...
                        ,{simStraightLinkDataCells,simElbowLinkDataCells},legendText,'xsim',xSim);
%% ���۶Աȷ���-�Ա�{'ֱ��';'��һ�����';'ֱ����ǰ��';'˫��-�޶�����ͷ';'˫���޼������'}
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
theoryDataCells = cmpDoubleVesselBeElbow('massflowdata',[freRaw;massFlowERaw]...
    ,'meanFlowVelocity',14);
theAnalysisRow = 5:6;
plusValue = theoryDataCells(theAnalysisRow,2);%ͨ���˺��������������ò�ͬ�ĶԱ�ֵ
X = theoryDataCells(theAnalysisRow,3);
legendLabels = theoryDataCells(theAnalysisRow,1);
fh = figureTheoryPressurePlus(plusValue,X...
    ,'legendLabels',legendLabels...
);