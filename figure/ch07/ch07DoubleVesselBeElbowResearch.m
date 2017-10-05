%% 第七章 绘图 - 双罐罐二做弯头理论分析对比
%第七章画图的参数设置clear all;
% close all;
clc;
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
%% 冲击脉动响应
if 1
    theoryDataCells = doubleVesselBeElbowShockResponse();
    fh = plotSpectrumContourf(theoryDataCells{1, 2}.Mag',theoryDataCells{1, 2}.Fre',theoryDataCells{1,3});
    xlim([0,100]);
end
%% 改变第二个缓冲罐到第一个缓冲罐距离对脉动的影响
if 1 % 改变第二个缓冲罐到第一个缓冲罐距离对脉动的影响
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
