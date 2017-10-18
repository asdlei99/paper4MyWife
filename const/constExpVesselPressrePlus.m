function [ meanVal,stdVal,maxVal,minVal,muci,sigmaci ] = constExpVesselPressrePlus(rpm)
%获取缓冲罐的脉动压力均值
dataPat = getPureVesselCombineDataPath(rpm);
st = loadExpCombineDataStrcut(dataPat);
[ meanVal,stdVal,maxVal,minVal,muci,sigmaci ] = getExpCombineReadedPlusData(st);
end

