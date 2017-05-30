function meanPressure = getMeanExperimentPressure(fileFullPath,varargin)
%获取一个实验excel文件的压力均值
rawData = loadExperimentPressureData(fileFullPath);
meanPressure = mean(rawData);
end