function combineDataStruct = loadExpCombineDataStructFromFolderPath(dataFolder)
%����һ���ļ���·����ȡ����ʵ������DataStructCell
    combineDataStruct = nan;
    fileInfoList = dir(dataFolder);
    combineDataStructName = constCombineDataStruct();
    combineDataStructName = strcat(combineDataStructName,'.m');
    for i=1:length(fileInfoList)
        if strcmp(fileInfoList[i].name,combineDataStructName)
            combineDataStruct = load(fullfile(dataFolder,combineDataStructName));
            combineDataStruct = st.combineDataStruct;
        end
        
    end
end

