function [ meanVal,stdVal,maxVal,minVal ] = getExpCombineReadSuppressionLevelData(dataStruct)
%加载联合数据的手动读取的压力脉动数据
%   联合数据的结构体

    if ~isfield(dataStruct,'readSuppressionLevel')
        meanVal = nan;
        stdVal = nan;
        maxVal = nan;
        minVal = nan;
        return;
    end
    m = dataStruct.readSuppressionLevel;
    meanVal = mean(m);
    stdVal = std(m,0,1);
    maxVal = max(m);
    minVal = min(m);
end

