function val = getCombineDataValue( combineDataStrcut,baseField,valFieldName)
%获取联合数据的对应field的内容
%   
    st = getfield(combineDataStrcut,baseField);
    val = getfield(st,valFieldName);
end

