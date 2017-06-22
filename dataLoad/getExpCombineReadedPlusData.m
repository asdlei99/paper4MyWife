function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci ] = getExpCombineReadedPlusData(dataStruct)
%�����������ݵ��ֶ���ȡ��ѹ����������
%   �������ݵĽṹ��

    if ~isfield(dataStruct,'readPlus')
        meanVal = nan;
        stdVal = nan;
        maxVal = nan;
        minVal = nan;
        return;
    end
    m = dataStruct.readPlus;
    meanVal = mean(m);
    stdVal = std(m,0,1);
    maxVal = max(m);
    minVal = min(m);
    [~,~,muci,sigmaci] = normfit(m,0.05);
end

