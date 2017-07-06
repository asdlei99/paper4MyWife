%% ģ�����ݷ���
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

else
datasPath = 'D:\������\�о���\����\share\�����ġ��׹�\����\ģ������\SurgeTank_NoPipeAfterValve_5%';%fullfile(currentPath,'����ʵ������\ģ��\26�׵���V=DVϸ��');
simulationDataSection = {1:19};
loadDataStartTime = nan;%s
loadDataEndTime = nan;
beforeAfterMeaPoint = nan;%[14,15];%��������װ�õĽ��ڳ��ڵĲ��ţ����û�ж���Ϊnan
Fs = 200;%1/0.005
calcPeakPeakValueSection = [0.8,1.0];%���ڱ�Ǽ�����ֵ�����䣬����[0.7,0.9]����ʾ70%~90%���������ֵ
isNeedToDetrend = 1;%�Ƿ���Ҫ��������,�������1������ȥ���ƴ���
polyfitN = 8;%ȥ����ʹ�õĶ���ʽ�״�
baseFrequency = rpm/60*2;%����һ����׼Ƶ�ʣ���û�ж���Ϊnan����Ӧ�ı�Ƶ*2.56���ܳ�������Ƶ��
allowDeviation = 0.5;

multFreTimes = 3;% ��Ƶ����
semiFreTimes = 3;% �뱶Ƶ����

STFT.valid = 0;
STFT.windowSectionPointNums = 128;
STFT.noverlap = floor(STFT.windowSectionPointNums/2);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
hpass.f_pass = 4;%ͨ��Ƶ��5Hz
hpass.f_stop = 2;%��ֹƵ��3Hz
hpass.rp = 0.1;%�ߴ���˥��DB������
hpass.rs = 30;%��ֹ��˥��DB������
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
 disp('�������');
 msgbox('�������');