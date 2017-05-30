%% 处理一个实验数据
% 处理的结果将在数据文件夹下生成和excel文件同名的mat文件，此文件包含所有的数据处理结果
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%下面是需要设置的参数，本程序仅在此需要更改参数，其他地方不需要更改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlsDataFileFullPath = 'e:\netdisk\shareCloud\【大论文】\[04]数据\实验原始数据\缓冲罐内置孔板0.5D罐中间\开机420转带压\内置孔板0.5D中间开机420转带压-1.xlsx';
nullShiftDataPath = 'e:\netdisk\shareCloud\【大论文】\[04]数据\实验原始数据\缓冲罐内置孔板0.5D罐中间\不开机\内置孔板0.5D中间不开机.xlsx';
nullShiftData = fun_getMeanExperimentPressure(nullShiftDataPath);

loadDataStartTime = 0;%s
loadDataEndTime = nan;
noiseSection = 14;
Fs = 100;%1/0.005
incrementDenoisingSet.isValid = 1;%是否需要进行自增去噪
emdDisnoiseCutLayer = nan;%[-2:-1];%emd重构时，去除最后两层

calcPeakPeakValueSection = [0.3,0.7];%用于标记计算峰峰值的区间，例如[0.7,0.9]，表示70%~90%区间计算峰峰值


baseFrequency = 10;%定义一个基准频率，若没有定义为nan
allowDeviation = 0.5;
startTime = nan;%设置分析的起始时间，如果不设定，就定义为nan,单位为秒
endTime = nan;%设置分析的结束时间，如果不设定，就定义为nan,单位为秒
multFreTimes = 3;% 倍频次数
semiFreTimes = 3;% 半倍频次数

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
msgbox('计算完成');