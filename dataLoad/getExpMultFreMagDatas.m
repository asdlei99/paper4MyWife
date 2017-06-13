function [ measurePointFre,measurePointMag ] = getExpMultFreMagDatas( dataStrcutCells,dataNumIndex,freTimes,dataField )
%加载实验数据的压力的倍频信息，[频率，幅值]
% dataStrcutCells 总体的数据cell
% dataNumIndex 获取的数据索引：1~5
% freTimes 倍频信息，可输入：0.5,1,1.5,2,2.5,3
% dataField 对应的field，'rawData','subSpectrumData','saMainFreFilterStruct',若不指定，为rawData
% 返回[measurePointFre,measurePointMag]都是1XN向量，N是测点数
    if nargin < 4
        dataField = 'rawData';
    end
    freField = 'Fre';
    magField = 'Mag';
    if 0.5 == freTimes
        measurePointFre = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreFre')(1,:);
        measurePointMag = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreMag')(1,:);
    elseif 1 == freTimes
        measurePointFre = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreFre')(1,:);
        measurePointMag = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreMag')(1,:);
    elseif 1.5 == freTimes
        measurePointFre = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreFre')(2,:);
        measurePointMag = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreMag')(2,:);
    elseif 2 == freTimes
        measurePointFre = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreFre')(2,:);
        measurePointMag = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreMag')(2,:);
    elseif 2.5 == freTimes
        measurePointFre = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreFre')(3,:);
        measurePointMag = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'semiFreMag')(3,:);
    elseif 3 == freTimes
        measurePointFre = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreFre')(3,:);
        measurePointMag = loadExpDataStrcutCellsData(dataStrcutCells,dataNumIndex,dataField,'multFreMag')(3,:);
    end

end

