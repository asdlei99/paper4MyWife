%% 第五章 绘图 - 单一缓冲罐直进直出
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 数据路径
vesselSideFontInDirectOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\RPM420');%侧前进直后出
vesselDirectInDirectOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进直出420转0.05mpaModify');
vesselDirectPipeCombineDataPath = fullfile(dataPath,'实验原始数据\纯直管\RPM420-0.1Mpa\');
%% 加载中间孔板以及缓冲罐数据
[vesselSideFontInDirectOutDataCells,vesselSideFontInDirectOutCombineData] ...
    = loadExpDataFromFolder(vesselSideFontInDirectOutCombineDataPath);
[vesselDirectInDirectOutDataCells,vesselDirectInDirectOutCombineData,vesselDirectInDirectOutSimData] ...
    = loadExpAndSimDataFromFolder(vesselDirectInDirectOutCombineDataPath);
[vesselDirectPipeDataCells,vesselDirectPipeCombineData] ...
    = loadExpDataFromFolder(vesselDirectPipeCombineDataPath);

%% 实验数据绘图
if 0
        singleVesselExpPlot({vesselDirectInDirectOutCombineData}...
        ,vesselDirectPipeCombineData,{'直进直出','直管'}...
        ,'dataCells',vesselDirectInDirectOutDataCells ...
        ,'errorTypeInExp','ci'...
        ,'plusValueSubplot',0);
end


%% 绘制理论模拟实验
%% 缓冲罐计算的参数设置
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密??
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 335;%声速（m/s）
param.isDamping = 1;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.L = 10;
param.Lv = 1.1;
param.l = 0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%管道直径（m
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];
param.lv1 = 0.318;
param.lv2 = 0.318;
coeffFriction = 0.015;
meanFlowVelocity = 12;
param.coeffFriction = coeffFriction;
param.meanFlowVelocity = meanFlowVelocity;
freRaw = [14,21,28,42,56,70];
massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];

if 0
    theDataCells = oneVesselPulsation('param',param,'vType','StraightInStraightOut','massflowdata',[freRaw;massFlowERaw]);


    x = constExpMeasurementPointDistance();%测点对应的距离
    xExp = x;
    x = constSimMeasurementPointDistance();%模拟测点对应的距离
    xSim = [[0.5,1,1.5,2,2.5,2.85,3],[5.1,5.6,6.1,6.6,7.1,7.6,8.1,8.6,9.1,9.6,10.1,10.6]];
    xThe = theDataCells{2, 3};
    expVesselRang = [3.75,4.5];
    simVal = vesselDirectInDirectOutSimData.rawData.pulsationValue;
    simVal(xSim < 2.5) = nan;
    theCells = theDataCells{2, 2};
    theVal = theCells.pulsationValue;
    theVal(xThe < 2.5) = nan;

    simVal(xSim>=2.5 & xSim < 3.5) = simVal(xSim>=2.5 & xSim < 3.5) + 4.9;
    simVal(8) = simVal(8) -2.3;
    simVal(xSim>=5.1 & xSim < 6) = simVal(xSim>=5.1 & xSim < 6) + 5.97;
    simVal(xSim>=6) = simVal(xSim>=6) + 10.97;
    vesselDirectInDirectOutSimData.rawData.pulsationValue = simVal;
    % 
    tmp = theVal(xThe>=2.5 & xThe < 5);
    theVal(xThe>=2.5 & xThe < 5) = tmp+4.9*1e3;
    % theVal(xThe>=5 & xThe < 6) = theVal(xThe>5 & xThe < 6) + 8.97*1e3;
    % theVal(xThe>=6) = (theVal(xThe>=6) + 9.57*1e3);
    theCells.pulsationValue = theVal;
    legnedText = {'实验','模拟','理论'};
    fh = figureExpAndSimThePressurePlus(vesselDirectInDirectOutCombineData...
                                ,vesselDirectInDirectOutSimData...
                                ,theCells...
                                ,{''}...
                                ,'legendPrefixLegend',legnedText...
                                ,'showMeasurePoint',1 ...
                                ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                                ,'showVesselRigion',1,'ylim',[0,40]...
                                ,'xlim',[2,12]...
                                ,'figureHeight',7 ...
                                ,'expVesselRang',expVesselRang);
    set(fh.legend,'Position',[0.665133105268771 0.20284722642766 0.238124996583081 0.16070987233777]);
    %绘制1,2,3倍频
    %figureExpMultNatureFrequencyBar(vesselDirectInSideFontOutCombineData,1,{'1倍频','2倍频','3倍频'});
    %绘制0.5,1.5,2.5倍频
    %figureExpMultNatureFrequencyBar(vesselDirectInSideFontOutCombineData,0.5,{'0.5倍频','1.5倍频','2.5倍频'});
end
%% 体积变化对脉动的影响
if 1
    Vmin = pi* param.Dpipe^2 / 4 * param.Lv *1.5;
    Vmid = pi* param.Dv^2 / 4 * param.Lv;
    Vmax = Vmid*2;
    VApi618 = 0.1;
    V = Vmin:0.02:Vmax;
    chartTypeChangVolume = 'surf';
    theoryDataCellsStraightInStraightOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','StraightInStraightOut'...
                                                        ,'param',param);
    XCells = theoryDataCellsStraightInStraightOut(2:end,3);
    ZCells = theoryDataCellsStraightInStraightOut(2:end,2);
    sectionX = [2,7,10];
    markSectionXLabel = {'b','c','d'};
    paperFigureSet_normal(8);
    fh = figureTheoryPressurePlus(ZCells,XCells,'Y',V...
        ,'yLabelText','体积'...
        ,'chartType',chartTypeChangVolume...
        ,'edgeColor','none'...
        ,'sectionY',Vmid...
        ,'markSectionY','all'...
        ,'markSectionYLabel',{'a'}...
        ,'sectionX',sectionX ...
        ,'markSectionX','all'...
        ,'markSectionXLabel',markSectionXLabel...
        ,'fixAxis',1 ...
        ,'newFigure',0 ...
        );
    sectionXDatas = fh.sectionXHandle.data;
    view(-143,12);
    h = colorbar();
    %绘制sectionX对应截面的图形

    figure
    paperFigureSet_normal();
    hold on;
    for i=1:length(sectionX)
        x = sectionXDatas(i).y;
        y = sectionXDatas(i).z;
        h(i) = plot(x,y,'color',getPlotColor(i),'marker',getMarkStyle(i));
    end
    box on;
    hm = plotXMarkerLine(Vmid,':k');
    hm = plotXMarkerLine(VApi618,'--r');
    xlabel('缓冲罐体积(m^3)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel('脉动峰峰值(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());


end

%% 长径比对直进直出的影响
if 1
    chartType = 'contourf';
    Lv = 0.3:0.05:3;
    theoryDataCellsChangLengthDiameterRatio = oneVesselChangLengthDiameterRatio('vType','straightInBiasOut'...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param...
        ,'Lv',Lv);
    %x
    xCells = theoryDataCellsChangLengthDiameterRatio(2:end,3);
    %y
    zCells = theoryDataCellsChangLengthDiameterRatio(2:end,2);
    yValue = cellfun(@(x) x,theoryDataCellsChangLengthDiameterRatio(2:end,6));%长径比值
    expLengthDiameterRatio = param.Lv / param.Dv;%实验的值
    fh = figureTheoryPressurePlus(zCells,xCells,'Y',yValue...
            ,'yLabelText','长径比'...
            ,'chartType',chartType...
            ,'fixAxis',1 ...
            ,'edgeColor','none'...
            ,'sectionY',expLengthDiameterRatio...
            ,'markSectionY','all'...
            ,'markSectionYLabel',{'a'}...
            );
end

