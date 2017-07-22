function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci]  = getExpCombineNatureFrequencyDatas(dataCombineStruct,freTimes,baseField)
%��������ʵ�����ݵ�ѹ���ı�Ƶ��Ϣ��[Ƶ��]
% dataStrcutCells ����ʵ�����ݵ�combinedatastruct
% freTimes ��Ƶ��Ϣ�������룺0.5,1,1.5,2,2.5,3
% baseField ��Ӧ��field��'rawData','subSpectrumData','saMainFreFilterStruct',����ָ����ΪrawData
    if nargin < 3
        dataField = 'rawData';
    end
    if 0.5 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'semiFreMag1',baseField);
    elseif 1 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'multFreMag1',baseField);
    elseif 1.5 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'semiFreMag2',baseField);
    elseif 2 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'multFreMag2',baseField);
    elseif 2.5 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'semiFreMag3',baseField);
    elseif 3 == freTimes
        [ meanVal,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombineData(dataCombineStruct,'multFreMag3',baseField);
    end

end

