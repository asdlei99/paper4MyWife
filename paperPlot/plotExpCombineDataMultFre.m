function [ curHancle,fillHandle ] = plotExpCombineDataMultFre( combineDataStruct,multFreVal,basefield,errorType)
%绘制联合数据的倍频
%    combineDataStruct 联合数据的结构体
%    basefield 基本地址:'rawData'等
%    multFreVal 倍频数 0.5:0.5:3之间
if nargin < 3
    basefield = 'rawData';
    errorType = 'std';
elseif nargin < 4
    errorType = 'std';
end

switch multFreVal
    case 0.5
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,'semiFreMag1');
    case 1.5
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,'semiFreMag2');
    case 2.5
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,'semiFreMag3');
    case 1
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,'multFreMag1');
    case 2
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,'multFreMag2');
    case 3
        [meanVal,stdVal,maxVal,minVal] = getExpCombineData(combineDataStruct,'multFreMag3');
    otherwise
        error('错误的multFreVal定义:%g',multFreVal);
end
meanPoints = 13;

x = 1:meanPoints;
y = meanVal(1:meanPoints);

if strcmp(errorType,'std')
    yUp = meanVal(1:meanPoints) + stdVal(1:meanPoints);
    yDown = meanVal(1:meanPoints) - stdVal(1:meanPoints);
else
    yUp = maxVal(1:meanPoints);
    yDown = minVal(1:meanPoints);
end

[curHancle,fillHandle] = plotWithError(x,y,yUp,yDown,'-r');



end

