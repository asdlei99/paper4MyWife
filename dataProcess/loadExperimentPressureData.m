function res = loadExperimentPressureData(filePath)
%加载压力数据
% experiment 代表实验数据
if strcmpi(filePath(length(filePath)-2:end),'csv')
    [num,~,~] = xlsread(filePath);
    res = num(:,2:end);
else
    [num,~,~] = xlsread(filePath);
    res = num(:,3:end);        
end
end

