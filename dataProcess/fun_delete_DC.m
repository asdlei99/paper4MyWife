function [res,meanData] = fun_delete_DC( data )
%信号去直流
%   Detailed explanation goes here
meanData = mean(data);
res = data - meanData;
end

