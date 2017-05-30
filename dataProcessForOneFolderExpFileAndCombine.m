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
dataPath = getDataPath();
rpm = 300;%ָ��ת�٣��Ա����Ա�ʱѡ���Ӧת�ٵĻ���޽��жԱ�
xlsDataFileFolder = fullfile(dataPath,'ʵ��ԭʼ����\��������ÿװ�0.5D���м�\����300ת��ѹ\');
nullShiftDataPath = 'e:\netdisk\shareCloud\�������ġ�\[04]����\ʵ��ԭʼ����\���ڼ������\������\���ڼ����������������-2.CSV';
pureVesselDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����300ת��ѹ\');

noiseSection = 14;
Fs = 100;%1/0.005
incrementDenoisingSet.isValid = 1;%�Ƿ���Ҫ��������ȥ��
emdDisnoiseCutLayer = nan;%[-2:-1];%emd�ع�ʱ��ȥ���������

calcPeakPeakValueSection = [0.3,0.7];%���ڱ�Ǽ�����ֵ�����䣬����[0.7,0.9]����ʾ70%~90%���������ֵ


baseFrequency = 10;%����һ����׼Ƶ�ʣ���û�ж���Ϊnan
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
rpmText = xlsDataFileFolder(rpmIndex-3,rpmIndex-1);
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
saveMatFilePath = fullfile(xlsDataFileFolder,'processDatas.mat');
save(saveMatFilePath,'dataStructCells');
%�������Ͻ��
combineDataStruct = combineExprimentMatFile(saveMatFilePath);
%���㻺��޵�����
vesselCombineDataStruct = getPureVesselCombineDataStruct(rpm);
combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'rawData');
combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'subSpectrumData');
combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'saMainFreFilterStruct');
%���ֽ��
pointIndex = strfind(saveMatFilePath,'.');
saveCombineMatPath = saveMatFilePath(1:pointIndex(end)-1);
saveCombineMatPath = strcat(saveCombineMatPath,'_combine.mat');
save(saveCombineMatPath,'combineDataStruct');

msgbox('�������');