function res = loadExpCombineDataStrcut(dataStructPath,baseField)
%����ʵ�����ݵĽṹ��
% �൱��dataStrcutCells{dataNumIndex,2}.dataField.innerField
%
% dataStrcutCells ���������cell
% dataNumIndex ��ȡ������������1~5
% dataField ��Ӧ��field
% innerField ��ֵ
%  
	st = load(dataStructPath);
	st = st.combineDataStruct;
	res = getfield(st,baseField);
end