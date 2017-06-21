function st = getExpDataStruct( dataStrcutCells,dataNumIndex,dataField)
%加载实验数据的的结构体
% dataStrcutCells 总体的数据cell
% dataNumIndex 获取的数据索引：1~5
% dataField 对应的field，'rawData','subSpectrumData','saMainFreFilterStruct',若不指定，为rawData
    if nargin < 3
        dataField = 'rawData';
    end
    st = dataStrcutCells{dataNumIndex,2};
    st = getfield(st,dataField);
end

