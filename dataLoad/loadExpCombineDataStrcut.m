function res = loadExpCombineDataStrcut(dataStructPath)
%加载实验联合数据的结构体
%  
	res = load(dataStructPath);
	res = res.combineDataStruct;
end
