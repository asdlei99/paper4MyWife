%% 第七章 绘图 - 双罐罐二做弯头理论分析对比
%第七章画图的参数设置clear all;
close all;
clc;
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
%% 冲击脉动响应
if 0
%     figure
%     shockResponseBeElbowDataCells = doubleVesselBeElbowShockResponse();
%     fhElbow = plotSpectrumContourf(shockResponseBeElbowDataCells{2, 2}.Mag'...
%         ,shockResponseBeElbowDataCells{2, 2}.Fre'...
%         ,shockResponseBeElbowDataCells{2,3}...
%         ,'isShowColorBar',1);
%     xlim([0,100]);
%     
%     shockResponseStraingDataCells = doubleVesselShockResponse();
%     figure
%     fhVessel = plotSpectrumContourf(shockResponseStraingDataCells{2, 2}.Mag'...
%         ,shockResponseStraingDataCells{2, 2}.Fre'...
%         ,shockResponseStraingDataCells{2,3}...
%         ,'isShowColorBar',1);
%     xlim([0,100]);
% set(fhVessel.contourfHandle,'LevelList',0:10000:60000);
    
    shockResponseBeElbowDataCells = doubleVesselBeElbowShockResponse();
    shockResponseStraingDataCells = doubleVesselShockResponse();
    
    dataCells = {shockResponseBeElbowDataCells{2, 2}...
        ,shockResponseStraingDataCells{2, 2}};
    legendLabels = {shockResponseBeElbowDataCells{2, 1}...
        ,shockResponseStraingDataCells{2, 1}};
    ys = {shockResponseBeElbowDataCells{2, 3}...
        ,shockResponseStraingDataCells{2, 3}};
    fhBeElbow = figureShockSpectrumContourf(dataCells{1},legendLabels{1},'y',ys{1}...
        ,'LevelList',0:10000:60000 ...
        ,'figureHeight',8 ...
        );
    xlabel('频率(Hz)');
    ylabel('幅值');
    xlim([0,100]);
    
    fhStraingConnectVessel = figureShockSpectrumContourf(dataCells{2},legendLabels{2},'y',ys{2}...
        ,'LevelList',0:10000:60000 ...
        ,'figureHeight',8 ...
        );
    xlabel('频率(Hz)');
    ylabel('幅值');
    xlim([0,100]);
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
    fh = figureTheoryPressurePlus(plusValue,X...
        ,'Y',linkPipeLength...
        ,'legendLabels',legendLabels...
        ,'xLabelText',xlabelText...
        ,'yLabelText',ylabelText...
        ,'zLabelText',zLabelText...
        ,'chartType','contourf'...
        ,'edgeColor','none'...
    );
    xlim([0,10.37]);
    box on;
    colorbar;

    
    
    
    % 对上图的罐前和罐后测点的趋势进行绘制
    figure
    paperFigureSet_normal();
    for i=2:size(theoryDataCells,1)
        Y1(i-1) = theoryDataCells{i, 2}.pulsationValue(end);
        Y2(i-1) = theoryDataCells{i, 2}.pulsationValue(1);
    end
    plot(linkPipeLength,Y1./1000,'--');
    hold on;
    plot(linkPipeLength,Y2./1000,'-');
    xlabel(ylabelText);
    ylabel(zLabelText);
    annotation('textarrow',[0.493090277777778 0.435763888888889],...
    [0.765692708333333 0.660859375],'String',{'罐后测点'});
    annotation('textarrow',[0.464427083333333 0.561440972222222],...
    [0.283828125 0.310286458333333],'String',{'罐前测点'});
end

%% 研究改变长径比对脉动的影响
if 1
    theoryDataCells =  doubleVesselBeElbowChangLengthDiameterRatio('massflowdata',[freRaw;massFlowERaw]...
        ,'meanFlowVelocity',14);
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
    );
    xlim([0,10.37]);
    ylim([0,25]);
    box on;
    view(137,41);
    colorbar;
    %绘制a，b截面的投影图
    figure
    paperFigureSet_normal();
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
