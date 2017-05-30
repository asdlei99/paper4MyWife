%% ����һ��ʵ������
% ����Ľ�����������ļ��������ɺ�excel�ļ�ͬ����mat�ļ������ļ��������е����ݴ�����
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��������Ҫ���õĲ�������������ڴ���Ҫ���Ĳ����������ط�����Ҫ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlsDataFileFullPath = 'e:\netdisk\shareCloud\�������ġ�\[04]����\ʵ��ԭʼ����\��������ÿװ�0.5D���м�\����420ת��ѹ\���ÿװ�0.5D�м俪��420ת��ѹ-1.xlsx';
nullShiftDataPath = 'e:\netdisk\shareCloud\�������ġ�\[04]����\ʵ��ԭʼ����\��������ÿװ�0.5D���м�\������\���ÿװ�0.5D�м䲻����.xlsx';
nullShiftData = fun_getMeanExperimentPressure(nullShiftDataPath);

loadDataStartTime = 0;%s
loadDataEndTime = nan;
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


dataStruct = fun_processOneExperimentFile(xlsDataFileFullPath...
            ,'fs',Fs...
            ,'nullShiftData',nullShiftData...
            ,'basefrequency',baseFrequency...
            ,'allowdeviation',allowDeviation...
            ,'multFreTimes',multFreTimes...
            ,'semiFreTimes',semiFreTimes...
            ,'noiseSection',noiseSection...
            ,'loadDataStartTime',loadDataStartTime...
            ,'loadDataEndTime',loadDataEndTime...
            ,'calcPeakPeakValueSection',calcPeakPeakValueSection...
            ,'selfAdaptMainFreFilter',selfAdaptMainFreFilter...
            ,'incrementDenoising',incrementDenoisingSet...
            );
saveMatFilePath = changSuffix(xlsDataFileFullPath,'mat');
save(saveMatFilePath,'dataStruct');
msgbox('�������');