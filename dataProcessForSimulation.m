%% 模拟数据分析
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%下面是需要设置的参数，本程序仅在此需要更改参数，其他地方不需要更改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
useGUI = 1;
rpm = 420;
if useGUI

else
datasPath = 'D:\马屈杨\研究生\论文\share\【论文】孔管\数据\模拟数据\SurgeTank_NoPipeAfterValve_5%';%fullfile(currentPath,'北区实验数据\模拟\26米单容V=DV细化');
simulationDataSection = {1:19};
loadDataStartTime = nan;%s
loadDataEndTime = nan;
beforeAfterMeaPoint = nan;%[14,15];%定义抑制装置的进口出口的测点号，如果没有定义为nan
Fs = 200;%1/0.005
calcPeakPeakValueSection = [0.8,1.0];%用于标记计算峰峰值的区间，例如[0.7,0.9]，表示70%~90%区间计算峰峰值
isNeedToDetrend = 1;%是否需要消除趋势,如果定义1，就行去趋势处理
polyfitN = 8;%去趋势使用的多项式阶次
baseFrequency = rpm/60*2;%定义一个基准频率，若没有定义为nan，相应的倍频*2.56不能超过采样频率
allowDeviation = 0.5;

multFreTimes = 3;% 倍频次数
semiFreTimes = 3;% 半倍频次数

STFT.valid = 0;
STFT.windowSectionPointNums = 128;
STFT.noverlap = floor(STFT.windowSectionPointNums/2);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
hpass.f_pass = 4;%通过频率5Hz
hpass.f_stop = 2;%截止频率3Hz
hpass.rp = 0.1;%边带区衰减DB数设置
hpass.rs = 30;%截止区衰减DB数设置
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlsDataFileFullPath = datasPath;
----- zhe

dataStruct = fun_processOneExperimentFile(xlsDataFileFullPath...
            ,'fs',Fs...
            ,'basefrequency',baseFrequency...
            ,'allowdeviation',allowDeviation...
            ,'multFreTimes',multFreTimes...
            ,'semiFreTimes',semiFreTimes...
            ,'loadDataStartTime',loadDataStartTime...
            ,'loadDataEndTime',loadDataEndTime...
            ,'calcPeakPeakValueSection',calcPeakPeakValueSection...
            ,'selfAdaptMainFreFilter',selfAdaptMainFreFilter...
            ,'incrementDenoising',incrementDenoisingSet...
            );
 disp('计算完成');
 msgbox('计算完成');