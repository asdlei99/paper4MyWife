%% ����Ԥ�����dataStructCells
% ��dataStructCells��n�����ݺϲ�,��Ҫ��combineExprimentMatFile.m�������ݵĺϲ�
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%
dataPath = getDataPath();
matDataStructPath = fullfile(dataPath,'ʵ��ԭʼ����/��������ÿװ�0.5D���м�/����420ת��ѹ.mat');
combineDataStruct = combineExprimentMatFile(matDataStructPath);
pointIndex = strfind(matDataStructPath,'.');
saveMatPath = matDataStructPath(1:pointIndex(end)-1);
saveMatPath = strcat(saveMatPath,'_combine.mat');
save(saveMatPath,'combineDataStruct');