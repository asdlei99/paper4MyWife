function [valMean,valStd,valMax,valMin] = getCombineDataStatisticValue( combineDataStrcut,baseField,valFieldName)
%��ȡ�������ݵĶ�Ӧfield�����ݣ���ȡ��������[��ֵ,����,���ֵ,��Сֵ]����ʽ���أ�ÿ�λ�ȡ��������Ӧfield���ĸ�ͳ����
%   
    valMat = getCombineDataValue(combineDataStrcut,baseField,valFieldName);
    valMean = mean(valMat);
    valStd = std(valMat);
    valMax = max(valMat);
    valMin = min(valMat);
end

