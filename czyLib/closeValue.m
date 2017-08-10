function [ clVal,index ] = closeValue( array,val )
%从数组中找到最接近的索引和值
% 
[~,index]=min(abs(array-val));
clVal = array(index);
end

