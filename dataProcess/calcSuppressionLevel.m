function dataCombineStructEx = calcSuppressionLevel(dataCombineStruct,vesselCombineDataStruct,baseField)
%% ����combineStruct,���ݻ���޵�combine data���ݣ�����������
    
    if nargin < 3
        baseField = 'rawData';
    end
    dataCombineStruct = calcOneField(dataCombineStruct,vesselCombineDataStruct,baseField,'multFreMag1');
    dataCombineStruct = calcOneField(dataCombineStruct,vesselCombineDataStruct,baseField,'multFreMag2');
    dataCombineStruct = calcOneField(dataCombineStruct,vesselCombineDataStruct,baseField,'multFreMag3');
    dataCombineStruct = calcOneField(dataCombineStruct,vesselCombineDataStruct,baseField,'semiFreMag1');
    dataCombineStruct = calcOneField(dataCombineStruct,vesselCombineDataStruct,baseField,'semiFreMag2');
    dataCombineStruct = calcOneField(dataCombineStruct,vesselCombineDataStruct,baseField,'semiFreMag3');
    dataCombineStruct = calcOneField(dataCombineStruct,vesselCombineDataStruct,baseField,'pulsationValue');
    dataCombineStructEx = dataCombineStruct;
end

function dataCombineStructEx = calcOneField(dataCombineStruct,vesselCombineDataStruct,baseField,valField)
    dataCombineStructEx = dataCombineStruct;
    if isCombineDataStructHaveField(dataCombineStruct,baseField,valField)
        st = getfield(dataCombineStruct,baseField);
        [vesselValMean,~,~,~] = getCombineDataStatisticValue(vesselCombineDataStruct,baseField,valField);
        val = getCombineDataValue(dataCombineStruct,baseField,valField);
        tmp = val;
        for i = 1:size(val,1)
            tmp(i,:) = (vesselValMean - val(i,:)) ./ vesselValMean;
        end
        st = setfield(st,sprintf('%sSL',valField),tmp);%SL�������ʵ���˼
        dataCombineStructEx = setfield(dataCombineStructEx,baseField,st);
    end
end
