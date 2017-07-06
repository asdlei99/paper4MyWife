function dataStruct = fun_processOneExperimentFile( fileFullPath,varargin )
% ���ر�����ʵ�����ݵ�dataStruct��
%   �ļ�·��
baseFrequency = 10;%��Ƶ
allowDeviation = 0.5;%��ȡ��Ƶʱ�������Χ��Ĭ��Ϊ0.5
multFreTimes = 4;%��Ƶ1x,2x,3x
semiFreTimes = 4;%�뱶Ƶ0.5x,1.5x,2.5x
pp=varargin;
hpass = nan;
beforeAfterMeaPoint = nan;
calcPeakPeakValueSection = nan;
Fs = 200;



while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'fs' %������
            Fs=val;
        case 'basefrequency' %��Ƶ
            baseFrequency=val;
        case 'allowdeviation' %��Ƶ
            allowDeviation=val;
        case 'multfretimes' %��Ƶ����������Ƶ����ĿĬ��3
            multFreTimes=val;
        case 'semifretimes' %�뱶Ƶ����������Ƶ����ĿĬ��3
            semiFreTimes=val;
        case 'beforeaftermeapoint'
            beforeAfterMeaPoint = val;
        case 'calcpeakpeakvaluesection'
            calcPeakPeakValueSection = val;
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



rawData = loadSimulationPressureData(fileFullPath);



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
