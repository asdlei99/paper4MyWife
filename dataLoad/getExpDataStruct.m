function st = getExpDataStruct( dataStrcutCells,dataNumIndex,dataField)
%����ʵ�����ݵĵĽṹ��
% dataStrcutCells ���������cell
% dataNumIndex ��ȡ������������1~5
% dataField ��Ӧ��field��'rawData','subSpectrumData','saMainFreFilterStruct',����ָ����ΪrawData
    if nargin < 3
        dataField = 'rawData';
    end
    st = dataStrcutCells{dataNumIndex,2};
    st = getfield(st,dataField);
end

