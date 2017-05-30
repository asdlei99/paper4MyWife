function [valMean,valStd,valMax,valMin] = getCombineDataStatisticValue( combineDataStrcut,baseField,valFieldName)
%获取联合数据的对应field的内容，获取的内容以[均值,方差,最大值,最小值]的形式返回，每次获取都会计算对应field的四个统计量
%   
    valMat = getCombineDataValue(combineDataStrcut,baseField,valFieldName);
    valMean = mean(valMat);
    valStd = std(valMat);
    valMax = max(valMat);
    valMin = min(valMat);
end

