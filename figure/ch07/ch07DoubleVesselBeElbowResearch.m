%% 第七章 绘图 - 双罐罐二做弯头理论分析对比
%第七章画图的参数设置clear all;
close all;
clc;
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
%% 冲击脉动响应
if 1
    figure
    shockResponseBeElbowDataCells = doubleVesselBeElbowShockResponse();
    fh = plotSpectrumContourf(shockResponseBeElbowDataCells{2, 2}.Mag'...
        ,shockResponseBeElbowDataCells{2, 2}.Fre'...
        ,shockResponseBeElbowDataCells{2,3});
    xlim([0,100]);
    
    shockResponseStraingDataCells = doubleVesselShockResponse();
    figure
    fh = plotSpectrumContourf(shockResponseStraingDataCells{2, 2}.Mag'...
        ,shockResponseStraingDataCells{2, 2}.Fre'...
        ,shockResponseStraingDataCells{2,3});
    xlim([0,100]);
end
%% 改变第二个缓冲罐到第一个缓冲罐距离对脉动的影响
if 0 % 改变第二个缓冲罐到第一个缓冲罐距离对脉动的影响
    theoryDataCells = doubleVesselBeElbowChangDistanceToFirstVessel('massflowdata',[freRaw;massFlowERaw]...
        ,'meanFlowVelocity',14);
    plusValue = theoryDataCells(2:end,2);
    X = theoryDataCells(2:end,3);
    legendLabels = theoryDataCells(2:end,1);
    linkPipeLength = cell2mat(theoryDataCells(2:end,5));
    fh = figureTheoryPressurePlus(plusValue,X...
        ,'Y',linkPipeLength...
        ,'legendLabels',legendLabels...
        ,'yLabelText','接管长'...
        ,'chartType','surf'...
        ,'edgeColor','none'...
    );
end
