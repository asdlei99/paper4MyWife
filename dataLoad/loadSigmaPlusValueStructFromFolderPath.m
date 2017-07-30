function sigmaPlusValue = loadSigmaPlusValueStructFromFolderPath (dataFolder)
%传入一个文件夹路径获取它的人工读取脉动结构提
    sigmaPlusValue = nan;
    fileInfoList = dir(dataFolder);
    stFileName = constExpSigmaPlusValueFileName();
    stFileName = strcat(stFileName,'.mat');
    for i=1:length(fileInfoList)
        if strcmp(fileInfoList(i).name,stFileName)
            sigmaPlusValue = loadSigmaPlusValueStruct(fullfile(dataFolder,stFileName));
        end
        
    end
end

