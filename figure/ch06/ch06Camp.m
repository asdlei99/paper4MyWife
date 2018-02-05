%% 第六章 绘图 - 相同同流面积压力脉动对比
%第六章画图的参数设置
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
isSaveFigure = 1;
%% 数据路径
orificD1CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D1RPM420罐中间');
perforateD01N28DataPath = fullfile(dataPath,'实验原始数据\内插孔管\D1N28d20RPM420两头堵');
innerPipeD1CombineDataPath = fullfile(dataPath,'实验原始数据\内插管\内插管1D罐中间420转0.05mpa');

orificD0_5CombineDataPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.5RPM420罐中间');
perforateD0_5N28DataPath = fullfile(dataPath,'实验原始数据\内插孔管\D0.5N20RPM420两头堵');
innerPipeD0_5CombineDataPath = fullfile(dataPath,'实验原始数据\内插管\内插管0.5D中间420转0.05mpa');
%% 加载内插管以及缓冲罐数据
%0.5D,0.75D,1D孔板的实验模拟数据

[expOrificD01ataCells,expOrificD01CombineData] ...
    = loadExpDataFromFolder(orificD1CombineDataPath);
[expPerforateD01N28DataCells,expPerforateD01N28CombineData] ...
    = loadExpDataFromFolder(perforateD01N28DataPath);
[expInnerPipe01DataCells,expInnerPipe01CombineData] ...
    = loadExpDataFromFolder(innerPipeD1CombineDataPath);

[expOrificD0_5ataCells,expOrificD0_5CombineData] ...
    = loadExpDataFromFolder(orificD0_5CombineDataPath);
[expPerforateD0_5N28DataCells,expPerforateD0_5N28CombineData] ...
    = loadExpDataFromFolder(perforateD0_5N28DataPath);
[expInnerPipe0_5DataCells,expInnerPipe0_5CombineData] ...
    = loadExpDataFromFolder(innerPipeD0_5CombineDataPath);

%对比单孔
innerElementDataCells1D = {expOrificD01CombineData,expInnerPipe01CombineData,expPerforateD01N28CombineData};
legendLabels1D = {'1D孔板','1D内插管','1D内插孔管'};

innerElementDataCells0_5D = {expOrificD0_5CombineData,expInnerPipe0_5CombineData,expPerforateD0_5N28CombineData};
legendLabels0_5D = {'0.5D孔板','0.5D内插管','0.5D内插孔管'};


%% 绘制多组压力脉动
if 1
	paperPlotInnerElementExpCmp1D(innerElementDataCells1D...
        ,legendLabels1D...
        ,isSaveFigure...
        );
end

%% 绘制多组压力降低
if 1
    paperPlotInnerElementExpCmp0_5D(innerElementDataCells0_5D...
        ,legendLabels0_5D...
        ,isSaveFigure...
        );
end

