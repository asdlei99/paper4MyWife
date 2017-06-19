function res = loadExpCombineDataStrcut(dataStructPath,baseField)
%加载实验数据的结构体
% 相当于dataStrcutCells{dataNumIndex,2}.dataField.innerField
%
% dataStrcutCells 总体的数据cell
% dataNumIndex 获取的数据索引：1~5
% dataField 对应的field
% innerField 键值
%  
	st = load(dataStructPath);
	res = st.combineDataStruct;
end