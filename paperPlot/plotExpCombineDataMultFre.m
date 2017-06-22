function [ curHancle,fillHandle ] = plotExpCombineDataMultFre( combineDataStruct,multFreVal,basefield,errorType)
%�����������ݵı�Ƶ
%    combineDataStruct �������ݵĽṹ��
%    basefield ������ַ:'rawData'��
%    multFreVal ��Ƶ�� 0.5:0.5:3֮��
%    errorType : ci��default��,sd,minmax
if nargin < 3
    basefield = 'rawData';
    errorType = 'ci';
elseif nargin < 4
    errorType = 'ci';
end
subFieldName = 'multFreMag1';
switch multFreVal
    case 0.5
        subFieldName = 'semiFreMag1';
    case 1.5
        subFieldName = 'semiFreMag2';
    case 2.5
        subFieldName = 'semiFreMag3';
    case 1
        subFieldName = 'multFreMag1';
    case 2
        subFieldName = 'multFreMag2';
    case 3
        subFieldName = 'multFreMag3';
    otherwise
        error('�����multFreVal����:%g',multFreVal);
end
[meanVal,stdVal,maxVal,minVal,ci] = getExpCombineData(combineDataStruct,subFieldName);
meanPoints = 13;

x = 1:meanPoints;
y = meanVal(1:meanPoints);

if strcmp(errorType,'sd')
    yUp = meanVal(1:meanPoints) + stdVal(1:meanPoints);
    yDown = meanVal(1:meanPoints) - stdVal(1:meanPoints);
elseif strcmp(errorType,'ci')
    yUp = ci(2,1:meanPoints);
    yDown = ci(1,1:meanPoints);
else
    yUp = maxVal(1:meanPoints);
    yDown = minVal(1:meanPoints);
end

[curHancle,fillHandle] = plotWithError(x,y,yUp,yDown,'-r');

end

