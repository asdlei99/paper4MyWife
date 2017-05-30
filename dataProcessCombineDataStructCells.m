%% 处理预处理的dataStructCells
% 把dataStructCells的n组数据合并,主要用combineExprimentMatFile.m进行数据的合并
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%
dataPath = getDataPath();
matDataStructPath = fullfile(dataPath,'实验原始数据/缓冲罐内置孔板0.5D罐中间/开机420转带压.mat');
combineDataStruct = combineExprimentMatFile(matDataStructPath);
pointIndex = strfind(matDataStructPath,'.');
saveMatPath = matDataStructPath(1:pointIndex(end)-1);
saveMatPath = strcat(saveMatPath,'_combine.mat');
save(saveMatPath,'combineDataStruct');