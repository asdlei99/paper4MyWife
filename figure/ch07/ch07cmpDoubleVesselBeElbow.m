%% 第七章 绘图 - 双罐罐二做弯头理论分析对比
%第七章画图的参数设置
clear all;
close all;
clc;
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
theoryDataCells = cmpDoubleVesselBeElbow('massflowdata',[freRaw;massFlowERaw]...
    ,'meanFlowVelocity',14);
plusValue = theoryDataCells(2:end,2);
X = theoryDataCells(2:end,3);
legendLabels = theoryDataCells(2:end,1);
fh = figureTheoryPressurePlus(plusValue,X...
    ,'legendLabels',legendLabels...
);