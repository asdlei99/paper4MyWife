function [ meanVal,stdVal,maxVal,minVal ] = getExpCombineReadSuppressionLevelData(dataStruct)
%�����������ݵ��ֶ���ȡ��ѹ����������
%   �������ݵĽṹ��

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

