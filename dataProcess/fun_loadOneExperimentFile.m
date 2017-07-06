function dataStruct = fun_loadOneExperimentFile( fileFullPath,varargin )
% ���ر�����ʵ�����ݵ�dataStruct��
%   �ļ�·��
baseFrequency = 10;%��Ƶ
allowDeviation = 0.5;%��ȡ��Ƶʱ�������Χ��Ĭ��Ϊ0.5
multFreTimes = 4;%��Ƶ1x,2x,3x
semiFreTimes = 4;%�뱶Ƶ0.5x,1.5x,2.5x
noiseSection = nan;
STFT.valid = 1;
STFT.windowSectionPointNums = 256;
STFT.noverlap = floor(STFT.windowSectionPointNums/2);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
nullShiftData = [];
strSpectrumSubtractionWay = 'direct';
pp=varargin;
loadDataStartTime = nan;
loadDataEndTime = nan;
emdDisnoiseCutLayer = nan;%emdȥ������
hpass = nan;
beforeAfterMeaPoint = nan;
isNeedToDetrend = nan;
calcPeakPeakValueSection = nan;
selfAdaptMainFreFilter.minPeakDistance = 1;
selfAdaptMainFreFilter.mainFrequencyCount = 50;
selfAdaptMainFreFilter.type = 'all';
selfAdaptMainFreFilter.neighborCount = 10;
selfAdaptMainFreFilter.otherFreSet = 'zero';
selfAdaptMainFreFilter.thr = 0.1;

incrementDenoisingSet.isValid = 0;
incrementDenoisingSet.sectionLength = 256;
polyfitN = 4;
isFluent = 0;

sweepFrequencyData = 0;
combineCFXPath = {};
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
        case 'stft' %��ʱ����Ҷ�任�Ĳ���
            STFT=val;
        case 'nullshiftdata' %��Ư����
            nullShiftData=val;
        case 'issimulationdata'
            isSimulationData = val;
        case 'simulationdatasection'
            simulationDataSection = val;
        case 'loaddatastarttime'
            loadDataStartTime = val;
        case 'loaddataendtime'
            loadDataEndTime = val;
        case 'emddisnoisecutlayer'
            emdDisnoiseCutLayer = val;
        case 'hpass'
            hpass = val;
        case 'beforeaftermeapoint'
            beforeAfterMeaPoint = val;
        case 'isneedtodetrend'
            isNeedToDetrend = val;
        case 'calcpeakpeakvaluesection'
            calcPeakPeakValueSection = val;
        case 'selfadaptmainfrefilter'
            selfAdaptMainFreFilter = val;
        case 'incrementdenoising'
            incrementDenoisingSet = val;
        case 'isfluent'
            isFluent = val;
        case 'sweepfrequencydata'
            sweepFrequencyData = val;
        case 'combinecfxpath'
            combineCFXPath = val;%������Ҫ���ϵ�ģ�����ݣ�������·��
        case 'polyfitn'
            polyfitN = val;
        otherwise
            error(sprintf('����������󣡲�����%s��������',prop));
    end
end
% ��¼����Ĳ���
dataStruct.input.fs = Fs;
dataStruct.input.noiseSection = noiseSection;
dataStruct.input.baseFrequency = baseFrequency;
dataStruct.input.allowDeviation = allowDeviation;
dataStruct.input.multFreTimes = multFreTimes;
dataStruct.input.semiFreTimes = semiFreTimes;
dataStruct.input.noiseSection = noiseSection;
dataStruct.input.STFT = STFT;
dataStruct.input.nullShiftData = nullShiftData;
dataStruct.input.loadDataStartTime = loadDataStartTime;
dataStruct.input.loadDataEndTime = loadDataEndTime;
dataStruct.input.isNeedToDetrend = isNeedToDetrend;
dataStruct.input.selfAdaptMainFreFilter = selfAdaptMainFreFilter;
dataStruct.input.isSimulationData = isSimulationData;
%����ԭʼ����
if 1 == sweepFrequencyData
    %����ɨƵ����
    dataStruct.input.sweepFrequencyData = sweepFrequencyData;
    rawData = fun_loadPressureData(fileFullPath,'experiment'...
        ,'Fs',Fs...
        ,'loadDataStartTime',loadDataStartTime...
        ,'loadDataEndTime',loadDataEndTime);
    rawDataStruct = fun_dataProcessing(rawData...
				,'fs',Fs...
				,'basefrequency',baseFrequency...
				,'allowdeviation',allowDeviation...
				,'multfretimes',multFreTimes...
				,'semifretimes',semiFreTimes...
				,'stft',STFT...% ��ʱ����Ҷ�任�ļ�����
                ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
				);
    dataStruct.rawData = rawDataStruct;%ԭʼ���ݼ�����
    saveData(isSimulationData,fileFullPath,dataStruct);
    return;
end
if 1 == isSimulationData
    if isempty(combineCFXPath)
        rawData = fun_loadPressureData(fileFullPath,'simulation'...
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
elseif 2==isSimulationData
    %��������
    rawData = fun_loadPressureData(fileFullPath,'theory'...
        ,'section',simulationDataSection...
        ,'Fs',Fs...
        ,'loadDataStartTime',loadDataStartTime...
        ,'loadDataEndTime',loadDataEndTime...
        ,'isFluent',isFluent...
        );
else
    rawData = fun_loadPressureData(fileFullPath,'experiment'...
        ,'Fs',Fs...
        ,'loadDataStartTime',loadDataStartTime...
        ,'loadDataEndTime',loadDataEndTime);
end
%������Ư����
if ~isempty(nullShiftData) && ~isSimulationData
	for i = length(nullShiftData)
		if i <= size(rawData,2)
			rawData(:,i) = rawData(:,i) - nullShiftData(i);
		end
	end
end
if isNeedToDetrend
    for i = 1:size(rawData,2)
        indexStart = ceil(size(rawData,1)*0.9);%����������ݶ��������ѹ��ֱ�Ӹ�Ϊindexstart = 1
        tt = ceil(size(rawData,1)*0.001);
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
				,'stft',STFT...% ��ʱ����Ҷ�任�ļ�����
                ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
				);

dataStruct.rawData = rawDataStruct;%ԭʼ���ݼ�����
pulsationValue = dataStruct.rawData.pulsationValue;
if ~isnan(noiseSection) && ~isSimulationData
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
					,'stft',STFT...% ��ʱ����Ҷ�任�ļ�����
                    ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                    ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
					);
    dataStruct.subSpectrumData = subSpectrumDataStruct;
end
%emd�ֽ�
if ~isnan(emdDisnoiseCutLayer)
    for i = 1:size(rawData,2)
        [emdDistrend(:,i),emdRes{i}] = fun_emdDisNoise(rawData(:,i),emdDisnoiseCutLayer);
    end
    %���ݴ���
	emdDisTrendDataStruct = fun_dataProcessing(emdDistrend...
					,'fs',Fs...
					,'basefrequency',baseFrequency...
					,'allowdeviation',allowDeviation...
					,'multfretimes',multFreTimes...
					,'semifretimes',semiFreTimes...
					,'stft',STFT...% ��ʱ����Ҷ�任�ļ�����
                    ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                    ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
					);
    emdDisTrendDataStruct.emdRes = emdRes;
    dataStruct.emdDisTrendDataStruct = emdDisTrendDataStruct;            
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
					,'stft',STFT...% ��ʱ����Ҷ�任�ļ�����
                    ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                    ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
					);
     hpDataStruct.hpass=hpass;
     dataStruct.hpDataStruct = hpDataStruct;
     
     pulsationValue = dataStruct.hpDataStruct.pulsationValue;
end
pulsationStruct.pulsationRate = pulsationValue./dataStruct.rawData.statisPara25(1,:);
dataStruct.pulsationStruct = pulsationStruct;
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
					,'stft',STFT...% ��ʱ����Ҷ�任�ļ�����
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
					,'stft',STFT...% ��ʱ����Ҷ�任�ļ�����
                    ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                    ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
					);
     dataStruct.incrementDenoisingStruct = incrementDenoisingStruct;          
end
%��������
% if 1 == isSimulationData
%     getParentDirectory(fileFullPath)
%     saveMatFilePath = fullfile(fileFullPath,[getParentDirectory(fileFullPath),'.mat']);
% elseif 2 == isSimulationData
%     saveMatFilePath = changSuffix(fileFullPath,'mat');
% else
%     saveMatFilePath = changSuffix(fileFullPath,'mat');
% end
% save(saveMatFilePath,'dataStruct');
saveData(isSimulationData,fileFullPath,dataStruct,combineCFXPath);
end

function saveData(isSimulationData,fileFullPath,dataStruct,combineCFXPath)
if 1 == isSimulationData
    if isempty(combineCFXPath)
        saveMatFilePath = fullfile(fileFullPath,[getParentDirectory(fileFullPath),'.mat']);
    else
        upDir = getUpDirectory(combineCFXPath{1});
        saveMatFilePath = fullfile([upDir,getParentDirectory(upDir),'.mat']);
    end
elseif 2 == isSimulationData
    saveMatFilePath = changSuffix(fileFullPath,'mat');
else
    saveMatFilePath = changSuffix(fileFullPath,'mat');
end
save(saveMatFilePath,'dataStruct');
end

function dirName = getParentDirectory(path)
    fsep = filesep;
    index = strfind(path,fsep);
    pathIndexStart = 0;
    pathIndexEnd = 0;
    if index(end) == length(path)
        pathIndexStart = index(length(index)-1);
        pathIndexStart = pathIndexStart + 1;
        pathIndexEnd = index(end) - 1;
    else
        pathIndexStart = index(end);
        pathIndexStart = pathIndexStart + 1;
        pathIndexEnd = length(path);
    end
    dirName = path(pathIndexStart:pathIndexEnd);
end

function dirName = getUpDirectory(path)
    fsep = filesep;
    index = strfind(path,fsep);
    pathIndexStart = 0;
    pathIndexEnd = 0;
    if index(end) == length(path)
        pathIndexStart = 1;
        pathIndexEnd = index(end-1);
    else
        pathIndexStart = 1;
        pathIndexEnd = index(end);
    end
    dirName = path(pathIndexStart:pathIndexEnd);
end
% function filename = getFileNameFromFullPath(filePath)
%     filename = '';
%     sindex = strfind(filePath,'\');
%     if length(sindex) <= 0
%         sindex = strfind(filePath,'/');
%     end
%     if length(sindex) > 0
%         sdotindex = strfind(filePath,'.');
%         if length(sdotindex) > 0
%             filename = filePath(sindex(end)+1:sdotindex(end)-1);
%         else
%             filename = filePath(sindex(end)+1:end);
%         end
%     end
% end
% 
% function filePath = getFilePathFromFullPath(fileFullPath)
%     filePath = '';
%     sindex = strfind(fileFullPath,'\');
%     if length(sindex) <= 0
%         sindex = strfind(fileFullPath,'/');
%     end
%     if length(sindex) > 0
%         filePath = fileFullPath(1:sindex(end))
%     end
% end