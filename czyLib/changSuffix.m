function changedSuffixPath = changSuffix(fileFullPath,newSuffix)
%�ı�һ��·�����ļ��ĺ�׺��
    sindex = strfind(fileFullPath,'.');
    changedSuffixPath = fileFullPath(1:sindex(end));
    changedSuffixPath = [changedSuffixPath,newSuffix];
end

