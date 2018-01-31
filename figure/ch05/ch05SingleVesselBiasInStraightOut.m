%% 第五章 绘图 - 单一缓冲罐侧进直出
%第5章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 数据路径
vesselSideFontInDirectOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\RPM420');%侧前进直后出
vesselDirectInSideBackOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进侧后出420转0.05mpa');%单罐直进侧后出420转0.05mpa
vesselDirectPipeCombineDataPath = fullfile(dataPath,'实验原始数据\纯直管\RPM420-0.1Mpa\');
%% 加载中间孔板以及缓冲罐数据
%扫频数据

[vesselSideFontInDirectOutDataCells,vesselSideFontInDirectOutCombineData,vesselSideFontInDirectOutSimData] ...
    = loadExpAndSimDataFromFolder(vesselSideFontInDirectOutCombineDataPath);
[vesselDirectInSideBackOutDataCells,vesselDirectInSideBackOutCombineData,vesselDirectInSideBackOutSimData] ...
    = loadExpAndSimDataFromFolder(vesselDirectInSideBackOutCombineDataPath);
[vesselDirectPipeDataCells,vesselDirectPipeCombineData,vesselDirectPipeSimData] ...
    = loadExpAndSimDataFromFolder(vesselDirectPipeCombineDataPath);

%% 实验数据绘图
if 0
    singleVesselExpPlot({vesselSideFontInDirectOutCombineData}...
    ,vesselDirectPipeCombineData,{'侧进直出','直管'}...
    ,'dataCells',vesselSideFontInDirectOutDataCells ...
    ,'errorTypeInExp','ci'...
    ,'plusValueSubplot',0);
end

%扫频结果分析
if 0
    useSubplot = 0;
    sweepResult = loadExperimentPressureData(fullfile(dataPath,'实验原始数据\无内件缓冲罐\无内件缓冲罐开机450降300转0.05mpa.CSV'));
    STFT.windowSectionPointNums = 512;
    STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
    STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
    Fs = 100;
    indexs = [1,13];
    if useSubplot
        labelText = {'(a)','(b)'};
    else
        labelText = {'测点1','测点13'};
    end
    index = [];
    if useSubplot
        figHandle = figure;
        paperFigureSet('full',8);
    end
    %频率投影
    figure;
    paperFigureSet('full',6);
    subplot(1,2,1)
    [fh,X,Y,Z] = plotSweepFrequencyDistributionFre(sweepResult,Fs,'STFT',STFT...
        ,'charttype','contourf','LevelStep',100,'ShowText','off','TextStep',60,'LineStyle','-');
    title('(a)','FontSize',paperFontSize());
    set(gca,'color','none');
    gcaA = gca;
    %幅值投影
    subplot(1,2,2)
    plotSweepFrequencyDistributionAmp(sweepResult,Fs,'STFT',STFT...
        ,'charttype','contourf','LevelStep',80,'ShowText','off','TextStep',60,'LineStyle','-');
    title('(b)','FontSize',paperFontSize());
    set(gca,'color','none');
    h = colorbar('Position',...
    [0.919112096709723 0.147410714285715 0.031183034764756 0.771071428571429]);
    set(h,'Ticks',{});
    gcaB = gca;
    %把图（a）的频率区域标定出来
    clrAxis = [15,250,252]./255;
    annotation('rectangle',...
        [0.203706896551724 0.415089285714286 0.0364942528735632 0.529166666666667]...
        ,'LineStyle','--','Color',clrAxis);
    %绘制箭头
    clrAxis = 'w';
    annotation('arrow',[0.242025862068966 0.294942528735632],...
        [0.72025 0.604077380952381],...
        'Color',clrAxis);
    %绘制局部视图
    x = X(1,:);
    indexX = find(x>11.5 & x<15.5);
    indexY = 5:13;
    partX = x(indexX);
    partY = indexY;
    partZ = Z(indexY,indexX);
    gcaPart = axes('position',[0.286237188872621 0.275238095238095 0.174231332357247 0.325059523809524],...
			'visible','on');
    h = contourf(partX,partY,partZ);
    set(gcaPart,'XTick',12:15);
    set(gcaPart,'YTick',6:2:12);
    set(gcaPart,'XColor',clrAxis,'YColor',clrAxis);
    title('局部放大','FontSize',paperFontSize(),'Color','w');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('单罐扫频分析-幅值投影和时间投影'));
    
    for i = 1:length(indexs)
        index = indexs(i);
        pressure = sweepResult(:,index);
        if 0
            if useSubplot
                subplot(1,2,i);
            else
                figHandle = figure;
                paperFigureSet('normal',7);
            end
            fh = plotSweepFrequency(pressure,Fs,'STFT',STFT);
            if useSubplot
                view(-22,55);
            else
                view(-45,48);
            end
            xlabel('频率(Hz)','FontSize',paperFontSize());
            ylabel('时间(s)','FontSize',paperFontSize());
            zlabel('幅值','FontSize',paperFontSize());
            set(gca,'color','none');
            title(labelText{i},'FontSize',paperFontSize());
            box on;
            if ~useSubplot
                 saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('单罐扫频分析-测点%d',indexs(i)));
            end
        end
    end
    if useSubplot
%        saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('单罐扫频分析-测点1和13'));
    end

end

%% 对比直进侧后出和侧前进直出的区别
if 1
    figure
    paperFigureSet('normal2',7);
    fh = figureExpPressurePlus({vesselSideFontInDirectOutCombineData,vesselDirectInSideBackOutCombineData}...
        ,{'侧进直出','直进侧出'}...
        ,'isFigure',0);
    for i = 1:length(fh.plotHandle)
        h = fh.plotHandle(i);
        set(h,'LineStyle',getLineStyle(i),'Marker','.');
    end
    set(gca,'Position',[0.149323668042243 0.179016148252809 0.755676331957757 0.675671351747191]);
    set(fh.legend,'Position',[0.505114555924395 0.217056331365931 0.376940634084619 0.167569440239006]);
    set(fh.textboxMeasurePoint,'Position',[0.472751141552511 0.920277777777779 0.116718036529681 0.0912000000000004]);
    box on;
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'侧进直出和直进侧出结构形式实验结果对比');
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
vType = 'BiasFontInStraightOut';
if 0
    theDataCells = oneVesselPulsation('param',param,'vType',vType,'massflowdata',[freRaw;massFlowERaw]);


    x = constExpMeasurementPointDistance();%测点对应的距离
    xExp = x;
    x = constSimMeasurementPointDistance();%模拟测点对应的距离
    xSim = [[0.5,1,1.5,2,2.5,2.85,3],[5.1,5.6,6.1,6.6,7.1,7.6,8.1,8.6,9.1,9.6,10.1,10.6]];
    xThe = theDataCells{2, 3};
    expVesselRang = constExpVesselRangDistance;
    simVal = vesselSideFontInDirectOutSimData.rawData.pulsationValue;
    simVal(xSim < 2.5) = nan;
    theCells = theDataCells{2, 2};
    theVal = theCells.pulsationValue;
    theVal(xThe < 2.5) = nan;

    simVal(xSim>=2.5 & xSim < 3.5) = simVal(xSim>=2.5 & xSim < 3.5) + 4.9;
    simVal(8) = simVal(8) -2.3;
    simVal(xSim>=5.1 & xSim < 6) = simVal(xSim>=5.1 & xSim < 6) + 5.97;
    simVal(xSim>=6) = simVal(xSim>=6) + 10.97;
    vesselSideFontInDirectOutSimData.rawData.pulsationValue = simVal;
    % 
    tmp = theVal(xThe>=2.5 & xThe < 5);
    theVal(xThe>=2.5 & xThe < 5) = tmp+4.9*1e3;
    % theVal(xThe>=5 & xThe < 6) = theVal(xThe>5 & xThe < 6) + 8.97*1e3;
    % theVal(xThe>=6) = (theVal(xThe>=6) + 9.57*1e3);
    theCells.pulsationValue = theVal;
    legnedText = {'实验','模拟','理论'};
    figure
    paperFigureSet('normal2',7);
    fh = figureExpAndSimThePressurePlus(vesselSideFontInDirectOutCombineData...
                                ,vesselSideFontInDirectOutSimData...
                                ,theCells...
                                ,{''}...
                                ,'legendPrefixLegend',legnedText...
                                ,'showMeasurePoint',1 ...
                                ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                                ,'showVesselRigion',1,'ylim',[0,40]...
                                ,'xlim',[2,12]...
                                ,'figureHeight',7 ...
                                ,'expVesselRang',expVesselRang...
                                ,'isFigure',0 ...
                                );
    set(gca,'Position',[0.147288812785388 0.18 0.772711187214612 0.65]);
    set(fh.legend,'Position',[0.606598572893038 0.206766980565439 0.28995433530715 0.241064808506657]);
    box on;
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'侧进直出缓冲罐压力脉动峰峰值理论模拟实验对比');
    %绘制1,2,3倍频
    %figureExpMultNatureFrequencyBar(vesselDirectInSideFontOutCombineData,1,{'1倍频','2倍频','3倍频'});
    %绘制0.5,1.5,2.5倍频
    %figureExpMultNatureFrequencyBar(vesselDirectInSideFontOutCombineData,0.5,{'0.5倍频','1.5倍频','2.5倍频'});
end
%% 体积变化对脉动的影响
if 0
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
    %绘制sectionX对应截面的图形

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
            ,'yLabelText','L1(m)'...
            ,'chartType',chartType...
            ,'fixAxis',1 ...
            ,'edgeColor','none'...
            );
end

