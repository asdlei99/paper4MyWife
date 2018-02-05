function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombinePressureData(dataStruct,baseField)
%�����������ݵ��ֶ���ȡ��ѹ����������
%   �������ݵĽṹ��
    if nargin < 2
        baseField = 'rawData';
    end
    if ~isfield(dataStruct,baseField)
        meanVal = nan;
        stdVal = nan;
        maxVal = nan;
        minVal = nan;
        return;
    end
    m = getfield(dataStruct,baseField,'pressureMean');
    meanVal = mean(m);
    stdVal = std(m,0,1);
    maxVal = max(m);
    minVal = min(m);
    [~,~,muci,sigmaci] = normfit(m,0.05);
end

