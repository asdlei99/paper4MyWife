function [combineDataStruct,rpm] = combineExprimentMatFile(matFilePath)
%% �����Ѿ�������Ԥ�����ʵ������mat�ļ����Զ������ݽ�������
% 
    ds = load(matFilePath,'dataStructCells');
    ds = ds.dataStructCells;
    rpm = ds{1,2}.input.baseFrequency * 60 / 2;
    %��ʼ����
    combineData = dealWithField(ds,'rawData');
    if isstruct(combineData)
        combineDataStruct.rawData = combineData;
    end
    combineData = dealWithField(ds,'subSpectrumData');
    if isstruct(combineData)
        combineDataStruct.subSpectrumData = combineData;
    end
    combineData = dealWithField(ds,'saMainFreFilterStruct');
    if isstruct(combineData)
        combineDataStruct.saMainFreFilterStruct = combineData;
    end
    %�����˶�����
    if size(ds,2) > 2
    %˵������Ϊ��ȡ������
        combineData = combineReadPressurePlusData(ds);
        combineDataStruct.readPlus = combineData;
        %��������������
        
        pureVesselPath = getPureVesselDataPath(rpm);
        dv = load(pureVesselPath,'dataStructCells');
        dv = dv.dataStructCells;
        if size(dv,2) < 3
            return;
        end
        
        for i=1:size(dv,1)
            suppressionLevel(i,:) = (dv{i,3} - ds{i,3}) ./ dv{i,3};
        end
        combineDataStruct.readSuppressionLevel = suppressionLevel;
        combineDataStruct.descripe = {'readPlus����Ϊ��ȡ��ѹ����������';'readSuppressionLevel����Ϊ��ȡ���ݺ͵�һ����޽��е����������ʼ���'...
                ;'��SL��β���Ǻ͵�һ����޽��жԱȵ���������multFreMag1SL'};
    end

    %���㻺��޵�����
    vesselCombineDataStruct = getPureVesselCombineDataStruct(rpm);
    if ~isnan(vesselCombineDataStruct)
        combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'rawData');
        combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'subSpectrumData');
        combineDataStruct = calcSuppressionLevel(combineDataStruct,vesselCombineDataStruct,'saMainFreFilterStruct');
    end

end

function combineData = dealWithField(dataStructCells,fieldName)
    for i = 1:size(dataStructCells,1)
        ds = dataStructCells{i,2};
        if ~isfield(ds,fieldName)
            return
        end
        datas = getfield(ds,fieldName);
        %rawData
        %multFreMag
        for row = 1:size(datas.multFreMag,1)
            eval(sprintf('combineData.multFreMag%d(i,:) = datas.multFreMag(%d,:);',row,row));
        end
        %semiFreMag
        for row = 1:size(datas.semiFreMag,1)
            eval(sprintf('combineData.semiFreMag%d(i,:) = datas.semiFreMag(%d,:);',row,row));
        end
        %statisPara - mean
        combineData.pressureMean(i,:) = datas.statisPara(1,:);
        %statisPara - mean
        combineData.pressureMedian(i,:) = datas.statisPara(2,:);
        %statisPara - max
        combineData.pressureMax(i,:) = datas.statisPara(3,:);
        %statisPara - min
        combineData.pressureMin(i,:) = datas.statisPara(4,:);
        %statisPara - mode ����
        combineData.pressureMode(i,:) = datas.statisPara(5,:);
        %statisPara - std ��׼��
        combineData.pressureStd(i,:) = datas.statisPara(6,:);
        %statisPara - var ����
        combineData.pressureVar(i,:) = datas.statisPara(7,:);
        %statisPara - Skewness ƫ��
        combineData.pressureSkewness(i,:) = datas.statisPara(8,:);
        %statisPara - kurtosis �Ͷ�
        combineData.pressureKurtosis(i,:) = datas.statisPara(9,:);

        %statisPara - mean
        combineData.pressureMean25(i,:) = datas.statisPara25(1,:);
        %statisPara - mean
        combineData.pressureMedian25(i,:) = datas.statisPara25(2,:);
        %statisPara - max
        combineData.pressureMax25(i,:) = datas.statisPara25(3,:);
        %statisPara - min
        combineData.pressureMin25(i,:) = datas.statisPara25(4,:);
        %statisPara - mode ����
        combineData.pressureMode25(i,:) = datas.statisPara25(5,:);
        %statisPara - std ��׼��
        combineData.pressureStd25(i,:) = datas.statisPara25(6,:);
        %statisPara - var ����
        combineData.pressureVar25(i,:) = datas.statisPara25(7,:);
        %statisPara - Skewness ƫ��
        combineData.pressureSkewness25(i,:) = datas.statisPara25(8,:);
        %statisPara - kurtosis �Ͷ�
        combineData.pressureKurtosis25(i,:) = datas.statisPara25(9,:);

        % pulsationValue
        combineData.pulsationValue(i,:) = datas.pulsationValue;
        % pulsationRate
        combineData.pulsationRate(i,:) = datas.pulsationRate;
    end


end

function combineData = combineReadPressurePlusData(dataStructCells)
    for i = 1:size(dataStructCells,1)
        combineData(i,:) = dataStructCells{i,3};
    end
end
