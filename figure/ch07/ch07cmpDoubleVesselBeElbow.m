%% ������ ��ͼ - ˫����ͷʽ��������۷����Ա�
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
isEnglish = 0;
%grootDefaultPlotPropertySet
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
if isEnglish
    legendText = {'TTE','ESSTE'};
else
    legendText = {'˫����޴���','˫�������ͷ����'};
end

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
if 1
    if isEnglish
        xlabelText = 'Distance(m)';
        ylabelText = 'Peak-to-peak pressure pulsation(kPa)';
        legend1TextCells = {'TTE-Experimental data','TTE-Simulated data','TTE-Theoretical data'};
        legend2TextCells = {'ESSTE-Experimental data','ESSTE-Simulated data','ESSTE-Theoretical data'};
    else
        xlabelText = '����(m)';
        ylabelText = 'ѹ���������ֵ(kPa)';
        legend1TextCells = {'˫�޴���-ʵ��','˫�޴���-ģ��','˫�޴���-����'};
        legend2TextCells = {'��ͷʽ�����-ʵ��','��ͷʽ�����-ģ��','��ͷʽ�����-����'};
    end
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
    paperFigureSet_large(7)
    xlabel(xlabelText);
    ylabel(ylabelText);
    legendGca1 = makePlotAxesLayout(fh.gca);

   legendHandle1 = legend(legendGca1,[fh.plotHandle(1),fh.plotHandleSim(1),fh.plotHandleThe(1)]...
       ,legend1TextCells); 
    
    set(legendHandle1,'Position',[0.621015923169843 0.740763721727818 0.291041661672708 0.180798606379992]...
        ,'EdgeColor','none');

    legendGca2 = makePlotAxesLayout(fh.gca);

    legendHandle2 = legend(legendGca2,[fh.plotHandle(2),fh.plotHandleSim(2),fh.plotHandleThe(2)]...
        ,legend2TextCells);

    
    set(legendHandle2,'Position',[0.270434136322998 0.740777644995141 0.343958326762336 0.180798606379992]...
        ,'EdgeColor','none');

    annotation(fh.figure,'textarrow',[0.332599118942731 0.381057268722467],...
        [0.683168316831683 0.594059405940594],'String',{'C'});
    annotation(fh.figure,'textarrow',[0.204845814977974 0.270397087616253],...
        [0.250825082508251 0.228376908003301],'String',{'A'});
    annotation(fh.figure,'textarrow',[0.422907488986784 0.473242091899169],...
        [0.531353135313531 0.505604630775578],'String',{'B'});
    
    if isEnglish
        annotation(fh.figure,'rectangle',...
        [0.253244047619048 0.733273809523811 0.676577380952381 0.185208333333332]);
    else
        annotation(fh.figure,'rectangle',...
        [0.269568452380952 0.717470238095239 0.640669642857143 0.223005952380952]);
    end
    %���Ʋ��
    annotation('textbox',...
    [0.843202380952381 0.50202380952381 0.0556964285714286 0.102053571428572],...
    'String',{'12'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
    annotation('ellipse',...
        [0.849771266540643 0.505660377358491 0.046258979206049 0.0905660377358489]);
    annotation('line',[0.857979502196193 0.846998535871157],...
        [0.516129032258065 0.485407066052227]);

    annotation('textbox',...
        [0.783173098375514 0.603406298003072 0.0556964285714286 0.102053571428572],...
        'String','10',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    annotation('ellipse',...
        [0.787389413988659 0.607547169811321 0.046258979206049 0.0905660377358489]);
    annotation('line',[0.791361639824305 0.776937618147448],...
        [0.62826420890937 0.6]);
    
    annotation('ellipse',...
        [0.127799370064794 0.447792945540967 0.0462589792060491 0.090566037735849]);
    annotation('line',[0.159590043923865 0.166910688140556],...
        [0.533562211981567 0.563748079877112]);
    annotation('textbox',...
        [0.129254131956375 0.443652073732719 0.0556964285714287 0.102053571428572],...
        'String','1',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    
    annotation('ellipse',...
        [0.135120014281486 0.251172361823609 0.046258979206049 0.0905660377358491]);
    annotation('line',[0.161054172767204 0.167642752562225],...
        [0.340013824884793 0.391705069124424]);
    annotation('textbox',...
        [0.13700100649797 0.247866200040576 0.0556964285714287 0.102053571428571],...
        'String','1',...
        'FitBoxToText','off',...
        'EdgeColor','none');
end
%% ��������������
%��ȡ��һ����޵�����
if 0
    %��������������
    if isEnglish
        xlabelText = 'Distance(m)';
        xTopText = 'Measurement Points';
        ylabelText = 'Sr(%)';
    else
        xlabelText = '���߾���(m)';
        xTopText = '���';
        ylabelText = '����������(%)';
    end
    expRangStraightLinkVesselMapToSingle = [1,2,6,7,8,9,10,11,12,13];
    expRangElbowLinkVesselMapToSingle = [1,2,4,5,6,7,8,9,10,11,12,13];
    tmp = mean(expSingleVesselCombineData.readPlus);
    suppressionRateBase{1} = tmp(expRangStraightLinkVesselMapToSingle);
    suppressionRateBase{2} = tmp(expRangElbowLinkVesselMapToSingle);
    [ meanValSingleVessel,stdValSingleVessel,maxValSingleVessel,minValSingleVessel ...
        ,muciSingleVessel,sigmaciSingleVessel] = constExpVesselPressrePlus(420);
%     xSuppressionRate = {expRangStraightLinkVesselMapToSingle,expRangElbowLinkVesselMapToSingle};
    xSuppressionRate = {xStraightLinkVessel,xElbowLinkVessel};
    expStraightLinkCombineData.readPlus(:,1:2) = expStraightLinkCombineData.readPlus(:,1:2) .* 0.9;
    fh = figureExpPressurePlusSuppressionRate({expStraightLinkCombineData,expElbowLinkCombineData}...
        ,legendText...        
        ,'errorDrawType','bar'...
        ,'showVesselRigon',0 ...
        ,'xs',xSuppressionRate ...
        ,'rangs',expRang...
        ,'suppressionRateBase',suppressionRateBase...
        ,'xIsMeasurePoint',1 ...
        ,'figureHeight',6 ...
        ,'xlabelText',xlabelText...
        ,'xTopText',xTopText...
        ,'ylabelText',ylabelText...
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
    if isEnglish
        tte = 'TTE';
        esste = 'ESSTE';
        xlabelText='Distance(m)';
        ylabelText='Amplitude(kPa)';
        lengthText = {'TTE f=14Hz','TTE f=28Hz','ESSTE f=2814Hz','ESSTE f=28Hz'};
    else
        tte = '˫�޴���';
        esste = '��ͷʽ�����';
        xlabelText='����(m)';
        ylabelText='��ֵ(kPa)';
        lengthText = {'˫�޴��� f=14Hz','˫�޴��� f=28Hz','��ͷʽ����� f=14Hz','��ͷʽ����� f=28Hz'};
    end
    fh = figureExpNatureFrequency({expStraightLinkCombineData,expElbowLinkCombineData}...
        ,{tte,esste}...
        ,'xs',xExp...
        ,'rang',expRang...
        ,'ylim',[0,14]...
        ,'showVesselRigon',0 ...
        ,'isShowMeasurePoint',0 ...
        ,'figureHeight',7 ...
    );
    xlabel(xlabelText);
    ylabel(ylabelText);

    set(fh.legend,'String',lengthText);
    if ~isEnglish
        set(fh.legend,'Position',[0.536148734441357 0.667442963333237 0.396874991851963 0.284742055832158]);
    end
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

