function res = loadExpCombineDataStrcut(dataStructPath)
%����ʵ���������ݵĽṹ��
%  
	res = load(dataStructPath);
	res = st.combineDataStruct;
end
