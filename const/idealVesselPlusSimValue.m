function [xSim,ySim] = idealVesselPlusSimValue()
%���뵥�ݽ��
dataPath = getDataPath();
mat = xlsread(fullfile(dataPath,'ʵ�鵥������.csv'));
xSim = mat(:,3);
ySim = mat(:,4);
xSim(isnan(xSim))=[];
ySim(isnan(ySim))=[];
end