function vdpath = getPureVesselDataPath( rpm )
%��ȡ��һ����޵�����
%   rpm �Ƕ�Ӧת�٣��ֱ�Ϊ300��420
dataPath = getDataPath();
fileName = {};
switch rpm
case 300
    fileName = sprintf('����޿���%dת��ѹ.mat', rpm);
case 420
    fileName = sprintf('����޿���%dת��ѹ.mat', rpm);
otherwise
    error('ת����Ҫ�趨Ϊ300��420��Ŀǰֻ����������ת��');
end
vdpath = fullfile(dataPath,'ʵ��ԭʼ����/���ڼ������/',fileName);

end

