function st = getPureVesselCombineDataStruct( rpm )
%��ȡ��һ����޵�combine����
%   ת��
    dataPath = getPureVesselCombineDataPath(rpm);
    st = load(dataPath);
    st = st.combineDataStruct;
end

