function res = loadExpDataStrcutCellsData(dataFileCellPath,dataNumIndex,dataField,innerField)
%����ʵ������dataStrcutCells�����һ����
% �൱��dataStrcutCells{dataNumIndex,2}.dataField.innerField
%
% dataFileCellPath �����ļ���·
% dataNumIndex ��ȡ������������1~5
% dataField ��Ӧ��field
% innerField ��
%  
	st = load(dataFileCellPath);
	dataStructCells = st.dataStructCells;
	st = dataStructCells{dataNumIndex,2};
	st = getfield(st,dataField);
	res = getfield(st,innerField);
end