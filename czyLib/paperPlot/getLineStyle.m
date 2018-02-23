function style = getLineStyle(index)
	line_style = {'-';'--';'-.';':'};
	len = length(line_style);
	if index > len
		if 0 == mod(index,len)
			index = 1;
		else
			index = index - (floor(index / len) * len) + 1;
		end
	end
	style = line_style{index};
end