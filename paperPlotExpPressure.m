%% �ֶ������������ֵ
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%
isUseGUI = 1;

if isUseGUI
    dataPath = getDataPath();
    dataFileCellPath = uigetfile({'*.mat'},'�����ļ���',dataPath);
    if isempty(dataFileCellFolder) || isnumeric(dataFileCellPath)
        return;
    end
    prompt={'������:',...
            '��ȡ�ṹ�ڵ���:'};
    name='�����������';
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
