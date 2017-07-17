%% ����Ԥ���� - ����һ���ļ����µ�����excel���ݣ��������еĽ���ϲ�Ϊcombine����
% �˳�����dataProcessForOneExpFile �� dataProcessCombineDataStructCells���ۺ�
% ����Ľ�����������ļ���������pData.mat�ļ������ļ��������е����ݴ�����
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��������Ҫ���õĲ�������������ڴ���Ҫ���Ĳ����������ط�����Ҫ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
useGUI = 1;
rpm = 420;
if useGUI
    dataPath = getDataPath();
    xlsDataFileFolder = uigetdir(dataPath,'�����ļ���');
    if isempty(xlsDataFileFolder) || isnumeric(xlsDataFileFolder)
        return;
    end
    %���һ�£���ֹת��û�����û����ô���
    rpmIndex = strfind(xlsDataFileFolder,'ת');
    if ~isempty(rpmIndex)
        rpmText = xlsDataFileFolder(rpmIndex-3:rpmIndex-1);
        rpm=inputdlg('���������ݶ�Ӧת��','ת������',1,{rpmText});
    else
        rpm=inputdlg('���������ݶ�Ӧת��','ת������',1,{'420'});
    end
    rpm = str2num(rpm{1});
    [nullShiftDataFileName,nullShiftDataPath] = uigetfile({'*.csv';'*.xls';'*.xlsx'},'ѡ�񲻿�������Ʈ�ļ�',xlsDataFileFolder);
    if isempty(nullShiftDataFileName) || isnumeric(nullShiftDataFileName)
        nullShiftDataPath = nan;
    else
        nullShiftDataPath = fullfile(nullShiftDataPath,nullShiftDataFileName);
    end
    
else
    rpm=inputdlg('ȷ��ת��','ת��ȷ��',1,sprintf('%g',rpm));
    rpm = str2num(rpm{1});
    nullShiftDataPath = 'e:\netdisk\shareCloud\�������ġ�\[04]����\ʵ��ԭʼ����\���ڼ������\������\���ڼ����������������-2.CSV';
end
%pureVesselDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����300ת��ѹ\');
noiseSection = 14;
Fs = 100;%1/0.005
incrementDenoisingSet.isValid = 1;%�Ƿ���Ҫ��������ȥ��
emdDisnoiseCutLayer = nan;%[-2:-1];%emd�ع�ʱ��ȥ���������

calcPeakPeakValueSection = [0.3,0.7];%���ڱ�Ǽ�����ֵ�����䣬����[0.7,0.9]����ʾ70%~90%���������ֵ


baseFrequency = rpm / 60 * 2;%����һ����׼Ƶ�ʣ���û�ж���Ϊnan
allowDeviation = 0.5;
startTime = nan;%���÷�������ʼʱ�䣬������趨���Ͷ���Ϊnan,��λΪ��
endTime = nan;%���÷����Ľ���ʱ�䣬������趨���Ͷ���Ϊnan,��λΪ��
multFreTimes = 3;% ��Ƶ����
semiFreTimes = 3;% �뱶Ƶ����

selfAdaptMainFreFilter.minPeakDistance = 1;
selfAdaptMainFreFilter.mainFrequencyCount = 20;
selfAdaptMainFreFilter.type = 'all';
selfAdaptMainFreFilter.neighborCount = 0;
selfAdaptMainFreFilter.otherFreSet = 'zero';
selfAdaptMainFreFilter.thr = 0.1;

incrementDenoisingSet.sectionLength = 4096;%����ȥ�볤��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���һ�£���ֹת��û�����û����ô���
rpmIndex = strfind(xlsDataFileFolder,'ת');
rpmText = xlsDataFileFolder(rpmIndex-3:rpmIndex-1);
tmp = str2num(rpmText);
if tmp ~= rpm
    msgbox('ת�����úͼ����ļ�������ת�ٲ�һ�£����ת�����ò���ȷ�������¼������кܴ����!');
    btnText1 = '!!!~ ���� ~ !!![����ѡ��]';
    btnText2 = 'ȡ�����ٿ���';
    button = questdlg('ת�����úͼ����ļ�������ת�ٲ�һ��,�Ƿ�������Ծ���,����ȡ���ٺúü�飡'...
    ,'ѯ��'...
    ,btnText1,btnText2...
    );
    if strcmp(button,btnText2)
        return;
    end
end

dataStructCells = fun_processOneFolderExperimentFile(xlsDataFileFolder...
            ,'fs',Fs...
            ,'nullShiftDataPath',nullShiftDataPath...
            ,'basefrequency',baseFrequency...
            ,'allowdeviation',allowDeviation...
            ,'multFreTimes',multFreTimes...
            ,'semiFreTimes',semiFreTimes...
            ,'noiseSection',noiseSection...
            ,'calcPeakPeakValueSection',calcPeakPeakValueSection...
            ,'selfAdaptMainFreFilter',selfAdaptMainFreFilter...
            ,'incrementDenoising',incrementDenoisingSet...
            );

saveMatFilePath = fullfile(xlsDataFileFolder,'dataStructCells.mat');
save(saveMatFilePath,'dataStructCells');
%�������Ͻ��
combineDataStruct = combineExprimentMatFile(saveMatFilePath);
%���ֽ��
saveCombineMatPath = fullfile(xlsDataFileFolder,[constCombineDataStructFileName(),'.mat']);
% pointIndex = strfind(saveMatFilePath,'.');
% saveCombineMatPath = saveMatFilePath(1:pointIndex(end)-1);
% saveCombineMatPath = strcat(saveCombineMatPath,'_combine.mat');
save(saveCombineMatPath,'combineDataStruct');

msgbox('�������');
