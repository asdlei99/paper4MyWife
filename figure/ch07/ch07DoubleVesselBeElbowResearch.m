%% 第七章 绘图 - 双罐罐二做弯头理论分析对比
%第七章画图的参数设置clear all;
close all;
clear all;
clc;
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
%% 冲击脉动响应
if 0
    shockResponseBeElbowDataCells = doubleVesselBeElbowShockResponse('meanflowvelocity',25.51);
    shockResponseStraingDataCells = doubleVesselShockResponse('meanflowvelocity',25.51);
    
    dataCells = {shockResponseBeElbowDataCells{2, 2}...
        ,shockResponseStraingDataCells{2, 2}};
    legendLabels = {shockResponseBeElbowDataCells{2, 1}...
        ,shockResponseStraingDataCells{2, 1}};
    xs = {shockResponseBeElbowDataCells{2, 3}...
        ,shockResponseStraingDataCells{2, 3}};
    
    fhBeElbow = figureShockSpectrumContourf(dataCells,{'(a)','(b)'}...
        ,'x',xs...
        ,'LevelList',0:10000:60000 ...
        ,'figureHeight',6 ...
        ,'xlim',[0,100] ...
        ,'xlabel','频率(Hz)'...
        ,'ylabel','管线距离(m)'...
        );
    set(fhBeElbow.contourfHandle(1).contourfHandle,'LevelList',0:5000:60000);
    set(fhBeElbow.contourfHandle(2).contourfHandle,'LevelList',0:5000:60000);
end
%% 改变第二个缓冲罐到第一个缓冲罐距离对脉动的影响
if 0 % 改变第二个缓冲罐到第一个缓冲罐距离对脉动的影响
    
    % 绘制 x:管线距离 y:连接两罐的距离 z:脉动峰峰值
    theoryDataCells = doubleVesselBeElbowChangDistanceToFirstVessel('massflowdata',[freRaw;massFlowERaw]...
        ,'meanFlowVelocity',14);
    plusValue = theoryDataCells(2:end,2);
    X = theoryDataCells(2:end,3);
    legendLabels = theoryDataCells(2:end,1);
    linkPipeLength = cell2mat(theoryDataCells(2:end,5));
    if 0
        xlabelText = 'distance(m)';
        ylabelText = 'connect distance(m)';
        zLabelText = 'pressure plus(kPa)';
    else
        xlabelText = '管线距离(m)';
        ylabelText = '连接管长(m)';
        zLabelText = '压力脉动峰峰值(kPa)';
    end
    figure;
    paperFigureSet_large(6);
    subplot(1,2,1)

    fh = figureTheoryPressurePlus(plusValue,X...
        ,'Y',linkPipeLength...
        ,'legendLabels',legendLabels...
        ,'xLabelText',xlabelText...
        ,'yLabelText',ylabelText...
        ,'zLabelText',zLabelText...
        ,'chartType','contourf'...
        ,'edgeColor','none'...
        ,'newFigure',0 ...
    );
    set(fh.plotHandle,'LevelList',0:3:25,'showText','on');
    xlim([0,10.37]);
    box on;
    colorbarHandle = colorbar;
    set(gca,...
    'Position',[0.0789732142857141 0.192364165480092 0.334659090909091 0.732635834519908]);
%     ax = axis;
%     plot([X{1}(1),X{1}(1)],[linkPipeLength(1),linkPipeLength(end)],'color','w');
    set(colorbarHandle,'Position',...
    [0.423227934535719 0.189618055555556 0.0308995532304277 0.732013888888889]);
    title('(a)');
    % 对上图的罐前和罐后测点的趋势进行绘制
    subplot(1,2,2)
    for i=2:size(theoryDataCells,1)
        Y1(i-1) = theoryDataCells{i, 2}.pulsationValue(end);
        Y2(i-1) = theoryDataCells{i, 2}.pulsationValue(1);
    end
    plot(linkPipeLength,Y1./1000,'--');
    hold on;
    plot(linkPipeLength,Y2./1000,'-');
    xlabel(ylabelText);
    ylabel(zLabelText);
    set(gca,...
    'Position',[0.617587932900433 0.192364165480092 0.334659090909091 0.732635834519909]);
    annotation('textarrow',[0.794955357142858 0.753377976190477],...
    [0.770902777777779 0.651840277777779],'String',{'罐后测点'});
    annotation('textarrow',[0.728809523809524 0.764717261904762],...
    [0.329930555555556 0.404895833333334],'String',{'罐前测点'});
    title('(b)');
end

%% 研究改变长径比对脉动的影响
if 0
    param.acousticVelocity = 345;%声速
    param.isDamping = 1;%是否计算阻尼
    param.coeffFriction = 0.003;%管道摩察系数
    param.coeffFriction = 0.045;
    param.meanFlowVelocity = 14;%14.6;%管道平均流速
    param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
    param.rpm = 420;
    param.outDensity = 1.5608;
    param.Fs = 4096;
    param.L1 = 3.5;%L1(m)
    param.L2 = 1.5;%1.5;%双罐串联罐二作弯头两罐间距
    param.L3 = 4;%4%双罐串联罐二作弯头出口管长
    param.Dpipe = 0.098;%管道直径（m）%应该是0.106
    param.l = 0.01;
    param.DV1 = 0.372;%缓冲罐的直径（m）
    param.LV1 = 1.1;%缓冲罐总长 （1.1m）
    param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
    param.LV2 = 1.1;%variant_r(i).*param.DV2;%缓冲罐总长 （1.1m） 
    param.lv3 = 0.150+0.168;%针对单一偏置缓冲罐入口偏置长度
    param.Dbias = 0;%偏置管伸入罐体部分为0，所以对应直径为0
    param.sectionL1 = 0:0.25:param.L1;%[2.5,3.5];%0:0.25:param.L1
    param.sectionL2 = 0:0.25:param.L2;%[2.5,3.5];%0:0.25:param.L1
    param.sectionL3 = 0:0.25:param.L3;%[2.5,3.5];%0:0.25:param.L1
    param.notMach = 0;
    param.multFreTimes = 3;
    param.semiFreTimes = 3;
    param.allowDeviation = 0.5;
    param.beforeAfterMeaPoint = nan;
    param.calcPeakPeakValueSection = nan;
    param.notMach = 0;
    theoryDataCells =  doubleVesselBeElbowChangLengthDiameterRatio('massflowdata',[freRaw;massFlowERaw]...
        ,'param',param);
    plusValue = theoryDataCells(2:end,2);
    X = theoryDataCells(2:end,3);
    legendLabels = theoryDataCells(2:end,1);
    LengthDiameterRatio = cell2mat(theoryDataCells(2:end,6));
    if 0
        xlabelText = 'distance(m)';
        ylabelText = 'Length-DiameterRatio';
        zLabelText = 'pressure plus(kPa)';
    else
        xlabelText = '管线距离(m)';
        ylabelText = '长径比';
        zLabelText = '压力脉动峰峰值(kPa)';
    end
    fh = figureTheoryPressurePlus(plusValue,X...
        ,'Y',LengthDiameterRatio...
        ,'legendLabels',legendLabels...
        ,'xLabelText',xlabelText...
        ,'yLabelText',ylabelText...
        ,'zLabelText',zLabelText...
        ,'chartType','surf'...%'contourf'...
        ,'edgeColor','none'...
        ,'sectionX',[0,10] ...
        ,'markSectionX','all'...
        ,'markSectionXLabel',{'A','B'}...
        ,'sectionY',1.1 / 0.372 ...%默认长径比
        ,'markSectionY','all'...
        ,'markSectionYLabel',{'C'}...
        ,'fixAxis',1 ...
        ,'figureHeight',7 ...
    );
    xlim([0,10.37]);
    ylim([0,25]);
    box on;
    view(137,41);
    colorbar;
    %绘制a，b截面的投影图
    figure
    paperFigureSet_normal(7);
    linkPipeLength = cell2mat(theoryDataCells(2:end,6));
    for i=2:size(theoryDataCells,1)
        Y1(i-1) = theoryDataCells{i, 2}.pulsationValue(end);
        Y2(i-1) = theoryDataCells{i, 2}.pulsationValue(1);
    end
    plot(linkPipeLength,Y1./1000,'--');
    hold on;
    plot(linkPipeLength,Y2./1000,'-');
    xlabel(ylabelText);
    ylabel(zLabelText);
    annotation('textarrow',[0.39828125 0.4578125],...
        [0.723697916666667 0.783229166666667],'String',{'A-A'});
    annotation('textarrow',[0.393871527777778 0.455607638888889],...
        [0.528567708333333 0.39296875],'String',{'B-B'});
end


%%
if 1
    [X,Y,Z] = doubleVesselBeElbowChangLengthDiameterRatioAndV();
    figure
    paperFigureSet_normal(7);
    [c,f] = contourf(X,Y,Z);
    set(f,'levelList',1:500:14000);
end