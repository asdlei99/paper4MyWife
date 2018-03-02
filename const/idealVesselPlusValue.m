function [xThe,yThe] = idealVesselPlusValue()
%理想单容结果
dataPath = getDataPath();
mat = xlsread(fullfile(dataPath,'实验单容数据.csv'));
xThe = mat(:,1);
yThe = mat(:,2);
end

