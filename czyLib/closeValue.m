function [ clVal,index ] = closeValue( array,val )
%���������ҵ���ӽ���������ֵ
% 
[tmp,index]=min(abs(array-val));
clVal = array(index);
end

