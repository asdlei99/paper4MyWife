function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci ] = constExpVesselPressrePlus(rpm)
%��ȡ����޵�����ѹ����ֵ
dataPat = getPureVesselCombineDataPath(rpm);
st = loadExpCombineDataStrcut(dataPat);
[ meanVal,stdVal,maxVal,minVal,muci,sigmaci ] = getExpCombineReadedPlusData(st);
end

