function res = loadExperimentPressureData(filePath)
%����ѹ������
% experiment ����ʵ������
if strcmpi(filePath(length(filePath)-2:end),'csv')
    [num,~,~] = xlsread(filePath);
    res = num(:,2:end);
else
    [num,~,~] = xlsread(filePath);
    res = num(:,3:end);        
end
end

