function res = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,innerField)
%加载实验数据dataStrcutCells的最后一层数据
% 相当于dataStrcutCells{dataNumIndex,2}.dataField.innerField
%
% dataStrcutCells 总体的数据cell
% dataNumIndex 获取的数据索引：1~5
% dataField 对应的field
% innerField 键值
%  
	st = dataStrcutCells{dataNumIndex,2};
	st = getfield(st,dataField);
	res = getfield(st,innerField);
end