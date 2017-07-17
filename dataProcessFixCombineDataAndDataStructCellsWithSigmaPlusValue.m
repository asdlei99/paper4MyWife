%% 修正 - 把sigmaPlusValue.mat数据合并到combineDataStruct.mat和dataStructCells.mat当中
% 此程序在dataProcessForOneFolderExpFileAndCombine或dataProcessCombineDataStructCells发生变更时调用
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
useGUI = 1;
%% 
if useGUI
    dataPath = getDataPath();
    dataFileFolder = uigetdir(dataPath,'数据文件夹');
    if isempty(dataFileFolder) || isnumeric(dataFileFolder)
        return;
    end
else
    dataFileFolder = '';
end
fixCombineDataAndDataStructCellsWithSigmaPlusValue(dataFileFolder);
msgbox('合并完成');