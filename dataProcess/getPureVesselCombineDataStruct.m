function st = getPureVesselCombineDataStruct( rpm )
%��ȡ��һ����޵�combine����
%   ת��
    dataPath = getPureVesselCombineDataPath(rpm);
    load(dataPath,'st');
end

