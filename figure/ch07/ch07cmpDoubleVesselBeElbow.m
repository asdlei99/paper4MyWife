%% ������ ��ͼ - ˫����ͷʽ��������۷����Ա�
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
expSingleVessel = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ��ֱ��420ת0.05mpaModify');
%����ʵ������ �� ģ������
[expStraightLinkDataCells,expStraightLinkCombineData,simStraightLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expStraightLinkCombineDataPath);
[expElbowLinkDataCells,expElbowLinkCombineData,simElbowLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expElbowLinkCombineDataPath);
[expSingleVesselDataCells,expSingleVesselCombineData] ...
    = loadExpDataFromFolder(expSingleVessel);
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%  ���濪ʼ��ͼ
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ����-ģ��-ʵ��-���� �Աȷ���
%ģ���Ӧ����
% xSim{1} = [[0.5,1,1.5,2,2.5,2.85,3]-0.25  ,[4.2] ,[5.5,6.5,7,7.5,8,8.5,9,9.5,10]] + 0.5;
% xSim{2} = [[0.5,1,1.5,2,2.5,2.85,3]-0.25  ,[4.5,5,5.5],  [6.5,7,7.5,8,8.5,9,9.5,10]] + 0.5;
% xSim{1} = [[0.5,1,1.5,2,2.5]+0.5 ,[6.5,7,7.5,8,8.5,9,9.5,10]] ;
% xSim{2} = [[0.5,1,1.5,2,2.5,2.85]  ,[4.5,5,5.5]+0.65,  [7,7.5,8,8.5,9,9.5,10]+1.05];
xSim{1} = [[2,2.5]+0.5 ,[6.5,7,7.5,8,8.5,9,9.5,10]] ;
xSim{2} = [[2.5,2.85]  ,[4.5,5,5.5]+0.65,  [7,7.5,8,8.5,9,9.5,10]+1.05];
%ʵ���Ӧ����
xStraightLinkVessel = [2.5,3,6.25,7.05,7.55,8.05,8.55,9.05,9.55,10.05];%����޴����ľ���
xElbowLinkVessel = [2.5,3,5.15,5.65,6.15,8.05,8.55,9.05,9.55,10.05,10.55,11.05];%�������ͷʽ����޾���
xExp = {xStraightLinkVessel,xElbowLinkVessel};
%ʵ���Ӧ���
expRangStraightLinkVessel = [1,2,4,7,8,9,10,11,12,13];
expRangElbowLinkVessel = [1,2,4,5,6,7,8,9,10,11,12,13];
expRang = {expRangStraightLinkVessel,expRangElbowLinkVessel};

%�����������޶�Ӧ����
vesselRegion1 = [3.8,6];
vesselRegion2_1 = [3.8,4.9];
vesselRegion2_2 = [6.4,7.5];
%ģ����
simRang{1} = [4:5,10:17];
simRang{2} = [5:6,8:10,12:18];
if 0
    %��������
    thePlusValue = theoryDataCells(theAnalysisRow,2);%ͨ���˺��������������ò�ͬ�ĶԱ�ֵ
    xThe = theoryDataCells(theAnalysisRow,3);
    %vesselRegion1�µ����ݶ�Ӧ�����
    tmp = ( xThe{1} > vesselRegion1(1) & xThe{1} < vesselRegion1(2)) | xThe{1}<2.5;
    xThe{1}(tmp) = [];
    thePlusValue{1}.pulsationValue(tmp) = [];
    tmp = xThe{2}<2.5;
    xThe{2}(tmp) = [];
    thePlusValue{2}.pulsationValue(tmp) = [];
    fh = figureExpAndSimThePressurePlus({expStraightLinkCombineData,expElbowLinkCombineData}...
                            ,{simStraightLinkDataCells,simElbowLinkDataCells}...
                            ,thePlusValue...
                            ,'showMeasurePoint',0 ...
                            ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                            ,'expRang',expRang,'simRang',simRang...
                            ,'showVesselRigion',0,'ylim',[0,35]...
                            ,'xlim',[2,12]);
    regionHandle = plotVesselRegion(fh.gca,vesselRegion1,'color',getPlotColor(1),'yPercent',[0,0]...
        ,'FaceAlpha',0.3,'EdgeAlpha',0.3);
    regionHandle = plotVesselRegion(fh.gca,vesselRegion2_1,'color',getPlotColor(2),'yPercent',[0,0]...
        ,'FaceAlpha',0,'EdgeAlpha',1);
    set(regionHandle,'LineWidth',2);
    regionHandle = plotVesselRegion(fh.gca,vesselRegion2_2,'color',getPlotColor(2),'yPercent',[0,0]...
        ,'FaceAlpha',0,'EdgeAlpha',1);
    set(regionHandle,'LineWidth',2);

    legendGca1 = makePlotAxesLayout(fh.gca);
    legendHandle1 = legend(legendGca1,[fh.plotHandle(1),fh.plotHandleSim(1),fh.plotHandleThe(1)],{'˫�޴���-ʵ��','˫�޴���-ģ��','˫�޴���-����'});
    set(legendHandle1,'Position',[0.621015923169843 0.740763721727818 0.291041661672708 0.180798606379992]...
        ,'EdgeColor','none');

    legendGca2 = makePlotAxesLayout(fh.gca);
    legendHandle2 = legend(legendGca2,[fh.plotHandle(2),fh.plotHandleSim(2),fh.plotHandleThe(2)],{'��ͷʽ�����-ʵ��','��ͷʽ�����-ģ��','��ͷʽ�����-����'});
    set(legendHandle2,'Position',[0.270434136322998 0.740777644995141 0.343958326762336 0.180798606379992]...
        ,'EdgeColor','none');

    annotation(fh.figure,'textarrow',[0.332599118942731 0.381057268722467],...
        [0.683168316831683 0.594059405940594],'String',{'C'});
    annotation(fh.figure,'textarrow',[0.204845814977974 0.270397087616253],...
        [0.250825082508251 0.228376908003301],'String',{'A'});
    annotation(fh.figure,'textarrow',[0.422907488986784 0.473242091899169],...
        [0.531353135313531 0.505604630775578],'String',{'B'});
    annotation(fh.figure,'rectangle',...
        [0.270399305555556 0.740234375 0.643819444444444 0.171979166666667]);
end
%% ��������������
%��ȡ��һ����޵�����
if 0
    %��������������
    expRangStraightLinkVesselMapToSingle = [1,2,6,7,8,9,10,11,12,13];
    expRangElbowLinkVesselMapToSingle = [1,2,4,5,6,7,8,9,10,11,12,13];
    tmp = mean(expSingleVesselCombineData.readPlus);
    suppressionRateBase{1} = tmp(expRangStraightLinkVesselMapToSingle);
    suppressionRateBase{2} = tmp(expRangElbowLinkVesselMapToSingle);
    [ meanValSingleVessel,stdValSingleVessel,maxValSingleVessel,minValSingleVessel ...
        ,muciSingleVessel,sigmaciSingleVessel] = constExpVesselPressrePlus(420);
    xSuppressionRate = {expRangStraightLinkVesselMapToSingle,expRangElbowLinkVesselMapToSingle};
    fh = figureExpPressurePlusSuppressionRate({expStraightLinkCombineData,expElbowLinkCombineData}...
        ,legendText...        
        ,'errorDrawType','bar'...
        ,'showVesselRigon',0 ...
        ,'xs',xSuppressionRate ...
        ,'rangs',expRang...
        ,'suppressionRateBase',suppressionRateBase...
        ,'xIsMeasurePoint',1 ...
        ,'figureHeight',6 ...
        );
    ylim([-20,100]);
    set(fh.legend,'Position',[0.550480330382233 0.23224537457581 0.335138882580731 0.167569440239006]);
%     plotVesselRegion(fh.gca,vesselRegion1,'color',getPlotColor(1),'yPercent',[0,0]...
%         ,'FaceAlpha',0.3,'EdgeAlpha',0.3);
%     plotVesselRegion(fh.gca,vesselRegion2_1,'color',getPlotColor(2),'yPercent',[0,0]...
%         ,'FaceAlpha',0,'EdgeAlpha',1);
%     plotVesselRegion(fh.gca,vesselRegion2_2,'color',getPlotColor(2),'yPercent',[0,0]...
%         ,'FaceAlpha',0,'EdgeAlpha',1);
end
%% ���Ʊ�Ƶ����
if 1
    fh = figureExpNatureFrequency({expStraightLinkCombineData,expElbowLinkCombineData}...
        ,{'˫�޴���','��ͷʽ�����'}...
        ,'xs',xExp...
        ,'rang',expRang...
        ,'ylim',[0,14]...
        ,'showVesselRigon',0 ...
        ,'isShowMeasurePoint',0 ...
        ,'figureHeight',7 ...
    );
    regionHandle = plotVesselRegion(fh.gca,vesselRegion1,'color',getPlotColor(1),'yPercent',[0,0]...
        ,'FaceAlpha',0.3,'EdgeAlpha',0.3);
    regionHandle = plotVesselRegion(fh.gca,vesselRegion2_1,'color',getPlotColor(2),'yPercent',[0,0]...
        ,'FaceAlpha',0,'EdgeAlpha',1);
    set(regionHandle,'LineWidth',2);
    regionHandle = plotVesselRegion(fh.gca,vesselRegion2_2,'color',getPlotColor(2),'yPercent',[0,0]...
        ,'FaceAlpha',0,'EdgeAlpha',1);
    set(regionHandle,'LineWidth',2);
    annotation(fh.figure,'textarrow',[0.345364583333333 0.409305555555556],...
        [0.786536458333334 0.75015625],'String',{'C'});
    annotation(fh.figure,'textarrow',[0.248350694444445 0.283628472222222],...
        [0.664166666666667 0.59140625],'String',{'A'});
    annotation(fh.figure,'textarrow',[0.471041666666667 0.512934027777778],...
        [0.667473958333333 0.598020833333333],'String',{'B'});
    set(fh.legend,...
        'Position',[0.537251164438377 0.669175353530379 0.359392354080144 0.235920132580731]);
end

