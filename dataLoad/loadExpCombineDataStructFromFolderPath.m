function combineDataStruct = loadExpCombineDataStructFromFolderPath(dataFolder)
%����һ���ļ���·����ȡ����ʵ������DataStructCell
    combineDataStruct = nan;
    fileInfoList = dir(dataFolder);
    combineDataStructName = constCombineDataStructFileName();
    combineDataStructName = strcat(combineDataStructName,'.mat');
    for i=1:length(fileInfoList)
        if strcmp(fileInfoList(i).name,combineDataStructName)
            combineDataStruct = loadExpCombineDataStrcut(fullfile(dataFolder,combineDataStructName));
        end
        
    end
end

