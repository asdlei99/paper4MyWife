%% 第七章 绘图 - 双罐弯头式缓冲罐理论分析对比
%第七章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 加载实验和模拟数据
expStraightLinkCombineDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\双缓冲罐串联420转0.1mpa');
expElbowLinkCombineDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\双缓冲罐串联罐二当弯头420转0.1mpa');
expSingleVessel = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进直出420转0.05mpaModify');
%加载实验数据 及 模拟数据
[expStraightLinkDataCells,expStraightLinkCombineData,simStraightLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expStraightLinkCombineDataPath);
[expElbowLinkDataCells,expElbowLinkCombineData,simElbowLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expElbowLinkCombineDataPath);
[expSingleVesselDataCells,expSingleVesselCombineData] ...
    = loadExpDataFromFolder(expSingleVessel);
legendText = {'双缓冲罐串联','双缓冲罐弯头串联'};
%% 加载理论数据
% 理论对比分析-对比{'直管';'单一缓冲罐';'直进侧前出';'双罐-罐二作弯头';'双罐无间隔串联'}
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
%  下面开始绘图
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 绘制-模拟-实验-理论 对比分析
%模拟对应距离
% xSim{1} = [[0.5,1,1.5,2,2.5,2.85,3]-0.25  ,[4.2] ,[5.5,6.5,7,7.5,8,8.5,9,9.5,10]] + 0.5;
% xSim{2} = [[0.5,1,1.5,2,2.5,2.85,3]-0.25  ,[4.5,5,5.5],  [6.5,7,7.5,8,8.5,9,9.5,10]] + 0.5;
% xSim{1} = [[0.5,1,1.5,2,2.5]+0.5 ,[6.5,7,7.5,8,8.5,9,9.5,10]] ;
% xSim{2} = [[0.5,1,1.5,2,2.5,2.85]  ,[4.5,5,5.5]+0.65,  [7,7.5,8,8.5,9,9.5,10]+1.05];
xSim{1} = [[2,2.5]+0.5 ,[6.5,7,7.5,8,8.5,9,9.5,10]] ;
xSim{2} = [[2.5,2.85]  ,[4.5,5,5.5]+0.65,  [7,7.5,8,8.5,9,9.5,10]+1.05];
%实验对应距离
xStraightLinkVessel = [2.5,3,6.25,7.05,7.55,8.05,8.55,9.05,9.55,10.05];%缓冲罐串联的距离
xElbowLinkVessel = [2.5,3,5.15,5.65,6.15,8.05,8.55,9.05,9.55,10.05,10.55,11.05];%缓冲罐弯头式缓冲罐距离
xExp = {xStraightLinkVessel,xElbowLinkVessel};
%实验对应测点
expRangStraightLinkVessel = [1,2,4,7,8,9,10,11,12,13];
expRangElbowLinkVessel = [1,2,4,5,6,7,8,9,10,11,12,13];
expRang = {expRangStraightLinkVessel,expRangElbowLinkVessel};

%两个情况缓冲罐对应距离
vesselRegion1 = [3.8,6];
vesselRegion2_1 = [3.8,4.9];
vesselRegion2_2 = [6.4,7.5];
%模拟测点
simRang{1} = [4:5,10:17];
simRang{2} = [5:6,8:10,12:18];
if 0
    %理论数据
    thePlusValue = theoryDataCells(theAnalysisRow,2);%通过此函数的行索引设置不同的对比值
    xThe = theoryDataCells(theAnalysisRow,3);
    %vesselRegion1下的数据都应该清除
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
    legendHandle1 = legend(legendGca1,[fh.plotHandle(1),fh.plotHandleSim(1),fh.plotHandleThe(1)],{'双罐串联-实验','双罐串联-模拟','双罐串联-理论'});
    set(legendHandle1,'Position',[0.621015923169843 0.740763721727818 0.291041661672708 0.180798606379992]...
        ,'EdgeColor','none');

    legendGca2 = makePlotAxesLayout(fh.gca);
    legendHandle2 = legend(legendGca2,[fh.plotHandle(2),fh.plotHandleSim(2),fh.plotHandleThe(2)],{'弯头式缓冲罐-实验','弯头式缓冲罐-模拟','弯头式缓冲罐-理论'});
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
%% 绘制脉动抑制率
%获取单一缓冲罐的数据
if 0
    %计算脉动抑制率
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
%% 绘制倍频特性
if 1
    fh = figureExpNatureFrequency({expStraightLinkCombineData,expElbowLinkCombineData}...
        ,{'双罐串联','弯头式缓冲罐'}...
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

