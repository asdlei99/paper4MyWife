function  meanPressure  = getExpPressureMeanData( dataStrcutCellsPath,dataNumIndex,dataField )
%����ʵ��ѹ�����ݵľ�ֵ
%   
% dataStrcutCells ���������cell
% dataNumIndex ��ȡ������������1~5
% dataField ��Ӧ��field��'rawData','subSpectrumData','saMainFreFilterStruct',����ָ����ΪrawData
%

    if nargin < 3
        dataField = 'rawData';
    end
    st = getExpDataStruct(dataStrcutCellsPath,dataNumIndex,dataField);
    pressures = getfield(st,'statisPara')(1,:);
end

