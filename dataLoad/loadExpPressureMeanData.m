function  meanPressure  = loadExpPressureMeanData( dataStrcutCells,dataNumIndex,dataField )
%����ʵ��ѹ�����ݵľ�ֵ
%   
% dataStrcutCells ���������cell
% dataNumIndex ��ȡ������������1~5
% dataField ��Ӧ��field��'rawData','subSpectrumData','saMainFreFilterStruct',����ָ����ΪrawData
%
    if nargin < 3
        dataField = 'rawData';
    end
    meanPressure = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'statisPara')(1,:);

end

