function h = plotWaveWaterFall( waves,fs,varargin)
%����һ�鲨��Ƶ���ٲ�ͼ
%   �˴���ʾ��ϸ˵��
    %LineStyle = 'none';
    pp = varargin;
    type = 'contourf';%���Ƶ�����'plot3','contourf'
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
            otherwise%����͸��
           		input_args{length(input_args)+1} = prop;
                input_args{length(input_args)+1} = val;   
        end
    end
	if isempty(y)
		y = 1:size(waves,2);
	end
    %����Ƶ�׷���
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

