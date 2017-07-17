function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci ] = getExpCombinePressureDropData(dataStruct,measureRang,baseField)
%�����������ݵ���������ѹ����
%   dataStruct �������ݵĽṹ��
%   measureRang:��㷶Χ��1X2���󣩣�ѹ��������meanPressure(measureRang(1)) - meanPressure(measureRang(2))
%   baseField:rawData��������

    
    [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataStruct,'pressureMean',dataField);
    m = dataStruct.readPlus;
    meanVal = mean(m);
    stdVal = std(m,0,1);
    maxVal = max(m);
    minVal = min(m);
    [~,~,muci,sigmaci] = normfit(m,0.05);
end

