function [res,n] = incrementDenoising( data,sectionLength,isSectionNum)
%自增去噪，把信号分为n段，每段进行相加再除以n，由于噪声相加后会趋于0，因此它能去除大的噪声
%   data 数据
%   sectionLength 分段后数据的长度，得到的结果将会是此长度
%   isSectionNum 如果为1，说明参数2的sectionLength为分的段数，而不是分段长度
if nargin<3
    isSectionNum = 0;
end
if size(data,1)==1
    data = data';
end
if isSectionNum
    sectionLength = floor(length(data)/sectionLength);
end
sectionData = [];
sectionIndex = 1:sectionLength:length(data);
sumData = zeros(sectionLength,1);
for i=2:length(sectionIndex)
	sectionData(:,i-1) = data(sectionIndex(i-1):sectionIndex(i)-1);
	sumData = sumData + sectionData(:,i-1);
end
res = sumData./(length(sectionIndex)-1);
if isSectionNum
    n = sectionLength;
else
    n = length(sectionIndex)-1;
end

end

