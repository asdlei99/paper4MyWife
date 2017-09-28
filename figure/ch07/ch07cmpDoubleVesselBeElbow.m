%% 第七章 绘图 - 双罐罐二做弯头理论分析对比
%第七章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 加载实验数据
expStraightLinkCombineDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\双缓冲罐串联420转0.1mpa');
expElbowLinkCombineDataPath = fullfile(dataPath,'实验原始数据\双缓冲罐研究\双缓冲罐串联罐二当弯头420转0.1mpa');
%加载实验数据 及 模拟数据
[expStraightLinkDataCells,expStraightLinkCombineData,simStraightLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expStraightLinkCombineDataPath);
[expElbowLinkDataCells,expElbowLinkCombineData,simElbowLinkDataCells] ...
    = loadExpAndSimDataFromFolder(expElbowLinkCombineDataPath);
legendText = {'双缓冲罐串联','双缓冲罐弯头串联'};
%% 绘制实验对比分析
xSim = {};
figureExpPressurePlus({expStraightLinkCombineData,expElbowLinkCombineData});
xSim{1} = 1:length(simStraightLinkDataCells.rawData.pulsationValue);
xSim{1} = xSim{1}.*0.5;
xSim{2} = 1:length(simElbowLinkDataCells.rawData.pulsationValue);
xSim{2} = xSim{2}.*0.5;
figureExpAndSimPressurePlus({expStraightLinkCombineData,expElbowLinkCombineData}...
                        ,{simStraightLinkDataCells,simElbowLinkDataCells},legendText,'xsim',xSim);
%% 理论对比分析-对比{'直管';'单一缓冲罐';'直进侧前出';'双罐-罐二作弯头';'双罐无间隔串联'}
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
theoryDataCells = cmpDoubleVesselBeElbow('massflowdata',[freRaw;massFlowERaw]...
    ,'meanFlowVelocity',14);
theAnalysisRow = 5:6;
plusValue = theoryDataCells(theAnalysisRow,2);%通过此函数的行索引设置不同的对比值
X = theoryDataCells(theAnalysisRow,3);
legendLabels = theoryDataCells(theAnalysisRow,1);
fh = figureTheoryPressurePlus(plusValue,X...
    ,'legendLabels',legendLabels...
);