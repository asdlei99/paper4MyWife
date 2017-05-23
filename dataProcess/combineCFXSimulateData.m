function [pressure,time] = combineCFXSimulateData( varargin)
%把多个时间的模拟数据联合起来
%
dataPaths = {};
isFluent = 0;
loadDataStartTime = nan;
loadDataEndTime = nan;
Fs = 0;
section = {};
pp=varargin;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
    case 'datapaths'
        dataPaths = val;
    case 'loaddatastarttime'
        loadDataStartTime = val;
    case 'loaddataendtime'
        loadDataEndTime = val;
    case 'section' %
        section=val;
    case 'fs' %采样率
        Fs=val;
    case 'isfluent'
        isFluent = val;
    otherwise
        error('参数输入错误！参数“%s”不适用',prop);
    end
end
rawData = cell(length(dataPaths),1);
times = cell(length(dataPaths),1);
for i = 1:length(dataPaths)
    [rawData{i},times{i}] = fun_loadPressureData(dataPaths{i},'simulation'...
            ,'section',section...
            ,'Fs',Fs...
            ,'loadDataStartTime',loadDataStartTime...
            ,'loadDataEndTime',loadDataEndTime...
            ,'isFluent',isFluent...
            );  
end
pressure = [];
time = [];
for i = 1:length(rawData)
    pressure = [pressure;rawData{i}];
    time = [time;times{i}];
end


end

