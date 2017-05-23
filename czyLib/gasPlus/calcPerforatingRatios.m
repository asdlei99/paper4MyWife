function data = calcPerforatingRatios(n,dp,Din,lp)
% 计算开孔率
% n 孔数
% dp 孔管每一个孔孔径
% Din 孔管管径
% lp 孔管开孔长度
data = (n.*(dp).^2)./(4.*Din.*lp);%开孔率
end