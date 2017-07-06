function rpm = getRpmFromDataStruct(dataStruct)
%从数据结构中获取转速信息
    rpm = dataStruct.input.baseFrequency*60/2; 
end

