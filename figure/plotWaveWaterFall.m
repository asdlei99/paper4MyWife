function h = plotWaveWaterFall( waves,fs,varargin)
%绘制一组波的频谱瀑布图
%   此处显示详细说明
    %LineStyle = 'none';
    pp = varargin;
    type = 'contourf';%绘制的类型'plot3','contourf'
	scale = 'amp';
    input_args = {};
	y = [];
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'type'
                type = val;
			case 'scale'
				scale = val;
			case 'y'
				y = val;
            otherwise%参数透传
           		input_args{length(input_args)+1} = prop;
                input_args{length(input_args)+1} = val;   
        end
    end
	if isempty(y)
		y = 1:size(waves,2);
	end
    %进行频谱分析
	[fre,amp] = frequencySpectrum(waves,fs,'scale',scale);
	if strcmpi(type,'contourf')
		h = plotSpectrumContourf(amp,fre,y,input_args{:});
	else 
		hold on;
		for i=1:length(amp)
			h(i) = plotSpectrum3(fre(:,i),amp(:,i),y(i),input_args{:});
		end
	end
end

