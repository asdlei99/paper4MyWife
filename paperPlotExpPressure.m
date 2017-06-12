%% 手动定义脉动峰峰值
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%
isUseGUI = 1;

if isUseGUI
    dataPath = getDataPath();
    dataFileCellPath = uigetfile({'*.mat'},'数据文件夹',dataPath);
    if isempty(dataFileCellFolder) || isnumeric(dataFileCellPath)
        return;
    end
    prompt={'采样率:',...
            '提取结构节点名:'};
    name='输入基本参数';
    numlines=1;
    defaultanswer={'100','rawData'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    fs = str2num(answer{1});
    baseField = answer{2};
else
    dataFileCellPath = '';
    fs = 100;
    baseField = 'rawData';
end
