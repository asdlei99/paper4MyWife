function [xThe,yThe] = idealVesselPlusValue()
%���뵥�ݽ��
dataPath = getDataPath();
mat = xlsread(fullfile(dataPath,'ʵ�鵥������.csv'));
xThe = mat(:,1);
yThe = mat(:,2);
end

