%% ����Ԥ�����dataStructCells
% ��dataStructCells��n�����ݺϲ�,��Ҫ��combineExprimentMatFile.m�������ݵĺϲ�
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
useGUI = 1;
%%
dataPath = getDataPath();
if useGUI
    [matDataName,matDataStructPath] = uigetfile({'*.mat'},'ѡ���Ѿ������mat�ļ�',dataPath);
    matDataStructPath = fullfile(matDataStructPath,matDataName);
else
    matDataStructPath = fullfile(dataPath,'ʵ��ԭʼ����/��������ÿװ�0.5D���м�/����420ת��ѹ.mat');
end

combineDataStruct = combineExprimentMatFile(matDataStructPath);
pointIndex = strfind(matDataStructPath,'.');
saveMatPath = matDataStructPath(1:pointIndex(end)-1);
saveMatPath = strcat(saveMatPath,'_combine.mat');
save(saveMatPath,'combineDataStruct');
