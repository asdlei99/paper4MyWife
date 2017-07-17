function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci ] = getExpCombinePressureDropData(dataStruct,measureRang,baseField)
%加载联合数据的两个测点的压力降
%   dataStruct 联合数据的结构体
%   measureRang:测点范围（1X2矩阵），压力降就是meanPressure(measureRang(1)) - meanPressure(measureRang(2))
%   baseField:rawData或者其他

    
    [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataStruct,'pressureMean',dataField);
    m = dataStruct.readPlus;
    meanVal = mean(m);
    stdVal = std(m,0,1);
    maxVal = max(m);
    minVal = min(m);
    [~,~,muci,sigmaci] = normfit(m,0.05);
end

