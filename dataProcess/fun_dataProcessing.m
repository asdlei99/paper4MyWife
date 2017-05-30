function processDataStruct = fun_dataProcessing(rawData,varargin)
%原始数据处理
baseFrequency = nan;%基频
allowDeviation = 0.5;%获取倍频时允许的误差范围，默认为0.5
multFreTimes = 3;%倍频1x,2x,3x
semiFreTimes = 3;%半倍频0.5x,1.5x,2.5x
pp = varargin;
beforeAfterMeaPoint = nan;
calcPeakPeakValueSection = 0.8;
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
            error(sprintf('参数输入错误！错误参数：%s',prop));
    end
end
if isnan(calcPeakPeakValueSection)
    calcPeakPeakValueSection = 0.8;
end
[rawFre,rawMag,rawPh] = fft_byColumn(rawData,Fs);%原始数据频谱分析

for i = 1:size(rawData,2)
    colData = rawData(:,i);
end


for i=1:multFreTimes%计算倍频幅值，相位
    [m,p,f] = findBaseFres(rawFre,rawMag,rawPh,baseFrequency*i,allowDeviation);
    multFreMag(i,:) = m;
    multFrePh(i,:) = p;
    multFreFre(i,:) = f;
end
for i=1:semiFreTimes%计算半倍频幅值，相位
    [m,p,f] = findBaseFres(rawFre,rawMag,rawPh,baseFrequency*(i-0.5),allowDeviation);
    semiFreMag(i,:) = m;
    semiFrePh(i,:) = p;
    semiFreFre(i,:) = f;
end
processDataStruct.pressure = rawData;
processDataStruct.Fre = rawFre;
processDataStruct.Mag = rawMag;
processDataStruct.Ph = rawPh;
processDataStruct.multFreMag = multFreMag;
processDataStruct.multFrePh = multFrePh;
processDataStruct.multFreFre = multFreFre;
processDataStruct.semiFreMag = semiFreMag;
processDataStruct.semiFrePh = semiFrePh;
processDataStruct.semiFreFre = semiFreFre;
[processDataStruct.statisPara,processDataStruct.statisParaName] = statisticalParameterByColumn(rawData);
[processDataStruct.statisPara25,processDataStruct.statisParaName25] = statisticalParameterByColumn(rawData(round(size(rawData,1)*0.75):end,:));
processDataStruct.pulsationValue = fun_calcPulsation(rawData,calcPeakPeakValueSection);
processDataStruct.pulsationRate = processDataStruct.pulsationValue./processDataStruct.statisPara(1,:);%脉动不均度
%计算脉动抑制效果
processDataStruct.beforeAfterMeaPoint = beforeAfterMeaPoint;
if isnan(beforeAfterMeaPoint)
    processDataStruct.pulsationReduceRate = nan;
    processDataStruct.pulsationReduceRateDB = nan;
else
    [processDataStruct.pulsationReduceRate,processDataStruct.pulsationReduceRateDB] = ...
        fun_ca_calc_pulsation_reduce_rate(processDataStruct.pulsationValue,beforeAfterMeaPoint(1),beforeAfterMeaPoint(2));
end
end

function [sData,valueName] = statisticalParameterByColumn(rawData)
    sData(1,:)=mean(rawData);valueName{1}='均值';
    sData(2,:)=median(rawData);valueName{2}='中值';
    sData(3,:)=max(rawData);valueName{3}='最大值';
    sData(4,:)=min(rawData);valueName{4}='最小值';
    sData(5,:)=mode(rawData);valueName{5}='众数';
    sData(6,:)=std(rawData);valueName{6}='标准差';
    sData(7,:)=var(rawData);valueName{7}='方差';
    sData(8,:) = skewness(rawData);valueName{8}='偏度';
    sData(9,:) = kurtosis(rawData);valueName{9}='峭度';    
end

function [mags,phs,fres] = findBaseFres(rawFre,rawMag,rawPh,findFre,allowDeviation)
    for i=1:size(rawMag,2)
        f = rawFre(:,i);
        mag = rawMag(:,i);
        p = rawPh(:,i);
        
        k = find(f>(findFre-allowDeviation) & f<(findFre+allowDeviation));
        if isempty(k)
            mags(1,i) = nan;
            fres(1,i) = nan;
            phs(1,i) = nan;
            continue;
        end
        [mags(1,i),index] = max(mag(k));%找到范围内最大的值
        fres(1,i) = f(k(index));
        phs(1,i) = p(k(index));
    end
end

function [fre,mag,ph] = fft_byColumn( waves,Fs )
%多列频谱分析
for i=1:size(waves,2)  
    [fre(:,i),mag(:,i),ph(:,i)]...
            = frequencySpectrum(detrend(waves(:,i)),Fs);    
end
end


