function dataStructCells = loadExpDataStructCellFromFolderPath(dataFolder)
%传入一个文件夹路径获取它的实验结果的DataStructCell
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

