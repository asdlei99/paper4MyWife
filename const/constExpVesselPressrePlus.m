function [ meanVal,stdVal,maxVal,minVal ] = constExpVesselPressrePlus(rpm)
%��ȡ����޵�����ѹ����ֵ
dataPat = getPureVesselCombineDataPath(rpm);
st = loadExpCombineDataStrcut(dataPat);
[ meanVal,stdVal,maxVal,minVal ] = getExpCombineReadedPlusData(st);
end

