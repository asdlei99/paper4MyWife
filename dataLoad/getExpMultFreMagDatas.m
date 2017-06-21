function [ measurePointFre,measurePointMag ] = getExpMultFreMagDatas( dataStrcutCells,dataNumIndex,freTimes,dataField )
%����ʵ�����ݵ�ѹ���ı�Ƶ��Ϣ��[Ƶ�ʣ���ֵ]
% dataStrcutCells ���������cell
% dataNumIndex ��ȡ������������1~5
% freTimes ��Ƶ��Ϣ�������룺0.5,1,1.5,2,2.5,3
% dataField ��Ӧ��field��'rawData','subSpectrumData','saMainFreFilterStruct',����ָ����ΪrawData
% ����[measurePointFre,measurePointMag]����1XN������N�ǲ����
    if nargin < 4
        dataField = 'rawData';
    end
    st = getExpDataStruct(dataStrcutCells,dataNumIndex,dataField);

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

