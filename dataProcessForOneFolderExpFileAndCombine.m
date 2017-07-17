%% 数据预处理 - 处理一个文件夹下的所有excel数据，并把所有的结果合并为combine数据
% 此程序是dataProcessForOneExpFile 和 dataProcessCombineDataStructCells的综合
% 处理的结果将在数据文件夹下生成pData.mat文件，此文件包含所有的数据处理结果
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
    dataPath = getDataPath();
    xlsDataFileFolder = uigetdir(dataPath,'数据文件夹');
    if isempty(xlsDataFileFolder) || isnumeric(xlsDataFileFolder)
        return;
    end
    %检查一下，防止转速没有设置或设置错误
    rpmIndex = strfind(xlsDataFileFolder,'转');
    if ~isempty(rpmIndex)
        rpmText = xlsDataFileFolder(rpmIndex-3:rpmIndex-1);
        rpm=inputdlg('输入测点数据对应转速','转速输入',1,{rpmText});
    else
        rpm=inputdlg('输入测点数据对应转速','转速输入',1,{'420'});
    end
    rpm = str2num(rpm{1});
    [nullShiftDataFileName,nullShiftDataPath] = uigetfile({'*.csv';'*.xls';'*.xlsx'},'选择不开机的零飘文件',xlsDataFileFolder);
    if isempty(nullShiftDataFileName) || isnumeric(nullShiftDataFileName)
        nullShiftDataPath = nan;
    else
        nullShiftDataPath = fullfile(nullShiftDataPath,nullShiftDataFileName);
    end
    
else
    rpm=inputdlg('确认转速','转速确认',1,sprintf('%g',rpm));
    rpm = str2num(rpm{1});
    nullShiftDataPath = 'e:\netdisk\shareCloud\【大论文】\[04]数据\实验原始数据\无内件缓冲罐\不开机\无内件缓冲罐重做不开机-2.CSV';
end
%pureVesselDataPath = fullfile(dataPath,'实验原始数据\无内件缓冲罐\开机300转带压\');
noiseSection = 14;
Fs = 100;%1/0.005
incrementDenoisingSet.isValid = 1;%是否需要进行自增去噪
emdDisnoiseCutLayer = nan;%[-2:-1];%emd重构时，去除最后两层

calcPeakPeakValueSection = [0.3,0.7];%用于标记计算峰峰值的区间，例如[0.7,0.9]，表示70%~90%区间计算峰峰值


baseFrequency = rpm / 60 * 2;%定义一个基准频率，若没有定义为nan
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
%检查一下，防止转速没有设置或设置错误
rpmIndex = strfind(xlsDataFileFolder,'转');
rpmText = xlsDataFileFolder(rpmIndex-3:rpmIndex-1);
tmp = str2num(rpmText);
if tmp ~= rpm
    msgbox('转速设置和检查的文件夹命名转速不一致，如果转速设置不正确，将导致计算结果有很大误差!');
    btnText1 = '!!!~ 继续 ~ !!![慎重选择]';
    btnText2 = '取消，再看看';
    button = questdlg('转速设置和检查的文件夹命名转速不一致,是否继续忽略警告,建议取消再好好检查！'...
    ,'询问'...
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
%处理联合结果
combineDataStruct = combineExprimentMatFile(saveMatFilePath);
%保持结果
saveCombineMatPath = fullfile(xlsDataFileFolder,[constCombineDataStructFileName(),'.mat']);
% pointIndex = strfind(saveMatFilePath,'.');
% saveCombineMatPath = saveMatFilePath(1:pointIndex(end)-1);
% saveCombineMatPath = strcat(saveCombineMatPath,'_combine.mat');
save(saveCombineMatPath,'combineDataStruct');

msgbox('计算完成');
