function [x,y] = simulated_annealing(functionHandle,xRang,Tmax,Talpha,Tend,iteMax)
	%模拟退火通用算法
	%functionHandle 函数指针，fun(x)
	%xRang x的取值范围
	%Tmax 温度最大值
	%Talpha
	
	x = xRang(1) - xRang(0);
	%随机落点
	x = xRang(0) + (x * rand());
	%计算随机落点的结果
	y_old = functionHandle(x);
	y = y_old;
	T = Tmax;
	minJumpDistanceRate = 0.001;%最小跳跃距离的百分比，防止温度太低跳跃幅度太小
	count = 0;
	while(T > Tend)
		x_old = x;
		%随机产生临近点 ,根据x位置参数随机数，x若位于边界，随机数不会让x继续越过边界，而是折返
		if x == xRang(2)
			r = rand() * -1;%[-1,0]
		elif x == xRang(1)
			r = rand() * 1;%[0~1]
		else
			r = rand() * 2 - 1;%[-1,1]的随机数
		end
		
		%一个权重百分比
		w = T/Tmax;
		if w < minJumpDistanceRate
			w = minJumpDistanceRate;
		end
		%跳跃
		x = x + (r * (xRang(2)- xRang(1))/2 ) * w; %每次随机在xRang的范围取一个跳跃值，同时，随着温度下降，跳跃距离缩小
		%限定跳跃范围
		if x > xRang(2)
			x = xRang(2);
		end
		if x < xRang(1)
			x = xRang(1);
		end
		%计算方程
		y = functionHandle(x);
		if ~sa_judge(y-y_old,T)
			%不接受,应用前次计算值并退出迭代
			y = y_old;
			x = x_old;
			break;
		end
		%说明接受新值，降温
		T = T * Talpha;
		%记录迭代次数
		count = count + 1;
		if count > iteMax
			break;
		end
	end
end