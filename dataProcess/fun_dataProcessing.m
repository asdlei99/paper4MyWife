function processDataStruct = fun_dataProcessing(rawData,varargin)
%ԭʼ���ݴ���
baseFrequency = nan;%��Ƶ
allowDeviation = 0.5;%��ȡ��Ƶʱ�������Χ��Ĭ��Ϊ0.5
multFreTimes = 3;%��Ƶ1x,2x,3x
semiFreTimes = 3;%�뱶Ƶ0.5x,1.5x,2.5x
pp = varargin;
beforeAfterMeaPoint = nan;
calcPeakPeakValueSection = 0.8;
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
            error(sprintf('����������󣡴��������%s',prop));
    end
end
if isnan(calcPeakPeakValueSection)
    calcPeakPeakValueSection = 0.8;
end
[rawFre,rawMag,rawPh] = fft_byColumn(rawData,Fs);%ԭʼ����Ƶ�׷���

for i = 1:size(rawData,2)
    colData = rawData(:,i);
end


for i=1:multFreTimes%���㱶Ƶ��ֵ����λ
    [m,p,f] = findBaseFres(rawFre,rawMag,rawPh,baseFrequency*i,allowDeviation);
    multFreMag(i,:) = m;
    multFrePh(i,:) = p;
    multFreFre(i,:) = f;
end
for i=1:semiFreTimes%����뱶Ƶ��ֵ����λ
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
processDataStruct.pulsationRate = processDataStruct.pulsationValue./processDataStruct.statisPara(1,:);%����������
%������������Ч��
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
    sData(1,:)=mean(rawData);valueName{1}='��ֵ';
    sData(2,:)=median(rawData);valueName{2}='��ֵ';
    sData(3,:)=max(rawData);valueName{3}='���ֵ';
    sData(4,:)=min(rawData);valueName{4}='��Сֵ';
    sData(5,:)=mode(rawData);valueName{5}='����';
    sData(6,:)=std(rawData);valueName{6}='��׼��';
    sData(7,:)=var(rawData);valueName{7}='����';
    sData(8,:) = skewness(rawData);valueName{8}='ƫ��';
    sData(9,:) = kurtosis(rawData);valueName{9}='�Ͷ�';    
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
        [mags(1,i),index] = max(mag(k));%�ҵ���Χ������ֵ
        fres(1,i) = f(k(index));
        phs(1,i) = p(k(index));
    end
end

function [fre,mag,ph] = fft_byColumn( waves,Fs )
%����Ƶ�׷���
for i=1:size(waves,2)  
    [fre(:,i),mag(:,i),ph(:,i)]...
            = frequencySpectrum(detrend(waves(:,i)),Fs);    
end
end


