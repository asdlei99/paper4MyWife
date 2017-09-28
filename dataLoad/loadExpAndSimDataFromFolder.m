function [expDataStructCells,expCombineDataStruct,simDataStructCell] = loadExpAndSimDataFromFolder(dataStructPath)
%加载实验及模拟数据
     [expDataStructCells,expCombineDataStruct] = loadExpDataFromFolder(dataStructPath);
     simDataStructCell = loadSimDataStructCellFromFolderPath(dataStructPath);
end

