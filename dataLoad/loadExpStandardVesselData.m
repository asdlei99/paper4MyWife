function [ mean,err ] = loadExpStandardVesselData()
%��ȡ��׼��������������������ʶԱȵ�����
    dataPath = getDataPath();
    baseVesselDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\RPM420');%��ǰ��ֱ���
    [~,baseVesselCombineData] = loadExpDataFromFolder(baseVesselDataPath);%��ǰ��ֱ���
    [mean,~,~,~,muci] = getExpCombineReadedPlusData(baseVesselCombineData);
    err = muci(2,:) - muci(1,:);
end

