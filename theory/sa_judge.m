function res = sa_judge(dE,t,isLittle)
%模拟退火的判断
	if nargin < 3
		isLittle = true;
	end	
	
	if isLittle 
		if dE < 0
			res = true;
		else
			res = mtropolis(dE,t);
		end
	else
		if dE > 0
			res = true;
		else
			res = mtropolis(dE,t);
		end
	end
end

function r = mtropolis(dE,t)
	d = exp(-(dE / t));
	if(d > rand)
		r = true;
	else
		r = false;
	nd
end