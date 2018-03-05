function [xSim,ySim] = idealVesselPlusSimValue()
%理想单容结果
dataPath = getDataPath();
mat = xlsread(fullfile(dataPath,'实验单容数据.csv'));
xSim = mat(:,3);
ySim = mat(:,4);
xSim(isnan(xSim))=[];
ySim(isnan(ySim))=[];
end