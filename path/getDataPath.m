function path = getDataPath()
%获取数据文件夹
currentPath = fileparts(mfilename('fullpath'));
path = fullfile(currentPath,'../../[04]数据/');
end

