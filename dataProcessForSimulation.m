%% 模拟数据分析
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%下面是需要设置的参数，本程序仅在此需要更改参数，其他地方不需要更改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
useGUI = 1;%如果需要合并多个数据为一个，不能使用GUI，需要从53行开始进行手动设置
rpm = 420;
if useGUI
    datasPath = getDataPath();
    datasPath = uigetdir(datasPath,'模拟数据文件夹');
    if isempty(datasPath) || isnumeric(datasPath)
        return;
    end
    %检查一下，防止转速没有设置或设置错误
    rpmIndex = strfind(datasPath,'转');
    if ~isempty(rpmIndex)
        rpmText = datasPath(rpmIndex-3:rpmIndex-1);
        rpm=inputdlg('输入测点数据对应转速','转速输入',1,{rpmText});
    else
        rpm=inputdlg('输入测点数据对应转速','转速输入',1,{'420'});
    end
    rpm = str2num(rpm{1});
    prompt = {'采样率:'...
              ,'数据分段：如{1:19}'...
              ,'峰峰值计算区间'...
              ,'是否进行趋势纠正,0~10,0为不进行，大于零使用对应的多项式纠正'...
              };
    defaultVal = {'200'...
              ,'{1:19}'...
              ,'[0.7,1.0]'...
              ,'8'...
              };         
    answer = inputdlg(prompt,'基本参数输入',1,defaultVal);
    if size(answer,1) <= 0
        return;
    end
    Fs = eval(answer{1,1});
    simulationDataSection = eval(answer{2,1});
    calcPeakPeakValueSection = eval(answer{3,1});
    polyfitN = eval(answer{4,1});
    baseFrequency = rpm/60*2;%定义一个基准频率，若没有定义为nan，相应的倍频*2.56不能超过采样频率
    beforeAfterMeaPoint = nan;%[14,15];%定义抑制装置的进口出口的测点号，如果没有定义为nan
    allowDeviation = 0.5;%查找基准频率时的允许频率误差范围
    multFreTimes = 3;% 倍频次数
    semiFreTimes = 3;% 半倍频次数
    loadDataStartTime = nan;%如果想忽略前段数据，把这个设置为0.n，n为百分比
    loadDataEndTime = nan;%同上
    combinecfxpath = nan;%如果是分开进行的模拟数据，需要把这个设置为1，同时不能使用gui
else
    %如果是分析单一文件夹的数据，只需要写成datasPath = 'D:\数据\xxx\'
    %如果是要连接两个模拟数据，写成一个元包数组datasPath ={'D:\数据\xxx1\','D:\数据\xxx2\'};
    %这样程序会按照元包数组的顺序进行数据提取和合并
    datasPath = {'G:\ansys_data\SurgeTank_InSideFrontOut5%\SurgeTank_InSideFrontOut5%_files\user_files\velocity'};
%         ,'e:\netdisk\shareCloud\【大论文】\[04]数据\模拟数据\DoubleTank_Z_5%\New Folder'};%fullfile(currentPath,'北区实验数据\模拟\26米单容V=DV细化');
    simulationDataSection = {21:28};
    beforeAfterMeaPoint = nan;%[14,15];%定义抑制装置的进口出口的测点号，如果没有定义为nan
    Fs = 200;%1/0.005
    calcPeakPeakValueSection = [0.5,1.0];%用于标记计算峰峰值的区间，例如[0.7,0.9]，表示70%~90%区间计算峰峰值
    polyfitN = 4;%去趋势使用的多项式阶次
    baseFrequency = rpm/60*2;%定义一个基准频率，若没有定义为nan，相应的倍频*2.56不能超过采样频率
    allowDeviation = 0.5;%查找基准频率时的允许频率误差范围

    multFreTimes = 3;% 倍频次数
    semiFreTimes = 3;% 半倍频次数
    loadDataStartTime = nan;%如果想忽略前段数据，把这个设置为0.n，n为百分比
    loadDataEndTime = nan;%同上
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

simulationDataStruct = fun_processSimulationFile(datasPath...
            ,'fs',Fs...
            ,'section',simulationDataSection...
            ,'basefrequency',baseFrequency...
            ,'allowdeviation',allowDeviation...
            ,'multFreTimes',multFreTimes...
            ,'semiFreTimes',semiFreTimes...
            ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
            ,'calcPeakPeakValueSection',calcPeakPeakValueSection...
            ,'loadDataStartTime',loadDataStartTime...
            ,'loadDataEndTime',loadDataEndTime...
            ,'polyfitn',polyfitN...
            );
simulationDataStruct.input.dataPath = datasPath;
simulationDataStruct.input.rpm = rpm;
if iscell(datasPath)
    saveMatFilePath = fullfile(datasPath{1},'simulationDataStruct.mat');
else
    saveMatFilePath = fullfile(datasPath,'simulationDataStruct.mat');
end
save(saveMatFilePath,'simulationDataStruct');
 msgbox('计算完成');