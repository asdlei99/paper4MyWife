function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci,pressureDropArr] = getExpCombinePressureDropData(dataStruct,measureRang,dataField)
%加载联合数据的两个测点的压力降
%   dataStruct 联合数据的结构体
%   measureRang:测点范围（1X2矩阵），压力降就是meanPressure(measureRang(1)) - meanPressure(measureRang(2))
%   baseField:rawData或者其他
    if nargin < 3
        dataField = 'rawData';
    end
    st = getfield(dataStruct,dataField);
    pressureMean = st.pressureMean;
    pressureDropArr = useRang(pressureMean,measureRang);
    meanVal = mean(pressureDropArr);
    stdVal = std(pressureDropArr,0,1);
    maxVal = max(pressureDropArr);
    minVal = min(pressureDropArr);
    [~,~,muci,sigmaci] = normfit(pressureDropArr,0.05);
end

function v = useRang(arr,measureRang)
    v = arr(:,measureRang(1))- arr(:,measureRang(2));
end