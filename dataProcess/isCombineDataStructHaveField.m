function checkRes = isCombineDataStructHaveField( combineDataStruct,baseField,checkField )
%�ж�combine�ṹ���Ƿ�����ֶ�
%   combineDataStruct ���Ͻṹ��
%   baseField �����ֶΣ���rawData��
%   checkField Ҫ�����ֶ�
    checkRes = isfield(combineDataStruct,baseField);
    if ~checkField
        return;
    end
    st = getfield(combineDataStruct,baseField);
    checkRes = isfield(st,checkField);
end

