%% ���� - ��sigmaPlusValue.mat���ݺϲ���combineDataStruct.mat��dataStructCells.mat����
% �˳�����dataProcessForOneFolderExpFileAndCombine��dataProcessCombineDataStructCells�������ʱ����
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
useGUI = 1;
%% 
if useGUI
    dataPath = getDataPath();
    dataFileFolder = uigetdir(dataPath,'�����ļ���');
    if isempty(dataFileFolder) || isnumeric(dataFileFolder)
        return;
    end
else
    dataFileFolder = '';
end
fixCombineDataAndDataStructCellsWithSigmaPlusValue(dataFileFolder);
msgbox('�ϲ����');