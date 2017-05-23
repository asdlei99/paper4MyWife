function mark = getMarkStyle(index)
	str = 'os<+>xvph^*d';
	len = length(str);
	if index > len
		if 0 == mod(index,len)
			index = 1;
		else
			index = index - (floor(index / len) * len) + 1;
		end
	end
	mark = str(index);
end