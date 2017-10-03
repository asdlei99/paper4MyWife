%% ������ ��ͼ - ˫�޹޶�����ͷ���۷����Ա�
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% ����ʵ���ģ������
expStraightLinkCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\˫����޴���420ת0.1mpa');
expElbowLinkCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\˫����޴����޶�����ͷ420ת0.1mpa');
%����ʵ������ �� ģ������
[expStraightLinkDataCells,expStraightLinkCombineData,simStraightLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expStraightLinkCombineDataPath);
[expElbowLinkDataCells,expElbowLinkCombineData,simElbowLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expElbowLinkCombineDataPath);
legendText = {'˫����޴���','˫�������ͷ����'};
%% ������������
% ���۶Աȷ���-�Ա�{'ֱ��';'��һ�����';'ֱ����ǰ��';'˫��-�޶�����ͷ';'˫���޼������'}
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
% theoryDataCells = cmpDoubleVesselBeElbow('massflowdata',[freRaw;massFlowERaw]...
%     ,'meanFlowVelocity',14);
theoryDataCells = cmpDoubleVesselBeElbow();
theAnalysisRow = [6,5];

legendLabels = theoryDataCells(theAnalysisRow,1);

%% ����ʵ��Աȷ���

%ģ���Ӧ����
% xSim{1} = [[0.5,1,1.5,2,2.5,2.85,3]-0.25  ,[4.2] ,[5.5,6.5,7,7.5,8,8.5,9,9.5,10]] + 0.5;
% xSim{2} = [[0.5,1,1.5,2,2.5,2.85,3]-0.25  ,[4.5,5,5.5],  [6.5,7,7.5,8,8.5,9,9.5,10]] + 0.5;
xSim{1} = [[0.5,1,1.5,2,2.5]+0.5 ,[6.5,7,7.5,8,8.5,9,9.5,10]] ;
xSim{2} = [[0.5,1,1.5,2,2.5,2.85]  ,[4.5,5,5.5]+0.65,  [7,7.5,8,8.5,9,9.5,10]+1.05];
%ʵ���Ӧ����
xExp{1} = [2.5,3,6.25,7.05,7.55,8.05,8.55,9.05,9.55,10.05];%����޴����ľ���
xExp{2} = [2.5,3,5.15,5.65,6.15,8.05,8.55,9.05,9.55,10.05,10.55,11.05];%����޹޶�����ͷ����
%ʵ���Ӧ���
expRang{1} = [1,2,4,7,8,9,10,11,12,13];
expRang{2} = [1,2,4,5,6,7,8,9,10,11,12,13];
%��������
thePlusValue = theoryDataCells(theAnalysisRow,2);%ͨ���˺��������������ò�ͬ�ĶԱ�ֵ
xThe = theoryDataCells(theAnalysisRow,3);
%�����������޶�Ӧ����
vesselRegion1 = [3.8,6];
vesselRegion2_1 = [3.8,4.9];
vesselRegion2_2 = [6.4,7.5];
%ģ����
simRang{1} = [1:5,10:17];
simRang{2} = [1:6,8:10,12:18];
fh = figureExpAndSimThePressurePlus({expStraightLinkCombineData,expElbowLinkCombineData}...
                        ,{simStraightLinkDataCells,simElbowLinkDataCells}...
                        ,thePlusValue...
                        ,legendText...
                        ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                        ,'expRang',expRang,'simRang',simRang...
                        ,'showVesselRigion',0,'ylim',[0,40]...
                        ,'xlim',[2,12]);
set(fh.legend,...
    'Position',[0.519612276666557 0.583185770197046 0.396874991851964 0.235920132580731]);
plotVesselRegion(fh.gca,vesselRegion1,'color',getPlotColor(1),'yPercent',[0,0]...
    ,'FaceAlpha',0.3,'EdgeAlpha',0.3);
plotVesselRegion(fh.gca,vesselRegion2_1,'color',getPlotColor(2),'yPercent',[0,0]...
    ,'FaceAlpha',0,'EdgeAlpha',1);
plotVesselRegion(fh.gca,vesselRegion2_2,'color',getPlotColor(2),'yPercent',[0,0]...
    ,'FaceAlpha',0,'EdgeAlpha',1);
annotation(fh.figure,'textarrow',[0.336545138888889 0.391666666666667],...
    [0.776614583333333 0.727005208333333],'String',{'A'});
annotation(fh.figure,'textarrow',[0.23953125 0.268194444444445],...
    [0.654244791666667 0.594713541666667],'String',{'B'});
annotation(fh.figure,'textarrow',[0.415920138888889 0.468836805555556],...
    [0.6509375 0.594713541666667],'String',{'C'});
