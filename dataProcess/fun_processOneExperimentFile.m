function dataStruct = fun_processOneExperimentFile( fileFullPath,varargin )
% ���ر�����ʵ�����ݵ�dataStruct��
%   �ļ�·��
if 1 == length(varargin)
    varargin = varargin{1};
end
baseFrequency = 10;%��Ƶ
allowDeviation = 0.5;%��ȡ��Ƶʱ�������Χ��Ĭ��Ϊ0.5
multFreTimes = 4;%��Ƶ1x,2x,3x
semiFreTimes = 4;%�뱶Ƶ0.5x,1.5x,2.5x
nullShiftDataPath = [];%��Ʈ������Ҫ��ÿ��ͨ��ָ��һ��ֵ
strSpectrumSubtractionWay = 'direct';
pp=varargin;
hpass = nan;
beforeAfterMeaPoint = nan;
calcPeakPeakValueSection = nan;
selfAdaptMainFreFilter.minPeakDistance = 1;
selfAdaptMainFreFilter.mainFrequencyCount = 50;
selfAdaptMainFreFilter.type = 'all';
selfAdaptMainFreFilter.neighborCount = 10;
selfAdaptMainFreFilter.otherFreSet = 'zero';
selfAdaptMainFreFilter.thr = 0.1;
noiseSection = nan;
incrementDenoisingSet.isValid = 0;
incrementDenoisingSet.sectionLength = 256;

Fs = 100;



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
        case 'noisesection' %����ͨ��
            noiseSection = val;
        case 'nullshiftdatapath' %��Ư��������Ʈ����·��
            nullShiftDataPath=val;
        case 'hpass'
            hpass = val;
        case 'beforeaftermeapoint'
            beforeAfterMeaPoint = val;
        case 'calcpeakpeakvaluesection'
            calcPeakPeakValueSection = val;
        case 'selfadaptmainfrefilter'
            selfAdaptMainFreFilter = val;
        case 'incrementdenoising'
            incrementDenoisingSet = val;
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
dataStruct.input.nullShiftDataPath = nullShiftDataPath;
dataStruct.input.selfAdaptMainFreFilter = selfAdaptMainFreFilter;



rawData = loadExperimentPressureData(fileFullPath);
%������Ư����
if ~isempty(nullShiftDataPath)
    nullShiftData = getMeanExperimentPressure(nullShiftDataPath);
	for i = length(nullShiftData)
		if i <= size(rawData,2)
			rawData(:,i) = rawData(:,i) - nullShiftData(i);
		end
    end
    dataStruct.input.nullShiftData = nullShiftData;
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

if ~isnan(noiseSection)
	%˵��������ͨ��������ȥ�봦��
    for i=1:size(rawData,2)
        subSpectrumData(:,i) = spectrumSubtraction(rawData(:,noiseSection)...
            ,rawData(:,i)...
            ,strSpectrumSubtractionWay);
    end

	%���ݴ���
	subSpectrumDataStruct = fun_dataProcessing(subSpectrumData...
					,'fs',Fs...
					,'basefrequency',baseFrequency...
					,'allowdeviation',allowDeviation...
					,'multfretimes',multFreTimes...
					,'semifretimes',semiFreTimes...
                    ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                    ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
					);
    dataStruct.subSpectrumData = subSpectrumDataStruct;
end

%��ͨ������Ƶ
if isstruct(hpass)
    for i = 1:size(rawData,2)
        hpData(:,i) = highp(rawData(:,i),hpass.f_pass,hpass.f_stop,hpass.rp,hpass.rs,Fs);
    end
    hpDataStruct = fun_dataProcessing(hpData...
					,'fs',Fs...
					,'basefrequency',baseFrequency...
					,'allowdeviation',allowDeviation...
					,'multfretimes',multFreTimes...
					,'semifretimes',semiFreTimes...
                    ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                    ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
					);
     hpDataStruct.hpass=hpass;
     dataStruct.hpDataStruct = hpDataStruct;
     
     pulsationValue = dataStruct.hpDataStruct.pulsationValue;
end

%����Ӧ��Ƶ�˲�
if isstruct(selfAdaptMainFreFilter)
    for i = 1:size(rawData,2)
        selfAdaptMainFreFilterData(:,i) = selfAdaptingMainFrequencyFilter(rawData(:,i)...
            ,selfAdaptMainFreFilter.mainFrequencyCount...
            ,selfAdaptMainFreFilter.type...
            ,'otherFreSet',selfAdaptMainFreFilter.otherFreSet...
            ,'thr',selfAdaptMainFreFilter.thr...
            ,'minpeakdistance',selfAdaptMainFreFilter.minPeakDistance...
            ,'neighborcount',selfAdaptMainFreFilter.neighborCount...
            ,'Fs',Fs);
    end
    saMainFreFilterStruct = fun_dataProcessing(selfAdaptMainFreFilterData...
					,'fs',Fs...
					,'basefrequency',baseFrequency...
					,'allowdeviation',allowDeviation...
					,'multfretimes',multFreTimes...
					,'semifretimes',semiFreTimes...
                    ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                    ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
					);
     saMainFreFilterStruct.selfAdaptMainFreFilter=selfAdaptMainFreFilter;
     dataStruct.saMainFreFilterStruct = saMainFreFilterStruct;
end

%����ȥ��
if incrementDenoisingSet.isValid
    for i = 1:size(rawData,2)
        incrementDenoisingData(:,i) = incrementDenoising(rawData(:,i),incrementDenoisingSet.sectionLength);
    end
    incrementDenoisingStruct = fun_dataProcessing(incrementDenoisingData...
					,'fs',Fs...
					,'basefrequency',baseFrequency...
					,'allowdeviation',allowDeviation...
					,'multfretimes',multFreTimes...
					,'semifretimes',semiFreTimes...
                    ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                    ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
					);
     dataStruct.incrementDenoisingStruct = incrementDenoisingStruct;          
end

end
