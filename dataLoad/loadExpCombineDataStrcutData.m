function res = loadExpCombineDataStrcutData(dataStructPath,baseField)
%����ʵ���������ݵĽṹ���ָ������
% 
%  
	st = loadExpCombineDataStrcut(dataStructPath);
	res = getfield(st,baseField);
end
