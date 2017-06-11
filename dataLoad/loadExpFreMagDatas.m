function [ fre,mag ] = loadExpFreMagDatas( dataStrcutCells,dataNumIndex,dataField)
%����ʵ�����ݵ�ѹ����Ƶ����Ϣ��[Ƶ�ʣ���ֵ]
% dataStrcutCells ���������cell
% dataNumIndex ��ȡ������������1~5
% dataField ��Ӧ��field��'rawData','subSpectrumData','saMainFreFilterStruct',����ָ����ΪrawData
    if nargin < 3
        dataField = 'rawData';
    end
    fre = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'Fre');
    mag = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'Maf');


end

