function dataStruct = fun_processSimulationFile( fileFullPath,varargin )
% ���ر�����ʵ�����ݵ�dataStruct��
%   �ļ�·��
baseFrequency = 10;%��Ƶ
allowDeviation = 0.5;%��ȡ��Ƶʱ�������Χ��Ĭ��Ϊ0.5
multFreTimes = 3;%��Ƶ1x,2x,3x
semiFreTimes = 3;%�뱶Ƶ0.5x,1.5x,2.5x
pp=varargin;
beforeAfterMeaPoint = nan;
calcPeakPeakValueSection = nan;
Fs = 200;
combineCFXPath = nan;
polyfitN = -1;
isFluent = 0;%�Ƿ���fluent����������
loadDataStartTime = nan;
loadDataEndTime = nan;
simulationDataSection = nan;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'fs' %������
            Fs=val;
        case 'basefrequency' %��Ƶ
            baseFrequency=val;
        case 'allowdeviation' %���һ�׼Ƶ��ʱ������Ƶ����Χ
            allowDeviation=val;
        case 'multfretimes' %��Ƶ����������Ƶ����ĿĬ��3
            multFreTimes=val;
        case 'semifretimes' %�뱶Ƶ����������Ƶ����ĿĬ��3
            semiFreTimes=val;
        case 'beforeaftermeapoint'
            beforeAfterMeaPoint = val;
        case 'loaddatastarttime'
            loadDataStartTime = val;
        case 'loaddataendtime'
            loadDataEndTime = val;
        case 'calcpeakpeakvaluesection'
            calcPeakPeakValueSection = val;
        case 'combinecfxpath'
            combineCFXPath = val;%������Ҫ���ϵ�ģ�����ݣ�������·��
        case 'polyfitn'
            polyfitN = val;
        case 'isfluent'
            isFluent = val;
        case 'section'
            simulationDataSection = val;
        otherwise
            error('����������󣡲�����%s��������',prop);
    end
end
% ��¼����Ĳ���
dataStruct.input.fs = Fs;
dataStruct.input.baseFrequency = baseFrequency;
dataStruct.input.allowDeviation = allowDeviation;
dataStruct.input.multFreTimes = multFreTimes;
dataStruct.input.semiFreTimes = semiFreTimes;


if isnan(combineCFXPath)
    rawData = loadSimulationPressureData(fileFullPath...
                ,'section',simulationDataSection...
                ,'Fs',Fs...
                ,'loadDataStartTime',loadDataStartTime...
                ,'loadDataEndTime',loadDataEndTime...
                ,'isFluent',isFluent...
                );
else
    rawData = combineCFXSimulateData('datapaths',combineCFXPath...
                ,'section',simulationDataSection...
                ,'Fs',Fs...
                ,'loadDataStartTime',loadDataStartTime...
                ,'loadDataEndTime',loadDataEndTime...
                ,'isFluent',isFluent...
            );
end
%˵����Ҫȥ����
if polyfitN > 0
    for i = 1:size(rawData,2)
        indexStart = ceil(size(rawData,1)*0.9);%����������ݶ��������ѹ��ֱ�Ӹ�Ϊindexstart = 1
        rawData(:,i) = polyfitDetrend(rawData(:,i),polyfitN,'baseValue',mean(rawData(indexStart:end,i)));
    end
end


%ԭʼ���ݴ���
rawDataStruct = fun_dataProcessing(rawData...
				,'fs',Fs...
				,'basefrequency',baseFrequency...
				,'allowdeviation',allowDeviation...
				,'multfretimes',multFreTimes...
				,'semifretimes',semiFreTimes...
                ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
				);

dataStruct.rawData = rawDataStruct;%ԭʼ���ݼ�����


end
