function vdpath = getPureVesselCombineDataPath( rpm )
%获取单一缓冲罐的数据
%   rpm 是对应转速，分别为300和420
dataPath = getDataPath();
fileName = {};
switch rpm
case 300
    fileName = sprintf('缓冲罐开机%d转带压_combine.mat', rpm);
case 420
    fileName = sprintf('缓冲罐开机%d转带压_combine.mat', rpm);
otherwise
    error('转速需要设定为300或420，目前只接受这两个转速');
end
vdpath = fullfile(dataPath,'实验原始数据/无内件缓冲罐/',fileName);

end

