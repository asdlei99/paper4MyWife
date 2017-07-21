function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci]  = getExpCombineNatureFrequencyDatas(dataCombineStruct,freTimes,baseField)
%加载联合实验数据的压力的倍频信息，[频率]
% dataStrcutCells 联合实验数据的combinedatastruct
% freTimes 倍频信息，可输入：0.5,1,1.5,2,2.5,3
% baseField 对应的field，'rawData','subSpectrumData','saMainFreFilterStruct',若不指定，为rawData
    if nargin < 3
        dataField = 'rawData';
    end
    if 0.5 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'semiFreMag1',baseField);
    elseif 1 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'multFreMag1',baseField);
    elseif 1.5 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'semiFreMag2',baseField);
    elseif 2 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'multFreMag2',baseField);
    elseif 2.5 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'semiFreMag3',baseField);
    elseif 3 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'multFreMag3',baseField);
    end

end

