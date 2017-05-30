function [res,n] = incrementDenoising( data,sectionLength,isSectionNum)
%����ȥ�룬���źŷ�Ϊn�Σ�ÿ�ν�������ٳ���n������������Ӻ������0���������ȥ���������
%   data ����
%   sectionLength �ֶκ����ݵĳ��ȣ��õ��Ľ�������Ǵ˳���
%   isSectionNum ���Ϊ1��˵������2��sectionLengthΪ�ֵĶ����������Ƿֶγ���
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

