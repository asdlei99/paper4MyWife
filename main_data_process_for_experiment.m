%% 数据预处理
% 处理的结果将在数据文件夹下生成pData.mat文件，此文件包含所有的数据处理结果
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%下面是需要设置的参数，本程序仅在此需要更改参数，其他地方不需要更改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
datasPath = 'd:\传感器数据\';
%datasPath = fullfile(currentPath,'北区实验数据\双容0.5m间距\开口\');
xlsFilesName = '20160906内插孔管d20入全堵出半开开机450降300转带压.CSV';

loadDataStartTime = 0;%s
loadDataEndTime = nan;
noiseSection = 14;
Fs = 100;%1/0.005
isNeedToDetrend = 1;%是否需要去噪，实验数据噪声大，建议设置为1
incrementDenoisingSet.isValid = 1;%是否需要进行自增去噪
emdDisnoiseCutLayer = nan;%[-2:-1];%emd重构时，去除最后两层

calcPeakPeakValueSection = [0.3,0.7];%用于标记计算峰峰值的区间，例如[0.7,0.9]，表示70%~90%区间计算峰峰值


baseFrequency = 10;%定义一个基准频率，若没有定义为nan
allowDeviation = 0.5;
startTime = nan;%设置分析的起始时间，如果不设定，就定义为nan,单位为秒
endTime = nan;%设置分析的结束时间，如果不设定，就定义为nan,单位为秒
multFreTimes = 3;% 倍频次数
semiFreTimes = 3;% 半倍频次数


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

incrementDenoisingSet.sectionLength = 4096;%自增去噪长度
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
 msgbox('计算完成');