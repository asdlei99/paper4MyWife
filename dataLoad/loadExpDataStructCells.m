function dataStructCells = loadExpDataStructCells(dataStructPath)
%����ʵ�����ݵĵ�DataStructCells
    dataStructCells = load(dataStructPath);
    dataStructCells = dataStructCells.dataStructCells;
end

