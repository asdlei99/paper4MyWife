function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombinePressureBalanced(dataStruct,baseField)
%加载联合数据的压力不均度
%   联合数据的结构体
    if 1 == nargin
        baseField = 'rawData';
    end
    pressureMean = getfield(dataStruct,baseField,'pressureMean');
    readPlus = dataStruct.readPlus;
    res = readPlus ./ pressureMean;
    meanVal = mean(res);
    stdVal = std(res,0,1);
    maxVal = max(res);
    minVal = min(res);
    [~,~,muci,sigmaci] = normfit(res,0.05);


end

