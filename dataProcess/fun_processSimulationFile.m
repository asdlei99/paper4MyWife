function dataStruct = fun_processSimulationFile( fileFullPath,varargin )
% 加载北区的实验数据到dataStruct里
%   文件路径
baseFrequency = 10;%基频
allowDeviation = 0.5;%获取倍频时允许的误差范围，默认为0.5
multFreTimes = 3;%倍频1x,2x,3x
semiFreTimes = 3;%半倍频0.5x,1.5x,2.5x
pp=varargin;
beforeAfterMeaPoint = nan;
calcPeakPeakValueSection = nan;
Fs = 200;
combineCFXPath = nan;
polyfitN = -1;
isFluent = 0;%是否是fluent导出的数据
loadDataStartTime = nan;
loadDataEndTime = nan;
simulationDataSection = nan;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'fs' %采样率
            Fs=val;
        case 'basefrequency' %基频
            baseFrequency=val;
        case 'allowdeviation' %查找基准频率时的允许频率误差范围
            allowDeviation=val;
        case 'multfretimes' %倍频数，分析倍频的数目默认3
            multFreTimes=val;
        case 'semifretimes' %半倍频数，分析倍频的数目默认3
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
            combineCFXPath = val;%对于需要联合的模拟数据，定义多个路径
        case 'polyfitn'
            polyfitN = val;
        case 'isfluent'
            isFluent = val;
        case 'section'
            simulationDataSection = val;
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
%说明需要去趋势
if polyfitN > 0
    for i = 1:size(rawData,2)
        indexStart = ceil(size(rawData,1)*0.9);%如果整个数据都用来算均压，直接改为indexstart = 1
        rawData(:,i) = polyfitDetrend(rawData(:,i),polyfitN,'baseValue',mean(rawData(indexStart:end,i)));
    end
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


end
