function dataStructCells = loadExpDataStructCellFromFolderPath(dataFolder)
%����һ���ļ���·����ȡ����ʵ������DataStructCell
    dataStructCells = nan;
    fileInfoList = dir(dataFolder);
    dataCellsStructName = constDataStructCellsFileName();
    dataCellsStructName = strcat(dataCellsStructName,'.m');
    for i=1:length(fileInfoList)
        if strcmp(fileInfoList[i].name,dataCellsStructName)
            dataStructCells = loadExpDataStructCells(fullfile(dataFolder,dataCellsStructName));
        end
        
    end
end

