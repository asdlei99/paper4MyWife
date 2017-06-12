%% 处理预处理的dataStructCells
% 把dataStructCells的n组数据合并,主要用combineExprimentMatFile.m进行数据的合并
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
useGUI = 1;
%%
dataPath = getDataPath();
if useGUI
    [matDataName,matDataStructPath] = uigetfile({'*.mat'},'选择已经处理的mat文件',dataPath);
    matDataStructPath = fullfile(matDataStructPath,matDataName);
else
    matDataStructPath = fullfile(dataPath,'实验原始数据/缓冲罐内置孔板0.5D罐中间/开机420转带压.mat');
end

combineDataStruct = combineExprimentMatFile(matDataStructPath);
pointIndex = strfind(matDataStructPath,'.');
saveMatPath = matDataStructPath(1:pointIndex(end)-1);
saveMatPath = strcat(saveMatPath,'_combine.mat');
save(saveMatPath,'combineDataStruct');
