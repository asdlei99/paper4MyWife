%% 第七章 绘图 - 双罐弯头式缓冲罐理论分析对比
%第七章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
isEnglish = 1;
isSaveFigure = true;
%grootDefaultPlotPropertySet
%% 加载实验和模拟数据
expStraightLinkCombineDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\双缓冲罐串联420转0.1mpa');
expElbowLinkCombineDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\双缓冲罐串联罐二当弯头420转0.1mpa');
expSingleVesselDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进直出420转0.05mpaModify');
%加载实验数据 及 模拟数据
[expStraightLinkDataCells,expStraightLinkCombineData,simStraightLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expStraightLinkCombineDataPath);
[expElbowLinkDataCells,expElbowLinkCombineData,simElbowLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expElbowLinkCombineDataPath);
[expSingleVesselDataCells,expSingleVesselCombineData,simSingleVesselDataCells] ...
    = loadExpAndSimDataFromFolder(expSingleVesselDataPath);
if isEnglish
    legendText = {'ST','TTE','ESSTE'};
else
    legendText = {'单容','双容串联','弯头式双容'};
end

%% 加载理论数据
% 理论对比分析-对比{'直管';'单一缓冲罐';'直进侧前出';'双罐-罐二作弯头';'双罐无间隔串联'}
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
% theoryDataCells = cmpDoubleVesselBeElbow('massflowdata',[freRaw;massFlowERaw]...
%     ,'meanFlowVelocity',14);
theoryDataCells = cmpDoubleVesselBeElbow();
theAnalysisRow = [2,6,5];

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
%模拟测点
%模拟数据修正
%[simSingleVesselDataCells.rawData.pulsationValue,xSVSim]= fixVesselDirectInSideFontOutSimData(simSingleVesselDataCells.rawData.pulsationValue);
[xSVSim,simSingleVesselDataCells.rawData.pulsationValue] = idealVesselPlusSimValue();
simRangSV = 1:length(xSVSim);
simRangStraightDV = [4:5,10:17];
simRangElbowLink = [5:6,8:10,12:18];
simRang = {simRangSV,simRangStraightDV,simRangElbowLink};

xSVExp = constExpMeasurementPointDistance();

% xSim{1} = [[0.5,1,1.5,2,2.5,2.85,3]-0.25  ,[4.2] ,[5.5,6.5,7,7.5,8,8.5,9,9.5,10]] + 0.5;
% xSim{2} = [[0.5,1,1.5,2,2.5,2.85,3]-0.25  ,[4.5,5,5.5],  [6.5,7,7.5,8,8.5,9,9.5,10]] + 0.5;
% xSim{1} = [[0.5,1,1.5,2,2.5]+0.5 ,[6.5,7,7.5,8,8.5,9,9.5,10]] ;
% xSim{2} = [[0.5,1,1.5,2,2.5,2.85]  ,[4.5,5,5.5]+0.65,  [7,7.5,8,8.5,9,9.5,10]+1.05];
xSimStraightDV = [[2,2.5]+0.5 ,[6.5,7,7.5,8,8.5,9,9.5,10]] ;
xSimElbowLink = [[2.5,2.85]  ,[4.5,5,5.5]+0.65,  [7,7.5,8,8.5,9,9.5,10]+1.05];
xSim = {xSVSim,xSimStraightDV,xSimElbowLink};
%实验对应距离
xStraightDBLinkVessel = [2.5,3,6.25,7.05,7.55,8.05,8.55,9.05,9.55,10.05];%缓冲罐串联的距离
xElbowLinkVessel = [2.5,3,5.15,5.65,6.15,8.05,8.55,9.05,9.55,10.05,10.55,11.05];%缓冲罐弯头式缓冲罐距离
xExp = {xSVExp,xStraightDBLinkVessel,xElbowLinkVessel};

%实验对应测点
expRangSV = [1:13];
expRangStraightDV = [1,2,4,7,8,9,10,11,12,13];
expRangElbowLinkVessel = [1,2,4,5,6,7,8,9,10,11,12,13];
expRang = {expRangSV,expRangStraightDV,expRangElbowLinkVessel};

%两个情况缓冲罐对应距离
vesselRegion1 = [3.8,6];
vesselRegion2_1 = [3.8,4.9];
vesselRegion2_2 = [6.4,7.5];

if 1
    if isEnglish
        xlabelText = 'Distance(m)';
        ylabelText = sprintf('Peak-to-peak pressure\npulsation(kPa)');
        legend0TextCells = {'ST-Experimental data','ST-Simulated data','ST-Theoretical data'};
        legend1TextCells = {'TTE-Experimental data','TTE-Simulated data','TTE-Theoretical data'};
        legend2TextCells = {'ESSTE-Experimental data','ESSTE-Simulated data','ESSTE-Theoretical data'};
    else
        xlabelText = '距离(m)';
        ylabelText = '压力脉动峰峰值(kPa)';
        legend0TextCells = {'单容-实验','单容-模拟','单容-理论'};
        legend1TextCells = {'双容串联-实验','双容串联-模拟','双容串联-理论'};
        legend2TextCells = {'弯头式双容-实验','弯头式双容-模拟','弯头式双容-理论'};
    end
    %理论数据
    thePlusValue = theoryDataCells(theAnalysisRow,2);%通过此函数的行索引设置不同的对比值
    xThe = theoryDataCells(theAnalysisRow,3);
    %vesselRegion1下的数据都应该清除
    tmp = ( xThe{2} > vesselRegion1(1) & xThe{2} < vesselRegion1(2)) | xThe{2}<2.5;
    xThe{2}(tmp) = [];
    thePlusValue{2}.pulsationValue(tmp) = [];
    tmp = xThe{3}<2.5;
    xThe{3}(tmp) = [];
    thePlusValue{3}.pulsationValue(tmp) = [];
    [xTheSV,yTheSV] = idealVesselPlusTheValue();
    
    thePlusValue{1}.pulsationValue = yTheSV;
    xThe{1} = xTheSV;
    figure;
    paperFigureSet('Large',10);
    fh = figureExpAndSimThePressurePlus({expSingleVesselCombineData,expStraightLinkCombineData,expElbowLinkCombineData}...
                            ,{simSingleVesselDataCells,simStraightLinkDataCells,simElbowLinkDataCells}...
                            ,thePlusValue...
                            ,'showMeasurePoint',0 ...
                            ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                            ,'expRang',expRang,'simRang',simRang...
                            ,'showVesselRigion',0,'ylim',[0,40]...
                            ,'xlim',[2,12]);
    regionHandle = plotVesselRegion(fh.gca,vesselRegion1,'color',getPlotColor(1),'yPercent',[0,0]...
        ,'FaceAlpha',0.3,'EdgeAlpha',0.3);
    regionHandle = plotVesselRegion(fh.gca,vesselRegion2_1,'color',getPlotColor(2),'yPercent',[0,0]...
        ,'FaceAlpha',0,'EdgeAlpha',1);
    set(regionHandle,'LineWidth',2);
    regionHandle = plotVesselRegion(fh.gca,vesselRegion2_2,'color',getPlotColor(2),'yPercent',[0,0]...
        ,'FaceAlpha',0,'EdgeAlpha',1);
    set(regionHandle,'LineWidth',2);
    xlabel(xlabelText);
    ylabel(ylabelText);
    
    set(gca,'Position',[0.13 0.18 0.79 0.585432098765432]);
    chartGca = gca;

    

   

    annotation('textarrow',[0.365952380952381 0.40375],...
        [0.570059523809524 0.494464285714286],'String',{'C'});
    annotation('textarrow',[0.235550595238095 0.289295897140062],...
        [0.248779761904762 0.217037622289015],'String',{'A'});
    annotation('textarrow',[0.469895833333333 0.509149829994407],...
        [0.630535714285715 0.592539154585102],'String',{'B'});
    
    if isEnglish
        legendGca2 = makePlotAxesLayout(fh.gca);
        legendHandle2 = legend(legendGca2,[fh.plotHandle(3),fh.plotHandleSim(3),fh.plotHandleThe(3)]...
            ,legend2TextCells);
        set(legendHandle2,'Position',[0.621349878169104 0.77949207919252 0.372400748200137 0.206289302777943]...
            ,'EdgeColor','none');

        legendGca1 = makePlotAxesLayout(fh.gca); 
        legendHandle1 = legend(legendGca1,[fh.plotHandle(2),fh.plotHandleSim(2),fh.plotHandleThe(2)]...
           ,legend1TextCells); 
        set(legendHandle1,'Position',[0.306568634002113 0.784875299732803 0.340264643297755 0.206626978719991]...
            ,'EdgeColor','none');

        legendGca0 = makePlotAxesLayout(fh.gca); 
        legendHandle0 = legend(legendGca0,[fh.plotHandle(1),fh.plotHandleSim(1),fh.plotHandleThe(1)]...
           ,legend0TextCells); 
        set(legendHandle0,'Position',[-0.00256263499879579 0.790139081473254 0.327032129514421 0.206289302777945]...
            ,'EdgeColor','none');
        annotation('rectangle',...
        [0.00188988095238099 0.789285714285715 0.989613095238095 0.19723214285715]);
    else
        legendGca2 = makePlotAxesLayout(fh.gca);
        legendHandle2 = legend(legendGca2,[fh.plotHandle(3),fh.plotHandleSim(3),fh.plotHandleThe(3)]...
            ,legend2TextCells);
        set(legendHandle2,'Position',[0.629473690752071 0.7904127019377 0.272142852186447 0.206626978719992]...
            ,'EdgeColor','none');

        legendGca1 = makePlotAxesLayout(fh.gca); 
        legendHandle1 = legend(legendGca1,[fh.plotHandle(2),fh.plotHandleSim(2),fh.plotHandleThe(2)]...
           ,legend1TextCells); 
        set(legendHandle1,'Position',[0.375849340179574 0.793081086863194 0.24946428143375 0.206626978719992]...
            ,'EdgeColor','none');

        legendGca0 = makePlotAxesLayout(fh.gca); 
        legendHandle0 = legend(legendGca0,[fh.plotHandle(1),fh.plotHandleSim(1),fh.plotHandleThe(1)]...
           ,legend0TextCells); 
        set(legendHandle0,'Position',[0.152407603096443 0.787783744239642 0.211654896903558 0.206626978719991]...
            ,'EdgeColor','none');
        annotation('rectangle',...
            [0.129717261904762 0.785505952380959 0.78997023809524 0.200327380952381]);
    end
    %绘制测点
    annotation('textbox',...
    [0.860215613466561 0.332577453622958 0.0556964285714286 0.102053571428571],...
    'String',{'12'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
    annotation('ellipse',...
        [0.864894139886581 0.362264150943396 0.046258979206049 0.0685275157232708]);
    annotation('line',[0.871455576559546 0.856332703213611],...
        [0.381132075471698 0.358490566037736]);

    annotation('textbox',...
        [0.777503455518374 0.502382887800417 0.0556964285714285 0.102053571428572],...
        'String','10',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    annotation('ellipse',...
        [0.781719771131518 0.533636879804333 0.046258979206049 0.066488120195667]);
    annotation('line',[0.786389413988658 0.771266540642722],...
        [0.547169811320755 0.520754716981132]);
    
    annotation('ellipse',...
        [0.139141525074246 0.569811320754717 0.0480040325817087 0.0700011792452833]);
    annotation('line',[0.166351606805293 0.164461247637051],...
        [0.520754716981132 0.569811320754717]);
    annotation('textbox',...
        [0.142486646134069 0.539983857861464 0.0556964285714285 0.100354585534762],...
        'String','1',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    
    annotation('ellipse',...
        [0.140791091786212 0.20325 0.046258979206049 0.0643970588235303]);
    annotation('line',[0.164834891103688 0.166351606805293],...
        [0.266484413120087 0.314705882352941]);
    annotation('textbox',...
        [0.144562443170938 0.173584905660377 0.0556964285714287 0.1007769145394],...
        'String','1',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    if isSaveFigure
        set(chartGca,'color','none');
        folderPath = fullfile(getPlotOutputPath(),'ch07');
        figName = '弯头式双容-理论模拟实验对比';
        if isEnglish
            export_fig(fullfile(folderPath,sprintf('%s.eps',figName)));
        else
            saveFigure(fullfile(getPlotOutputPath(),'ch07'),'弯头式双容-理论模拟实验对比');
        end
    end
end
%% 绘制脉动抑制率
%获取单一缓冲罐的数据
if 0
    %计算脉动抑制率
    if isEnglish
        xlabelText = 'Distance(m)';
        xTopText = 'Measurement Points';
        ylabelText = 'Sr(%)';
    else
        xlabelText = '实验测点';
        xTopText = '测点';
        ylabelText = '脉动抑制率(%)';
    end
    expRangStraightLinkVesselMapToSingle = [1,2,6,7,8,9,10,11,12,13];
    expRangElbowLinkVesselMapToSingle = [1,2,4,5,6,7,8,9,10,11,12,13];
    tmp = mean(expSingleVesselCombineData.readPlus);
    suppressionRateBase{1} = tmp(expRangStraightLinkVesselMapToSingle);
    suppressionRateBase{2} = tmp(expRangElbowLinkVesselMapToSingle);
    [ meanValSingleVessel,stdValSingleVessel,maxValSingleVessel,minValSingleVessel ...
        ,muciSingleVessel,sigmaciSingleVessel] = constExpVesselPressrePlus(420);
    xSuppressionRate = {expRangStraightLinkVesselMapToSingle,expRangElbowLinkVesselMapToSingle};
%     xSuppressionRate = {xStraightLinkVessel,xElbowLinkVessel};
    expRang = {expRangStraightDV,expRangElbowLinkVessel};
    legendText = {'双容串联','弯头式双容'};
    expStraightLinkCombineData.readPlus(:,1:2) = expStraightLinkCombineData.readPlus(:,1:2) .* 0.9;
    figure
    paperFigureSet('small',6);
    fh = figureExpPressurePlusSuppressionRate({expStraightLinkCombineData,expElbowLinkCombineData}...
        ,legendText...        
        ,'errorPlotType','bar'...
        ,'showVesselRigon',0 ...
        ,'xs',xSuppressionRate ...
        ,'rangs',expRang...
        ,'suppressionRateBase',suppressionRateBase...
        ,'xIsMeasurePoint',1 ...
        ,'figureHeight',6 ...
        ,'xlabelText',xlabelText...
        ,'xTopText',xTopText...
        ,'ylabelText',ylabelText...
        ,'isFigure',false...
        );
    ylim([-20,100]);
    xlim([0,14]);
    set(fh.legend,'Position',[0.550480330382233 0.23224537457581 0.335138882580731 0.167569440239006]);
    if isSaveFigure
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch07'),'普通双容与弯头式双容脉动抑制率对比');
    end
end
%% 绘制倍频特性
if 0
    if isEnglish
        tte = 'TTE';
        esste = 'ESSTE';
        xlabelText='Distance(m)';
        ylabelText='Amplitude(kPa)';
        lengthText = {'TTE f=14Hz','TTE f=28Hz','ESSTE f=2814Hz','ESSTE f=28Hz'};
    else
        tte = '双容串联';
        esste = '弯头式双容';
        xlabelText='距离(m)';
        ylabelText='幅值(kPa)';
        lengthText = {'双容串联 f=14Hz','双容串联 f=28Hz','弯头式双容 f=14Hz','弯头式双容 f=28Hz'};
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
    box on;
    if isSaveFigure
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch07'),'双容串联与弯头式双容1,2倍频对比');
    end
end

