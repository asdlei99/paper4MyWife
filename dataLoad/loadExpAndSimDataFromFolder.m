function [expDataStructCells,expCombineDataStruct,simDataStructCell] = loadExpAndSimDataFromFolder(dataStructPath)
%����ʵ�鼰ģ������
     [expDataStructCells,expCombineDataStruct] = loadExpDataFromFolder(dataStructPath);
     simDataStructCell = loadSimDataStructCellFromFolderPath(dataStructPath);
end

