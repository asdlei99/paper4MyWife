function sigmaPlusValue = loadSigmaPlusValueStructFromFolderPath (dataFolder)
%����һ���ļ���·����ȡ�����˹���ȡ�����ṹ��
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

