function [ measurePointFre,measurePointMag ] = getSimMultFreMagDatas(dataStrcutCell,dataNumIndex,freTimes )
%加载实验数据的压力的倍频信息，[频率，幅值]
% dataStrcutCells 总体的数据cell
% dataNumIndex 获取的数据索引：1~5
% freTimes 倍频信息，可输入：0.5,1,1.5,2,2.5,3
% dataField 对应的field，'rawData','subSpectrumData','saMainFreFilterStruct',若不指定，为rawData
% 返回[measurePointFre,measurePointMag]都是1XN向量，N是测点数
    st = dataStrcutCell.rawData;
    if 0.5 == freTimes
        measurePointFre = getfield(st,'semiFreFre')(1,:);
        measurePointMag = getfield(st,'semiFreMag')(1,:);
    elseif 1 == freTimes
        measurePointFre = getfield(st,'multFreFre')(1,:);
        measurePointMag = getfield(st,'multFreMag')(1,:);
    elseif 1.5 == freTimes
        measurePointFre = getfield(st,'semiFreFre')(2,:);
        measurePointMag = getfield(st,'semiFreMag')(2,:);
    elseif 2 == freTimes
        measurePointFre = getfield(st,'multFreFre')(2,:);
        measurePointMag = getfield(st,'multFreMag')(2,:);
    elseif 2.5 == freTimes
        measurePointFre = getfield(st,'semiFreFre')(3,:);
        measurePointMag = getfield(st,'semiFreMag')(3,:);
    elseif 3 == freTimes
        measurePointFre = getfield(st,'multFreFre')(3,:);
        measurePointMag = getfield(st,'multFreMag')(3,:);
    end

end

