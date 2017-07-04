function vdpath = getPureVesselCombineDataPath( rpm )
%获取单一缓冲罐的数据
%   rpm 是对应转速，分别为300和420
dataPath = getDataPath();
vdpath = fullfile(dataPath,'实验原始数据/无内件缓冲罐',sprintf('RPM%d',rpm),'combineDataStruct.mat');

end

