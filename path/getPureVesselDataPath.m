function vdpath = getPureVesselDataPath( rpm )
%��ȡ��һ����޵�����
%   rpm �Ƕ�Ӧת�٣��ֱ�Ϊ300��420
dataPath = getDataPath();
vdpath = fullfile(dataPath,'ʵ��ԭʼ����/���ڼ������',sprintf('RPM%d',rpm),'dataStructCells.mat');

end

