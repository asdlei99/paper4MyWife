function [ ampValue,ampIndex ] = calcWaveFreAmplitude( wave,Fs,multFreArr,varargin)
%计算一个波形的倍频
%   wave 波形
%   Fs 采样率
%   multFreArr 计算倍频输入，如[10,30,45]就是获取10,30,45hz对应的幅值
%   'freerr' 频率的误差范围 默认0.9即查找100Hz，实际是查找100-0.9~100+0.9Hz
	if (size(wave,1)>1 && size(wave,2) > 1)
    	for i=1:size(wave,2)
    		[a,b] = calcWaveFreAmplitude_1dim( wave(:,i),Fs,multFreArr,varargin);
    		ampValue(:,i) = a;
    		ampIndex(:,i) = b;
    	end
    else
    	[ampValue,ampIndex] = calcWaveFreAmplitude_1dim( wave,Fs,multFreArr,varargin);
    end
end


function [ ampValue,ampIndex ] = calcWaveFreAmplitude_1dim( data,Fs,multFreArr,varargin)
%计算一个波形的倍频
%   data 波形
%   Fs 采样率
%   multFreArr 计算倍频输入，如[10,30,45]就是获取10,30,45hz对应的幅值
%   'freerr' 频率的误差范围 默认0.9即查找100Hz，实际是查找100-0.9~100+0.9Hz
freErr = 0.9;
pp = varargin;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'freerr' %频率的误差范围
            if ~isempty(val)
                freErr = val;
            end
        otherwise
       		error('参数错误%s',prop);
    end
end
ampIndex = zeros(length(multFreArr),1);
ampValue = zeros(length(multFreArr),1);
[Fre,Amp,~,~] = frequencySpectrum(data,Fs);
count = 1;
for f = multFreArr
    index = find(Fre>(f-freErr) & Fre<(f+freErr));
    if(isempty(index))
    	error('无法找到对应频率:%g',f);
    end
    [~,maxIndexIndex] = max(Amp(index));
    if(isempty(maxIndexIndex))
    	ampIndex(count,1) = index(1);
    else
    	ampIndex(count,1) = index(maxIndexIndex);
    end
    ampValue(count,1) = Amp(ampIndex(count));
    count = count + 1;
end

end

