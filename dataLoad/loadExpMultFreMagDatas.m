function [ measurePointFre,measurePointMag ] = loadExpMultFreMagDatas( dataStrcutCells,dataNumIndex,freTimes,dataField )
%����ʵ�����ݵ�ѹ���ı�Ƶ��Ϣ��[Ƶ�ʣ���ֵ]
% dataStrcutCells ���������cell
% dataNumIndex ��ȡ������������1~5
% freTimes ��Ƶ��Ϣ�������룺0.5,1,1.5,2,2.5,3
% dataField ��Ӧ��field��'rawData','subSpectrumData','saMainFreFilterStruct',����ָ����ΪrawData
% ����[measurePointFre,measurePointMag]����1XN������N�ǲ����
    if nargin < 4
        dataField = 'rawData';
    end
    freField = 'Fre';
    magField = 'Mag';
    if 0.5 == freTimes
        measurePointFre = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreFre')(1,:);
        measurePointMag = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreMag')(1,:);
    elseif 1 == freTimes
        measurePointFre = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreFre')(1,:);
        measurePointMag = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreMag')(1,:);
    elseif 1.5 == freTimes
        measurePointFre = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreFre')(2,:);
        measurePointMag = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreMag')(2,:);
    elseif 2 == freTimes
        measurePointFre = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreFre')(2,:);
        measurePointMag = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreMag')(2,:);
    elseif 2.5 == freTimes
        measurePointFre = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreFre')(3,:);
        measurePointMag = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreMag')(3,:);
    elseif 3 == freTimes
        measurePointFre = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreFre')(3,:);
        measurePointMag = getExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreMag')(3,:);
    end

end

