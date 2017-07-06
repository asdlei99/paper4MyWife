function combineDataStruct = loadExpCombineDataStructFromFolderPath(dataFolder)
%传入一个文件夹路径获取它的实验结果的DataStructCell
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

