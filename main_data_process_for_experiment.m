%% ����Ԥ����
% ����Ľ�����������ļ���������pData.mat�ļ������ļ��������е����ݴ�����
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��������Ҫ���õĲ�������������ڴ���Ҫ���Ĳ����������ط�����Ҫ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
datasPath = 'd:\����������\';
%datasPath = fullfile(currentPath,'����ʵ������\˫��0.5m���\����\');
xlsFilesName = '20160906�ڲ�׹�d20��ȫ�³��뿪����450��300ת��ѹ.CSV';

loadDataStartTime = 0;%s
loadDataEndTime = nan;
noiseSection = 14;
Fs = 100;%1/0.005
isNeedToDetrend = 1;%�Ƿ���Ҫȥ�룬ʵ�����������󣬽�������Ϊ1
incrementDenoisingSet.isValid = 1;%�Ƿ���Ҫ��������ȥ��
emdDisnoiseCutLayer = nan;%[-2:-1];%emd�ع�ʱ��ȥ���������

calcPeakPeakValueSection = [0.3,0.7];%���ڱ�Ǽ�����ֵ�����䣬����[0.7,0.9]����ʾ70%~90%���������ֵ


baseFrequency = 10;%����һ����׼Ƶ�ʣ���û�ж���Ϊnan
allowDeviation = 0.5;
startTime = nan;%���÷�������ʼʱ�䣬������趨���Ͷ���Ϊnan,��λΪ��
endTime = nan;%���÷����Ľ���ʱ�䣬������趨���Ͷ���Ϊnan,��λΪ��
multFreTimes = 3;% ��Ƶ����
semiFreTimes = 3;% �뱶Ƶ����


STFT.valid = 0;
STFT.windowSectionPointNums = 128;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);

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

xlsDataFileFullPath = fullfile(datasPath,xlsFilesName);

dataStruct = fun_loadOneExperimentFile(xlsDataFileFullPath...
            ,'fs',Fs...
            ,'basefrequency',baseFrequency...
            ,'allowdeviation',allowDeviation...
            ,'multFreTimes',multFreTimes...
            ,'semiFreTimes',semiFreTimes...
            ,'noiseSection',noiseSection...
            ,'stft',STFT...
            ,'isSimulationData',0 ...
            ,'loadDataStartTime',loadDataStartTime...
            ,'loadDataEndTime',loadDataEndTime...
            ,'emdDisnoiseCutLayer',emdDisnoiseCutLayer...
            ,'isNeedToDetrend',isNeedToDetrend...
            ,'calcPeakPeakValueSection',calcPeakPeakValueSection...
            ,'selfAdaptMainFreFilter',selfAdaptMainFreFilter...
            ,'incrementDenoising',incrementDenoisingSet...
            );
 msgbox('�������');