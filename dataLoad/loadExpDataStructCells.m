function dataStructCells = loadExpDataStructCells(dataStructPath)
%加载实验数据的的DataStructCells
    dataStructCells = load(dataStructPath);
    dataStructCells = st.dataStructCells;
end

