function [ clVal,index ] = closeValue( array,val )
%���������ҵ���ӽ���������ֵ
% 
[~,index]=min(abs(array-val));
clVal = array(index);
end

