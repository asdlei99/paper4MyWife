function dataStruct = fun_processOneExperimentFile( fileFullPath,varargin )
% 加载北区的实验数据到dataStruct里
%   文件路径
baseFrequency = 10;%基频
allowDeviation = 0.5;%获取倍频时允许的误差范围，默认为0.5
multFreTimes = 4;%倍频1x,2x,3x
semiFreTimes = 4;%半倍频0.5x,1.5x,2.5x
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
        case 'beforeaftermeapoint'
            beforeAfterMeaPoint = val;
        case 'calcpeakpeakvaluesection'
            calcPeakPeakValueSection = val;
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



rawData = loadSimulationPressureData(fileFullPath);



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
