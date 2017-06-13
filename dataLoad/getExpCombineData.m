function [ meanVal,stdVal,maxVal,minVal ] = getExpCombineData(dataStructPath,baseField,subField)
%加载联合数据
%   联合数据的结构体路径
%   baseField 基本field
%   subField 子field
    st = loadExpCombineDataStrcut(dataStructPath,baseField);
    m = getfield(st,subField);
    meanVal = mean(m);
    stdVal = std(m,0,1);
    maxVal = max(m);
    minVal = min(m);
end

