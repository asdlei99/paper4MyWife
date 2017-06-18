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

[combineDataStruct,rpm] = combineExprimentMatFile(matDataStructPath);

%计算缓冲罐的数据
vesselCombineDataStruct = getPureVesselCombineDataStruct(rpm);
combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'rawData');
combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'subSpectrumData');
combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'saMainFreFilterStruct');
combineDataStruct.descripe = {'readPlus是人为读取的压力脉动数据';'readSuppressionLevel是人为读取数据和单一缓冲罐进行的脉动抑制率计算'...
    ;'带SL结尾的是和单一缓冲罐进行对比的抑制率如multFreMag1SL'};

pointIndex = strfind(matDataStructPath,'.');
saveMatPath = matDataStructPath(1:pointIndex(end)-1);
saveMatPath = strcat(saveMatPath,'_combine.mat');
save(saveMatPath,'combineDataStruct');


