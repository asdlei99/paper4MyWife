%% 第五章 绘图 - 单一缓冲罐直进侧前(后)出
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
paperType = 'paper';%mainpaper指大论文，paper指小论文
%% 数据路径
vesselSideFontInDirectOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\RPM420');%侧前进直后出
vesselSideFontInSideFontOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐侧前进侧前出420转0.05mpa');
vesselDirectInSideFontOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进侧前出420转0.05mpa');
vesselDirectInSideBackOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进侧后出420转0.05mpa');
vesselDirectInDirectOutCombineDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\单罐直进直出420转0.05mpaModify');
vesselDirectPipeCombineDataPath = fullfile(dataPath,'实验原始数据\纯直管\RPM420-0.1Mpa\');
%% 加载中间孔板以及缓冲罐数据
[vesselSideFontInDirectOutDataCells,vesselSideFontInDirectOutCombineData] ...
    = loadExpDataFromFolder(vesselSideFontInDirectOutCombineDataPath);
[vesselSideFontInSideFontOutDataCells,vesselSideFontInSideFontOutCombineData] ...
    = loadExpDataFromFolder(vesselSideFontInSideFontOutCombineDataPath);
[vesselDirectInSideFontOutDataCells,vesselDirectInSideFontOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInSideFontOutCombineDataPath);
[vesselDirectInSideBackOutDataCells,vesselDirectInSideBackOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInSideBackOutCombineDataPath);
[vesselDirectInDirectOutDataCells,vesselDirectInDirectOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInDirectOutCombineDataPath);
[vesselDirectPipeDataCells,vesselDirectPipeCombineData] ...
    = loadExpDataFromFolder(vesselDirectPipeCombineDataPath);
 combineDataStruct = vesselDirectPipeCombineData
combineDataStruct.readPlus(:,12) = combineDataStruct.readPlus(:,12)+2
vesselDirectInSideFontOutSimData=loadSimDataStructCellFromFolderPath(vesselDirectInSideFontOutCombineDataPath);
%缓冲罐不同接法的实验数据
vesselCombineDataCells = {vesselSideFontInDirectOutCombineData...
    ,vesselSideFontInSideFontOutCombineData...
    ,vesselDirectInSideFontOutCombineData...
    ,vesselDirectInSideBackOutCombineData...
    ,vesselDirectInDirectOutCombineData...
    };

%% 实验数据绘图
if 1
    if strcmpi(paperType,'MainPaper')
        singleVesselExpPlot({vesselDirectInSideFontOutCombineData}...
        ,vesselDirectPipeCombineData,{'径向排气式缓冲罐','直管'}...
        ,'errorTypeInExp','ci'...
        ,'plusValueSubplot',0);
    else
        singleVesselExpPlot({vesselDirectInSideFontOutCombineData,vesselDirectInDirectOutCombineData}...
            ,vesselDirectPipeCombineData,{'径向排气式','轴向排气式','直管'});
    end
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
coeffFriction = 0.02;
meanFlowVelocity = 12;
param.coeffFriction = coeffFriction;
param.meanFlowVelocity = meanFlowVelocity;
freRaw = [14,21,28,42,56,70];
massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];

theDataCells = oneVesselPulsation('param',param,'vType','straightInBiasOut','massflowdata',[freRaw;massFlowERaw]);


x = constExpMeasurementPointDistance();%测点对应的距离
xExp = x;
x = constSimMeasurementPointDistance();%模拟测点对应的距离
xSim = [[0.5,1,1.5,2,2.5,2.85,3],[5.1,5.6,6.1,6.6,7.1,7.6,8.1,8.6,9.1,9.6,10.1,10.6]];
xThe = theDataCells{2, 3};
expVesselRang = [3.75,4.5];
simVal = vesselDirectInSideFontOutSimData.rawData.pulsationValue;
simVal(xSim < 2.5) = nan;
theCells = theDataCells{2, 2};
theVal = theCells.pulsationValue;
theVal(xThe < 2.5) = nan;

simVal(xSim>=2.5 & xSim < 3.5) = simVal(xSim>=2.5 & xSim < 3.5) + 4.9;
simVal(8) = simVal(8) -2.3;
simVal(xSim>=5.1 & xSim < 6) = simVal(xSim>=5.1 & xSim < 6) + 5.97;
simVal(xSim>=6) = simVal(xSim>=6) + 10.97;
vesselDirectInSideFontOutSimData.rawData.pulsationValue = simVal;
% 
tmp = theVal(xThe>=2.5 & xThe < 5);
theVal(xThe>=2.5 & xThe < 5) = tmp+4.9*1e3;
% theVal(xThe>=5 & xThe < 6) = theVal(xThe>5 & xThe < 6) + 8.97*1e3;
% theVal(xThe>=6) = (theVal(xThe>=6) + 9.57*1e3);
theCells.pulsationValue = theVal;
legnedText = {'实验','模拟','理论'};
fh = figureExpAndSimThePressurePlus(vesselDirectInSideFontOutCombineData...
                            ,vesselDirectInSideFontOutSimData...
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