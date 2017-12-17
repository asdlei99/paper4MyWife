function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombinePressureBalanced(dataStruct,baseField)
%�����������ݵ�ѹ��������
%   �������ݵĽṹ��
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

