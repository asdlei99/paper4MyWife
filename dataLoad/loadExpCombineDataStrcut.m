function res = loadExpCombineDataStrcut(dataStructPath)
%����ʵ���������ݵĽṹ��
%  
	res = load(dataStructPath);
	res = res.combineDataStruct;
end
