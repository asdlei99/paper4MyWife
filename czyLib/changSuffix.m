function changedSuffixPath = changSuffix(fileFullPath,newSuffix)
%改变一个路径或文件的后缀名
    sindex = strfind(fileFullPath,'.');
    changedSuffixPath = fileFullPath(1:sindex(end));
    changedSuffixPath = [changedSuffixPath,newSuffix];
end

