%% ����Ԥ���� - ����һ���Ѿ�����Ԥ������������ݣ����Ǻ�׺��combine�����ݽṹ�壬�ͻ���޵����ݽ��н��
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%��������Ҫ���õĲ�������������ڴ���Ҫ���Ĳ����������ط�����Ҫ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataPath = getDataPath();
rpm = 420;%ָ��ת�٣��Ա����Ա�ʱѡ���Ӧת�ٵĻ���޽��жԱ�
combineDataStructPath = fullfile(dataPath,'ʵ��ԭʼ����\��������ÿװ�0.5D���м�\����420ת��ѹ_combine.mat');
combineDataStruct = load(combineDataStructPath);
combineDataStruct = combineDataStruct.combineDataStruct;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���һ�£���ֹת��û�����û����ô���
rpmIndex = strfind(combineDataStructPath,'ת');
rpmText = combineDataStructPath(rpmIndex(end)-3:rpmIndex(end)-1);
tmp = str2num(rpmText);
if tmp ~= rpm
    btnText1 = '!!!~ ���� ~ !!![����ѡ��]';
    btnText2 = 'ȡ�����ٿ���';
    button = questdlg('ת�����úͼ����ļ�������ת�ٲ�һ��,�Ƿ�������Ծ���,����ȡ���ٺúü�飡'...
    ,'ѯ��'...
    ,btnText1,btnText2,btnText2...
    );
    if ~strcmp(button,btnText1)
        return;
    end
end


%���㻺��޵�����
vesselCombineDataStruct = getPureVesselCombineDataStruct(rpm);
combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'rawData');
combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'subSpectrumData');
combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'saMainFreFilterStruct');
%���ֽ��

save(combineDataStructPath,'combineDataStruct');

msgbox('�������');