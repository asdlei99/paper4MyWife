function [ fre,mag ] = getExpFreMagDatas( dataStrcutCells,dataNumIndex,dataField)
%加载实验数据的压力的频谱信息，[频率，幅值]
% dataStrcutCells 总体的数据cell
% dataNumIndex 获取的数据索引：1~5
% dataField 对应的field，'rawData','subSpectrumData','saMainFreFilterStruct',若不指定，为rawData
    if nargin < 3
        dataField = 'rawData';
    end
    st = getExpDataStruct(dataStrcutCells,dataNumIndex,dataField);
    fre = getfield(st,'Fre');
    mag = getfield(st,'Mag');


end

