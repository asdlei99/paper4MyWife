function [value,newVarargin] = takeVararginProperty( prop ,vararginCell, varargin )
%��varargin�Ķ�Ӧprop�����Ժ�ֵ��ȡ������������һ���ضϺ��newVarargin
%   ������Ժ�ֵ���м䣬��ȡ�󣬺�������ԻᲹ��λ��
pp = varargin;
caseSen = 0;%�Ƿ��Сд����
defaultVal = nan;
if 1 == length(pp)
    defaultVal = pp{1};
end
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'casesen'
            if ~isempty(val)
                caseSen = val;
            end
        case 'default'
            if ~isempty(val)
                defaultVal = val;
            end
        case 'd'
            if ~isempty(val)
                defaultVal = val;
            end
        otherwise
       		error('��������%s',prop);
    end
end
if iscell(prop)
    value = cell(1,length(prop));
    for i = 1:length(prop)
        [value{i},newVarargin] = takeVararginProperty_1dim( prop{i} , caseSen,defaultVal,vararginCell );
    end
else
    [value,newVarargin] = takeVararginProperty_1dim( prop, caseSen ,defaultVal, vararginCell );
end
end




function [value,newVarargin] = takeVararginProperty_1dim( prop ,caseSen, defaultVal,vararginCell )
    newVarargin = {};
    if caseSen
        prop = lower(prop);
    end
    for i = 1:2:length(vararginCell)
        pp = vararginCell{i};
        if caseSen
            pp = lower(pp);
        end
        if strcmp(prop,pp)
            value = vararginCell{i+1};
            if i~=1
                newVarargin(1:i-1) = vararginCell(1:i-1);
            end
            if i+1 ~= length(vararginCell)
                newVarargin = push_back_cell(newVarargin,vararginCell((i+2):end));
            end
            return;
        end
    end
    value = defaultVal;
    newVarargin = vararginCell;
end




function newData = push_back_mat(org,data)
    orgLen = length(org);
    dataLen = length(data);
    for i=1:dataLen
        org(orgLen+i) = data(i);
    end
    newData = org;
end




function newData = push_back_cell(org,data)
    orgLen = length(org);
    dataLen = length(data);
    for i=1:dataLen
        org{orgLen+i} = data{i};
    end
    newData = org;
end
