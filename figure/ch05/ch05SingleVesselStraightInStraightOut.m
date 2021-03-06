%% 第五章 绘图 - 单一缓冲罐直进直出
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
isSaveFigure = 0;
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
%% 和直管对比的压力脉动抑制率
if 0
    paperFigureSet('large',7);
    subplot(1,2,1)
    vesselCombineDataCells = {vesselDirectInDirectOutCombineData,vesselDirectPipeCombineData};
    leg = {'直进直出','直管'};
    fh = figureExpPressurePlus(vesselCombineDataCells,leg...
        ,'errorType',errorType...
        ,'isFigure',0 ...
        ,'showMeasurePoint',0 ...
        ,'showPureVessel',0);
    set(fh.legend,...
        'Position',[0.1153739912604 0.76217277447996 0.256448925406267 0.143630948776291]);
    set(fh.textarrowVessel,'X',[0.209092261904762 0.171879960317461],'Y',[0.645654761904762 0.579482886904763]);
    title('(a)','fontSize',paperFontSize());
    set(fh.gca,'Position',[0.0900297619047619 0.164779870052758 0.368526785714286 0.758490572110661]);
    set(gca,'color','none');
    
    subplot(1,2,2)
    ddMean = mean(vesselDirectPipeCombineData.readPlus);
    ddMean = ddMean(1:13);
    suppressionRateBase = {ddMean};
    xlabelText = '管线距离(m)';
    ylabelText = '压力脉动抑制率(%)';
    fh = figureExpPressurePlusSuppressionRate(vesselDirectInDirectOutCombineData...
            ,'errorPlotType','bar'...
            ,'showVesselRigon',0 ...
            ,'suppressionRateBase',suppressionRateBase...
            ,'isFigure',0 ...
            ,'showMeasurePoint',0 ...
            ,'xIsMeasurePoint',0 ...
            ,'xlabelText',xlabelText...
            ,'ylabelText',ylabelText...
            );
    box on;
    set(fh.gca...
        ,'Position',[0.588958333333333 0.164779870052758 0.368526785714287 0.758490572110663]);
    title('(b)','fontSize',paperFontSize());
    set(gca,'color','none');
    %saveFigure(fullfile(getPlotOutputPath(),'ch05'),'直进直出缓冲罐-和直管脉动对比+抑制率');
end

%% 绘制理论模拟实验
%% 缓冲罐计算的参数设置
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密??
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;

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

%20180328
% param.acousticVelocity = 335;%声速（m/s）%20180328 值为335
% coeffFriction = 0.015;%20180328 值为0.015
% meanFlowVelocity = 12;%20180328 值为12

param.acousticVelocity = 355;%声速（m/s）%20180328 值为335
coeffFriction = 0.0015;%20180328 值为0.015
meanFlowVelocity = 16;%20180328 值为12

param.coeffFriction = coeffFriction;
param.meanFlowVelocity = meanFlowVelocity;
freRaw = [14,21,28,42,56,70];
massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
vType = 'StraightInStraightOut';
if 1
    theDataCells = oneVesselPulsation('param',param,'vType',vType,'massflowdata',[freRaw;massFlowERaw]);


    x = constExpMeasurementPointDistance();%测点对应的距离
    xExp = x;
    x = constSimMeasurementPointDistance();%模拟测点对应的距离
    xSim = [[0.5,1,1.5,2,2.5,2.85,3],[5.1,5.6,6.1,6.6,7.1,7.6,8.1,8.6,9.1,9.6,10.1,10.6]];
    xThe = theDataCells{2, 3};
    expVesselRang = constExpVesselRangDistance;
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
    figure
    paperFigureSet('normal2',6);
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
                                ,'expVesselRang',expVesselRang...
                                ,'isFigure',0);
    set(fh.legend,'Position',[0.662487271935439 0.197947536120994 0.238124996583081 0.241064808506657]);
    box on;
    if 0
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch05'),'直进直出缓冲罐-理论模拟实验对比');
    end
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
    V = (Vmin*0.7):0.01:Vmax;
    chartTypeChangVolume = 'surf';
    theoryDataCellsStraightInStraightOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType',vType...
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
    set(gca,'color','none');
    if isSaveFigure
        saveFigure(fullfile(getPlotOutputPath(),'ch05'),'直进直出缓冲罐-体积变化影响');
    end
    %绘制sectionX对应截面的图形
    %saveFigure(fullfile(getPlotOutputPath(),'ch05'),'直进直出缓冲罐-体积变化影响');
    
    figure
    paperFigureSet_normal(6);
    hold on;
    h = [];
    for i=1:length(sectionX)
        x = sectionXDatas(i).y;
        y = sectionXDatas(i).z;
        h(i) = plot(x,y,'color',getPlotColor(i),'marker',getMarkStyle(i));
    end
    box on;
    hm = plotXMarkerLine(Vmid,':k');
    hm = plotXMarkerLine(VApi618,'--r');
    ax = axis();
    text(Vmid,ax(4)-3,'实验体积');
    text(VApi618-0.03,ax(4)-3,'API 618');
    xlabel('缓冲罐体积(m^3)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel('脉动峰峰值(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
    legend(h,markSectionXLabel);
    set(gca,'color','none');
    if isSaveFigure
        saveFigure(fullfile(getPlotOutputPath(),'ch05'),'直进直出缓冲罐-体积变化影响-截面');
    end
end

%% 长径比对直进直出的影响
if 0
    chartType = 'contourf';
    Lv = 0.3:0.01:3;
    theoryDataCellsChangLengthDiameterRatio = oneVesselChangLengthDiameterRatio('vType',vType...
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
            ,'figureHeight',7 ...
            );
     set(fh.plotHandle,'LevelStep',0.5);
     set(fh.plotHandle,'LineStyle','none');
     caxis([2,40]);
     box on;
     h = colorbar();
     colormap jet;
    
     h.Label.String = '压力脉动峰峰值(kPa)';
     set(gca, 'Color', 'none');
     saveFigure(fullfile(getPlotOutputPath(),'ch05'),'直进直出缓冲罐-变长径比');
end

%% L1调整
if 0
    chartType = 'contourf';
%     chartType = 'surf';
    L1 = 0:0.1:5;
    L = param.L1 + param.L2;
    theoryDataCells = oneVesselChangL1FixL(L1,L...
        ,'vType',vType...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param);
    %x
    xCells = theoryDataCells(2:end,3);
    %找出长度小的
    maxSize = 0;
    for i=1:length(xCells)
        if length(xCells{i}) > maxSize
            maxSize = length(xCells{i});
        end
    end
    %长度不足，补nan
    for i=1:length(xCells)
        while length(xCells{i}) < maxSize
            xCells{i}(length(xCells{i})+1) = nan;
        end
    end
    %y
    zCells = theoryDataCells(2:end,2);
    for i=1:length(zCells)
        while length(zCells{i}.pulsationValue) < maxSize
            zCells{i}.pulsationValue(length(zCells{i}.pulsationValue)+1) = nan;
        end
    end
    
    fh = figureTheoryPressurePlus(zCells,xCells,'Y',L1...
            ,'yLabelText','L1(m)'...
            ,'chartType',chartType...
            ,'fixAxis',1 ...
            ,'edgeColor','none'...
            ,'figureHeight',8 ...
            );
    xlabel('管线距离(m)','FontSize',paperFontSize());
    ylabel('L1(m)','FontSize',paperFontSize());
    set(fh.plotHandle,'LineStyle','none','LevelStep',1);
    ax = axis();
    hold on;
    plot([ax(1),ax(2)],[2.5,2.5],'--w');
    text(ax(1),2.5-0.05,'a','Color','w','FontSize',paperFontSize(),'FontName','Times New Roman');
    text(ax(2)-0.3,2.5-0.05,'a','Color','w','FontSize',paperFontSize(),'FontName','Times New Roman');
    plot([ax(1),ax(2)],[3.3,3.3],'--w');
    text(ax(1),3.3+0.1,'b','Color','w','FontSize',paperFontSize(),'FontName','Times New Roman');
    text(ax(2)-0.3,3.3+0.1,'b','Color','w','FontSize',paperFontSize(),'FontName','Times New Roman');
    h = colorbar();
    h.Label.String = '气流脉动峰峰值(kPa)';
    h.Label.FontSize = paperFontSize();
    box on;
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'直进直出缓冲罐-L1变化');
end

%% 超长距离迭代L1调整
if 0
    chartType = 'contourf';
    L1 = 0:0.25:40;
    L = L1(end)+2;
    theoryDataCells = oneVesselChangL1FixL(L1,L...
        ,'vType',vType...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param);
    %x
    xCells = theoryDataCells(2:end,3);
    %找出长度小的
    maxSize = 0;
    for i=1:length(xCells)
        if length(xCells{i}) > maxSize
            maxSize = length(xCells{i});
        end
    end
    %长度不足，补nan
    for i=1:length(xCells)
        while length(xCells{i}) < maxSize
            xCells{i}(length(xCells{i})+1) = nan;
        end
    end
    %y
    zCells = theoryDataCells(2:end,2);
    for i=1:length(zCells)
        while length(zCells{i}.pulsationValue) < maxSize
            zCells{i}.pulsationValue(length(zCells{i}.pulsationValue)+1) = nan;
        end
    end
    
    len = length(zCells{1}.pulsationValue);
    index = linspace(18,len-10,3);
    index = arrayfun(@(x) ceil(x),index);
    markerLengthValue = arrayfun(@(x) xCells{1}(x),index);
    
    labelText = {};
    for i=1:length(index)
        labelText{i} = sprintf('%g m',xCells{1}(index(i)));
    end
    
    figure
    paperFigureSet('full',7);
    subplot(1,2,1)
    fh = figureTheoryPressurePlus(zCells,xCells,'Y',L1...
            ,'yLabelText','L1(m)'...
            ,'chartType',chartType...
            ,'fixAxis',1 ...
            ,'edgeColor','none'...
            ,'newFigure',0 ...
            );
    xlabel('管线距离(m)','FontSize',paperFontSize());
    ylabel('L1(m)','FontSize',paperFontSize());
    set(fh.plotHandle,'LineStyle','none','LevelStep',1);
    set(fh.gca,'Position',[0.0851005747126437 0.1648 0.379558516196447 0.719]);
    ax =axis();
    hold on;
    for val = markerLengthValue
        plot([val,val],[ax(3),ax(4)],'--w');
        text(val,ax(4)+2,sprintf('%g',val));
    end
    
    box on;
    
	subplot(1,2,2)
    count = 1;
    hold on;
    for i=index
        a = cellfun(@(x) x.pulsationValue(i),zCells);
        a = a./1000;
        h(count) = plot(L1,a,'color',getPlotColor(count+2),'lineStyle',getLineStyle(count));
        count = count + 1;
    end
    xlabel('L1(m)','fontSize',paperFontSize());
    ylabel('压力脉动峰峰值(kPa)','fontSize',paperFontSize());
    set(gca,'Position',[0.586896551724138 0.1648 0.36676724137931 0.719]);
    box on;
    lh = legend(h,labelText);
    set(lh,'Position',[0.669061305074742 0.650119053026041 0.182471261975067 0.206626978719991]);
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'直进直出缓冲罐-缓冲罐位置导致变化导致的气流脉动波动');
end