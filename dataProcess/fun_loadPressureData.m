function [res,times] = fun_loadPressureData(filePath,dataType,varargin)
%加载压力数据
% experiment 代表实验数据
section = {};
pp=varargin;
loadDataStartTime = nan;
loadDataEndTime = nan;
Fs = 0;
isFluent = 0;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
    case 'section' %
        section=val;
    case 'loaddatastarttime'
        loadDataStartTime = val;
    case 'loaddataendtime'
        loadDataEndTime = val;
    case 'fs' %采样率
        Fs=val;
    case 'isfluent'
        isFluent = val;
    end
end
if strcmp(dataType,'experiment')
    if strcmpi(filePath(length(filePath)-2:end),'csv')
        [num,~,~] = xlsread(filePath);
        res = num(:,2:end);
    else
        [num,~,~] = xlsread(filePath);
        res = num(:,3:end);        
    end

elseif strcmp(dataType,'simulation')
    P = [];
    T = [];
    res = [];
    totalDataCount4Data = 0;
    if ~isFluent%说明是cfd
        filelist=dir(fullfile(filePath,'*.csv'));
        for i_files=1:length(filelist)
            xlsFilesName = filelist(i_files).name;
            if xlsFilesName(1) == '~'
                continue;
            end
            [~,txt,raw] = xlsread(fullfile(filePath,filelist(i_files).name));
            index_Name = strcmp(txt,{'[Name]'});%找到[Name]这一行
            index_Name = find(index_Name == 1);
            names = txt(index_Name+1,1);%提取名字
            %从Time[s]到下一个[Name]之间的为数据
            index_Time = strcmp(txt,{'Time [ s ]'});
            index_Time = find(index_Time == 1);
            index_data= zeros(size(names,1),2);
            for i=1:length(index_Time)-1
                index_data(i,1) = index_Time(i)+1;%数据是介于Time [ s ] 到 [Name]之间的
                index_data(i,2) = index_Name(i+1)-1;
            end
            index_data(end,1) = index_Time(end)+1;
            index_data(end,2) = size(raw,1);
            % 提取数据
            for i=1:length(index_Name);
                datas{i,1} = raw(index_data(i,1):index_data(i,2),2);%压力  
                times{i,1} = raw(index_data(i,1):index_data(i,2),1);%时间
            end
            for i=1:length(index_Name)
                totalDataCount4Data = totalDataCount4Data +1;
                temp = datas{i,1};
                temp = cell2mat(temp);
                temp(isnan(temp) == 1)=[];
                if isempty(temp)
                    error(sprintf('数据的plane%d数据缺失',i));
                end
                P(:,totalDataCount4Data) = temp./1000;
                temp = times{i,1};
                temp = cell2mat(temp);
                temp(isnan(temp) == 1)=[];
                if isempty(temp)
                    error(sprintf('数据的plane%d数据缺失',i));
                end
                T(:,totalDataCount4Data) = temp./1000;
            end
        end
    else
        %说明是fluent
        filelist=dir(fullfile(filePath,'*.out'));
        for i_files=1:length(filelist)
            filename = fullfile(filePath,filelist(i_files).name);
            endStr = regexp(filename, '-', 'split');
            endStr = endStr{end};
            index = strfind(endStr,'.');
            plane = str2num(endStr(1:index));
            d = textread(filename,'%f','headerlines',2)
            T(:,plane) = d(1:2:end);
            P(:,plane) = d(2:2:end);
        end
    end
    res = [];
    times = [];
    for i=1:size(section,1)
        res = [res P(:,section{i,1})];
        times = [times T(:,section{i,1})];
    end
elseif strcmp(dataType,'theory')
    [num,~,~] = xlsread(filePath);
    res = num./1000;
end

if ~isnan(loadDataStartTime) || ~isnan(loadDataEndTime)
    t = 0:(size(res,1)-1);
    t = t .* (1/Fs);
    startIndex = 1;
    endIndex = 0;
    if ~isnan(loadDataStartTime);
       index = find(t>loadDataStartTime);
       startIndex = index(1);
    end
    if ~isnan(loadDataEndTime);
       index = find(t<loadDataEndTime);
       endIndex = index(1);
    end
    if isnan(loadDataStartTime)
        res = res(1:endIndex,:);
    elseif isnan(loadDataEndTime)
        res = res(startIndex:end,:);
    else
        res = res(startIndex:endIndex,:);
    end
end
end

