function [res,meanData] = fun_delete_DC( data )
%�ź�ȥֱ��
%   Detailed explanation goes here
meanData = mean(data);
res = data - meanData;
end

