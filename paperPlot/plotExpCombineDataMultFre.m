function [ output_args ] = plotExpCombineDataMultFre( combineDataStruct,basefield,multFreVal)
%�����������ݵı�Ƶ
%   
switch multFreVal
    case 0.5
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,basefield,'semiFreMag1');
    case 1.5
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,basefield,'semiFreMag2');
    case 2.5
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,basefield,'semiFreMag3');
    case 1
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,basefield,'multFreMag1');
    case 2
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,basefield,'multFreMag2');
    case 3
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,basefield,'multFreMag3');
    otherwise
        error('�����multFreVal����:%g',multFreVal);
end
x = 1:13;
plot(x,meanVal(1:13));


end

