function p = getPlotOutputPath()
%获取默认生成图片的路径
    currentPath = fileparts(mfilename('fullpath'));
    p = fullfile(currentPath,'../../[02]论文图/');
end

