function res = loadExpCombineDataStrcutData(dataStructPath,baseField)
%加载实验联合数据的结构体的指定对象
% 
%  
	st = loadExpCombineDataStrcut(dataStructPath);
	res = getfield(st,baseField);
end
