function dataStructCell = loadSimDataStructCellFromFolderPath(dataFolder)
%����һ���ļ���·����ȡ����ʵ������DataStructCell
    dataStructCell = nan;
    fileInfoList = dir(dataFolder);
    dataCellsStructName = constSimDataStructCellFileName();
    dataCellsStructName = strcat(dataCellsStructName,'.mat');
    for i=1:length(fileInfoList)
        if strcmp(fileInfoList(i).name,dataCellsStructName)
            dataStructCell = loadSimDataStructCell(fullfile(dataFolder,dataCellsStructName));
        end
    end
end

