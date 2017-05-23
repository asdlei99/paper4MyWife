function folderName = currentFolder(pathName)
%提取完整路径的最后目录
	index = strfind(pathName,'/');
	if isempty(index)
		index = strfind(pathName,'\');
	end
	if isempty(index)
		return;
    end
    if index(end) == length(pathName)
        index = index(end-1)+1;
    else
        index = index(end)+1;
    end
	folderName = pathName(index:end);
end