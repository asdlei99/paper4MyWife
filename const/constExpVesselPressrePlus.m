function [ meanVal,stdVal,maxVal,minVal ] = constExpVesselPressrePlus(rpm)
%��ȡ����޵�����ѹ����ֵ
dataPat = getPureVesselCombineDataPath(rpm);
st = loadExpCombineDataStrcut(dataPat,'rawData');
[ meanVal,stdVal,maxVal,minVal ] = getExpCombineReadedPlusData(st);
end

