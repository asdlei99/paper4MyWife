function p = getPlotOutputPath()
%��ȡĬ������ͼƬ��·��
    currentPath = fileparts(mfilename('fullpath'));
    p = fullfile(currentPath,'../../[02]����ͼ/');
end

