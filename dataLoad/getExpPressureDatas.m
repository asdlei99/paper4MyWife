function pressures = getExpPressureDatas(dataStrcutCellsPath,dataNumIndex,dataField)
%����ʵ������
%
% dataStrcutCells ���������cell
% dataNumIndex ��ȡ������������1~5
% dataField ��Ӧ��field��'rawData','subSpectrumData','saMainFreFilterStruct',����ָ����ΪrawData
%  
    if nargin < 3
        dataField = 'rawData';
    end
    st = getExpDataStruct(dataStrcutCellsPath,dataNumIndex,dataField);
    pressures = getfield(st,'pressure');
    
end
