function [dataStructCells,combineDataStruct] = loadExpDataFromFolder(dataStructPath)
%加载实验数据
    dataStructCells = loadExpDataStructCellFromFolderPath(dataStructPath);
    combineDataStruct = loadExpCombineDataStructFromFolderPath(dataStructPath);
end

