function val = getCombineDataValue( combineDataStrcut,baseField,valFieldName)
%��ȡ�������ݵĶ�Ӧfield������
%   
    st = getfield(combineDataStrcut,baseField);
    val = getfield(st,valFieldName);
end

