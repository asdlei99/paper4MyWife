function [ meanVal,stdVal,maxVal,minVal ] = getExpCombineData(dataStruct,subField)
%加载联合数据
%   联合数据的结构体路径
%   baseField 基本field
%   subField 子field
    m = getfield(dataStruct,subField);
    meanVal = mean(m);
    stdVal = std(m,0,1);
    maxVal = max(m);
    minVal = min(m);
end

