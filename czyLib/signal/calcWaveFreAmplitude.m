function [ ampValue,ampIndex ] = calcWaveFreAmplitude( wave,Fs,multFreArr,varargin)
%����һ�����εı�Ƶ
%   wave ����
%   Fs ������
%   multFreArr ���㱶Ƶ���룬��[10,30,45]���ǻ�ȡ10,30,45hz��Ӧ�ķ�ֵ
%   'freerr' Ƶ�ʵ���Χ Ĭ��0.9������100Hz��ʵ���ǲ���100-0.9~100+0.9Hz
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
%����һ�����εı�Ƶ
%   data ����
%   Fs ������
%   multFreArr ���㱶Ƶ���룬��[10,30,45]���ǻ�ȡ10,30,45hz��Ӧ�ķ�ֵ
%   'freerr' Ƶ�ʵ���Χ Ĭ��0.9������100Hz��ʵ���ǲ���100-0.9~100+0.9Hz
freErr = 0.9;
pp = varargin;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'freerr' %Ƶ�ʵ���Χ
            if ~isempty(val)
                freErr = val;
            end
        otherwise
       		error('��������%s',prop);
    end
end
ampIndex = zeros(length(multFreArr),1);
ampValue = zeros(length(multFreArr),1);
[Fre,Amp,~,~] = frequencySpectrum(data,Fs);
count = 1;
for f = multFreArr
    index = find(Fre>(f-freErr) & Fre<(f+freErr));
    if(isempty(index))
    	error('�޷��ҵ���ӦƵ��:%g',f);
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

