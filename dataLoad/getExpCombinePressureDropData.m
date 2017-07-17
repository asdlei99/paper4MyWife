function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci,pressureDropArr] = getExpCombinePressureDropData(dataStruct,measureRang,dataField)
%�����������ݵ���������ѹ����
%   dataStruct �������ݵĽṹ��
%   measureRang:��㷶Χ��1X2���󣩣�ѹ��������meanPressure(measureRang(1)) - meanPressure(measureRang(2))
%   baseField:rawData��������
    if nargin < 3
        dataField = 'rawData';
    end
    st = getfield(dataStruct,dataField);
    pressureMean = st.pressureMean;
    pressureDropArr = useRang(pressureMean,measureRang);
    meanVal = mean(pressureDropArr);
    stdVal = std(pressureDropArr,0,1);
    maxVal = max(pressureDropArr);
    minVal = min(pressureDropArr);
    [~,~,muci,sigmaci] = normfit(pressureDropArr,0.05);
end

function v = useRang(arr,measureRang)
    v = arr(:,measureRang(1))- arr(:,measureRang(2));
end