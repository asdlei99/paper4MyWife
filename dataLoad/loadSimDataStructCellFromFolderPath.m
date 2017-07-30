function dataStructCell = loadSimDataStructCellFromFolderPath(dataFolder)
%传入一个文件夹路径获取它的实验结果的DataStructCell
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

