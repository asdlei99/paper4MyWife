function meanPressure = getMeanExperimentPressure(fileFullPath,varargin)
%��ȡһ��ʵ��excel�ļ���ѹ����ֵ
sigmaTimes = 2.5;
if length(varargin) > 0
    sigmaTimes = varargin{1};
end
rawData = loadExperimentPressureData(fileFullPath);
%Ϊ��ȥ���쳣ֵ��Ӱ�죬�ȹ�sigma�˲������ֵ
for i=1:size(rawData,2)
    tmp = rawData(:,i)
    out_index = sigmaOutlierDetection(tmp,2.5);
    tmp(out_index) = [];
    meanPressure(i) = mean(tmp);
end

end
