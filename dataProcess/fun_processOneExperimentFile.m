function dataStruct = fun_processOneExperimentFile( fileFullPath,varargin )
% 加载北区的实验数据到dataStruct里
%   文件路径
if 1 == length(varargin)
    varargin = varargin{1};
end
baseFrequency = 10;%基频
allowDeviation = 0.5;%获取倍频时允许的误差范围，默认为0.5
multFreTimes = 4;%倍频1x,2x,3x
semiFreTimes = 4;%半倍频0.5x,1.5x,2.5x
nullShiftDataPath = [];%零飘修正需要给每个通道指定一个值
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
        case 'fs' %采样率
            Fs=val;
        case 'basefrequency' %基频
            baseFrequency=val;
        case 'allowdeviation' %基频
            allowDeviation=val;
        case 'multfretimes' %倍频数，分析倍频的数目默认3
            multFreTimes=val;
        case 'semifretimes' %半倍频数，分析倍频的数目默认3
            semiFreTimes=val;
        case 'noisesection' %噪声通道
            noiseSection = val;
        case 'nullshiftdatapath' %零漂修正的零飘数据路径
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
            error('参数输入错误！参数“%s”不适用',prop);
    end
end
% 记录输入的参数
dataStruct.input.fs = Fs;
dataStruct.input.baseFrequency = baseFrequency;
dataStruct.input.allowDeviation = allowDeviation;
dataStruct.input.multFreTimes = multFreTimes;
dataStruct.input.semiFreTimes = semiFreTimes;
dataStruct.input.nullShiftDataPath = nullShiftDataPath;
dataStruct.input.selfAdaptMainFreFilter = selfAdaptMainFreFilter;



rawData = loadExperimentPressureData(fileFullPath);
%进行零漂修正
if ~isempty(nullShiftDataPath)
    nullShiftData = getMeanExperimentPressure(nullShiftDataPath);
	for i = length(nullShiftData)
		if i <= size(rawData,2)
			rawData(:,i) = rawData(:,i) - nullShiftData(i);
		end
    end
    dataStruct.input.nullShiftData = nullShiftData;
end


%原始数据处理
rawDataStruct = fun_dataProcessing(rawData...
				,'fs',Fs...
				,'basefrequency',baseFrequency...
				,'allowdeviation',allowDeviation...
				,'multfretimes',multFreTimes...
				,'semifretimes',semiFreTimes...
                ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
				);

dataStruct.rawData = rawDataStruct;%原始数据计算结果

if ~isnan(noiseSection)
	%说明有噪声通道，进行去噪处理
    for i=1:size(rawData,2)
        subSpectrumData(:,i) = spectrumSubtraction(rawData(:,noiseSection)...
            ,rawData(:,i)...
            ,strSpectrumSubtractionWay);
    end

	%数据处理
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

%高通消除低频
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

%自适应主频滤波
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

%自增去噪
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
