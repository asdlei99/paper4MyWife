function [ YVal,XVal,index ] = closeLargeValue( X,Y,Xfind,allowDistance )
%从点序列中(x,y)找到x值对应y最大的值
% X 曲线的x值
% y 曲线的y值
% Xfind 曲线要找x值对应的y最大值的x值，例如x=[1.2,2.1,3.4,4.2,5.1,6.5] y = [1,2,3,4,5,6],xVal = 4,结果YVal = 4;
% allowDistance 允许的偏差就是说如果定义此数，会在(Xfind-allowDistance,Xfind+allowDistance)范围中找最大值
	if nargin < 4
		allowDistance = 0;
	end
	index = find(X > (Xfind-allowDistance) & X < (Xfind+allowDistance));
	YVal = Y(index);
	[YVal,indexOfMaxIndex] = max(YVal);
	index = index(indexOfMaxIndex);
	XVal = X(index);
end