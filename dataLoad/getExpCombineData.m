function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataStruct,subField,baseField)
%������������
%   �������ݵĽṹ��·��
%   baseField ����field
%   subField ��field
    if nargin < 3
        baseField = 'rawData';
    end
    dataStruct = getfield(dataStruct,baseField);
    if ~isfield(dataStruct,subField)
        meanVal = nan;
        stdVal = nan;
        maxVal = nan;
        minVal = nan;
        return;
    end
    m = getfield(dataStruct,subField);
    meanVal = mean(m);
    stdVal = std(m,0,1);
    maxVal = max(m);
    minVal = min(m);
    [~,~,muci,sigmaci] = normfit(m,0.05);
end

