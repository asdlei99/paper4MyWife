function res = loadExpDataStrcutCellsData(dataFileCellPath,dataNumIndex,dataField,innerField)
%加载实验数据dataStrcutCells的最后一层数�?
% 相当于dataStrcutCells{dataNumIndex,2}.dataField.innerField
%
% dataFileCellPath 数据文件的路�?
% dataNumIndex 获取的数据索引：1~5
% dataField 对应的field
% innerField 键�?
%  
	st = load(dataFileCellPath);
	dataStructCells = st.dataStructCells;
	st = dataStructCells{dataNumIndex,2};
	st = getfield(st,dataField);
	res = getfield(st,innerField);
end