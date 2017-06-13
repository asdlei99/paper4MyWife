%% 绘制数据压力的程序
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%% 参数输入
isUseGUI = 0;

if isUseGUI
    dataPath = getDataPath();
    [dataFileCellPath,floderName] = uigetfile({'*.mat'},'数据文件夹',dataPath);
    if isempty(dataFileCellPath) || isnumeric(dataFileCellPath)
        return;
    end
    dataFileCellPath = fullfile(floderName,dataFileCellPath);
    prompt={'采样率:',...
            '提取结构节点名:'...
            ,'绘制第几组压力数据:[1~5]'...
            ,'绘制测点几的数据:[1~13]'};
    name='输入基本参数';
    numlines=1;
    defaultanswer={'100','rawData','1','1'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    if isempty(answer)
        return;
    end
    fs = str2double(answer{1});
    baseField = answer{2};
    groupNum = str2double(answer{3});
    meaPoint = str2double(answer{4});
else
    dataPath = getDataPath();
    dataFileCellPath = fullfile(dataPath,'实验原始数据\内插孔管\0.5D孔管全堵\缓冲罐内插0.5D孔管中间全堵.mat');
    fs = 100;%采样率
    baseField = 'rawData';%提取结构节点名
    groupNum = 1;%绘制第几组压力数据:[1~5]
    meaPoint = 1;%绘制测点几的数据:[1~13]
end
%% 绘图
pressureDatas = getExpPressureDatas(dataFileCellPath,groupNum,baseField);
figure
plotExpPressurePlus(pressureDatas,meaPoint,fs,'color','b');
