function meanPressure = getMeanExperimentPressure(fileFullPath,varargin)
%��ȡһ��ʵ��excel�ļ���ѹ����ֵ
rawData = loadExperimentPressureData(fileFullPath);
meanPressure = mean(rawData);
end