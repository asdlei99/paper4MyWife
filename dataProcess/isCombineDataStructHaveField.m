function checkRes = isCombineDataStructHaveField( combineDataStruct,baseField,checkField )
%判断combine结构体是否存在字段
%   combineDataStruct 联合结构体
%   baseField 基本字段，‘rawData’
%   checkField 要检查的字段
    checkRes = isfield(combineDataStruct,baseField);
    if ~checkField
        return;
    end
    st = getfield(combineDataStruct,baseField);
    checkRes = isfield(st,checkField);
end

