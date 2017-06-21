function [ fre,mag ] = getExpFreMagDatas( dataStrcutCells,dataNumIndex,dataField)
%����ʵ�����ݵ�ѹ����Ƶ����Ϣ��[Ƶ�ʣ���ֵ]
% dataStrcutCells ���������cell
% dataNumIndex ��ȡ������������1~5
% dataField ��Ӧ��field��'rawData','subSpectrumData','saMainFreFilterStruct',����ָ����ΪrawData
    if nargin < 3
        dataField = 'rawData';
    end
    st = getExpDataStruct(dataStrcutCells,dataNumIndex,dataField);
    fre = getfield(st,'Fre');
    mag = getfield(st,'Mag');


end

