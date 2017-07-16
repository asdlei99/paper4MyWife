%% ģ�����ݷ���
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��������Ҫ���õĲ�������������ڴ���Ҫ���Ĳ����������ط�����Ҫ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
useGUI = 0;
rpm = 420;
if useGUI
    datasPath = getDataPath();
    datasPath = uigetdir(datasPath,'ģ�������ļ���');
    if isempty(datasPath) || isnumeric(datasPath)
        return;
    end
    %���һ�£���ֹת��û�����û����ô���
    rpmIndex = strfind(datasPath,'ת');
    if ~isempty(rpmIndex)
        rpmText = datasPath(rpmIndex-3:rpmIndex-1);
        rpm=inputdlg('���������ݶ�Ӧת��','ת������',1,{rpmText});
    else
        rpm=inputdlg('���������ݶ�Ӧת��','ת������',1,{'420'});
    end
    rpm = str2num(rpm{1});
    prompt = {'������:'...
              ,'���ݷֶΣ���{1:19}'...
              ,'���ֵ��������'...
              ,'�Ƿ�������ƾ���,0~10,0Ϊ�����У�������ʹ�ö�Ӧ�Ķ���ʽ����'...
              };
    defaultVal = {'200'...
              ,'{1:19}'...
              ,'[0.7,1.0]'...
              ,'8'...
              };         
    answer = inputdlg(prompt,'������������',1,defaultVal);
    if size(answer,1) <= 0
        return;
    end
    Fs = eval(answer{1,1});
    simulationDataSection = eval(answer{2,1});
    calcPeakPeakValueSection = eval(answer{3,1});
    polyfitN = eval(answer{4,1});
    baseFrequency = rpm/60*2;%����һ����׼Ƶ�ʣ���û�ж���Ϊnan����Ӧ�ı�Ƶ*2.56���ܳ�������Ƶ��
    beforeAfterMeaPoint = nan;%[14,15];%��������װ�õĽ��ڳ��ڵĲ��ţ����û�ж���Ϊnan
    allowDeviation = 0.5;%���һ�׼Ƶ��ʱ������Ƶ����Χ
    multFreTimes = 3;% ��Ƶ����
    semiFreTimes = 3;% �뱶Ƶ����
    loadDataStartTime = nan;%��������ǰ�����ݣ����������Ϊ0.n��nΪ�ٷֱ�
    loadDataEndTime = nan;%ͬ��
    combinecfxpath = nan;%����Ƿֿ����е�ģ�����ݣ���Ҫ���������Ϊ1��ͬʱ����ʹ��gui
else
    datasPath = 'D:\������\�о���\����\share\�����ġ�����޽ӷ��о�\ģ������\SurgeTank_InSideInOut_2TimesLength_5%\';%fullfile(currentPath,'����ʵ������\ģ��\26�׵���V=DVϸ��');
    simulationDataSection = {1:19};
    beforeAfterMeaPoint = nan;%[14,15];%��������װ�õĽ��ڳ��ڵĲ��ţ����û�ж���Ϊnan
    Fs = 200;%1/0.005
    calcPeakPeakValueSection = [0.8,1.0];%���ڱ�Ǽ�����ֵ�����䣬����[0.7,0.9]����ʾ70%~90%���������ֵ
    polyfitN = 8;%ȥ����ʹ�õĶ���ʽ�״�
    baseFrequency = rpm/60*2;%����һ����׼Ƶ�ʣ���û�ж���Ϊnan����Ӧ�ı�Ƶ*2.56���ܳ�������Ƶ��
    allowDeviation = 0.5;%���һ�׼Ƶ��ʱ������Ƶ����Χ

    multFreTimes = 3;% ��Ƶ����
    semiFreTimes = 3;% �뱶Ƶ����
    loadDataStartTime = nan;%��������ǰ�����ݣ����������Ϊ0.n��nΪ�ٷֱ�
    loadDataEndTime = nan;%ͬ��
    combinecfxpath = nan;%����Ƿֿ����е�ģ�����ݣ���Ҫ���������Ϊ1��ͬʱ����ʹ��gui
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
            ,'combinecfxpath',combinecfxpath...
            ,'loadDataStartTime',loadDataStartTime...
            ,'loadDataEndTime',loadDataEndTime...
            ,'polyfitn',polyfitN...
            );
simulationDataStruct.input.dataPath = datasPath;
simulationDataStruct.input.rpm = rpm;
saveMatFilePath = fullfile(datasPath,'simulationDataStruct.mat');
save(saveMatFilePath,'simulationDataStruct');
 msgbox('�������');