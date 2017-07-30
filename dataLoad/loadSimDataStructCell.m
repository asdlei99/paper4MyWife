function dataStructCell = loadSimDataStructCell(dataStructPath)
%加载模拟数据的的DataStructCells
    dataStructCell = load(dataStructPath);
    dataStructCell = dataStructCell.simulationDataStruct;
end

