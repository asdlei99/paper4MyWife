function dataStructCell = loadSimDataStructCell(dataStructPath)
%����ģ�����ݵĵ�DataStructCells
    dataStructCell = load(dataStructPath);
    dataStructCell = dataStructCell.simulationDataStruct;
end

