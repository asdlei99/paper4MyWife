function st = getPureVesselCombineDataStruct( rpm )
%获取单一缓冲罐的combine数据
%   转速
    dataPath = getPureVesselCombineDataPath(rpm);
    load(dataPath,'st');
end

