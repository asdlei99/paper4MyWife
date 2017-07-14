function meanPressure = getMeanExperimentPressure(fileFullPath,varargin)
%获取一个实验excel文件的压力均值
sigmaTimes = 2.5;
if length(varargin) > 0
    sigmaTimes = varargin{1};
end
rawData = loadExperimentPressureData(fileFullPath);
%为了去除异常值的影响，先过sigma滤波再求均值
for i=1:size(rawData,2)
    tmp = rawData(:,i)
    out_index = sigmaOutlierDetection(tmp,2.5);
    tmp(out_index) = [];
    meanPressure(i) = mean(tmp);
end

end
