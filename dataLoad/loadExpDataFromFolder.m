function [dataStructCells,combineDataStruct] = loadExpDataFromFolder(dataStructPath)
%����ʵ������
    dataStructCells = loadExpDataStructCellFromFolderPath(dataStructPath);
    combineDataStruct = loadExpCombineDataStructFromFolderPath(dataStructPath);
end

