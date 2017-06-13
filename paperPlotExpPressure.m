%% ��������ѹ���ĳ���
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%% ��������
isUseGUI = 0;

if isUseGUI
    dataPath = getDataPath();
    [dataFileCellPath,floderName] = uigetfile({'*.mat'},'�����ļ���',dataPath);
    if isempty(dataFileCellPath) || isnumeric(dataFileCellPath)
        return;
    end
    dataFileCellPath = fullfile(floderName,dataFileCellPath);
    prompt={'������:',...
            '��ȡ�ṹ�ڵ���:'...
            ,'���Ƶڼ���ѹ������:[1~5]'...
            ,'���Ʋ�㼸������:[1~13]'};
    name='�����������';
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
    dataFileCellPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ�׹�\0.5D�׹�ȫ��\������ڲ�0.5D�׹��м�ȫ��.mat');
    fs = 100;%������
    baseField = 'rawData';%��ȡ�ṹ�ڵ���
    groupNum = 1;%���Ƶڼ���ѹ������:[1~5]
    meaPoint = 1;%���Ʋ�㼸������:[1~13]
end
%% ��ͼ
pressureDatas = getExpPressureDatas(dataFileCellPath,groupNum,baseField);
figure
plotExpPressurePlus(pressureDatas,meaPoint,fs,'color','b');
