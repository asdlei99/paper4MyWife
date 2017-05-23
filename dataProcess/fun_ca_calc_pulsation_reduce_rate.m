function [rate,pdr] = fun_ca_calc_pulsation_reduce_rate( y,seprateIndex_before,seprateIndex_after )
%计算脉动抑制率，
%   rate 这里的脉动抑制率是指，在seprateIndex左边的数据的最大值做为分母，seprateIndex的右边的最大值作为分子，两者之比
%   pdr 计算脉动衰减率西南交大博士论文液压系统脉动衰减器的特性分析，35页
%  y 数据
%  seprateIndex 分界点
temp = y(1:seprateIndex_before);
a1 = max(temp);
temp = y(seprateIndex_after:end);
a2 = max(temp);

rate = (a1-a2)/a1;
pdr = 20 .* log10(a1./a2);
end

