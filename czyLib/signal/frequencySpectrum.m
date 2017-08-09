function [Fre,Amp,Ph,Fe] = frequencySpectrum( wave,Fs,varargin)
    %����Ҷ�任
    %   data:��������
    %   Fs:������
    %   varargin:
    %		isaddzero->�Ƿ��㣬Ĭ��Ϊ1������ᰴ��data�ĳ��Ƚ���fft
    %		scale->��ֵ�ĳ߶ȣ�'amp'Ϊ��ֵ�ף�'ampDB'Ϊ�ֱ���ʾ�ķ�ֵ��,'mag'Ϊ�����׾���fft֮��ֱ��ȡģ,'magDB'Ϊ'mag'��Ӧ�ķֱ�
    %		isdetrend->�Ƿ����ȥ��ֵ����Ĭ��Ϊ1
    %   �õ�����[fre:Ƶ��,Amp:��ֵ,Ph:��λ,Fe:ԭʼ�ĸ���]

    if (size(wave,1)>1 && size(wave,2) > 1)
    	for i=1:size(wave,2)
    		[a,b,c,d] = frequencySpectrum_1dim( wave(:,i),Fs,varargin{:});
    		Fre(:,i) = a;
    		Amp(:,i) = b;
    		Ph(:,i) = c;
    		Fe(:,i) = d;
    	end
    else
    	[Fre,Amp,Ph,Fe] = frequencySpectrum_1dim( wave,Fs,varargin{:});
    end
end

function [Fre,Amp,Ph,Fe] = frequencySpectrum_1dim( data,Fs,varargin)
    %����Ҷ�任
    %   data:��������
    %   Fs:������
    %   varargin:
    %		isaddzero->�Ƿ��㣬Ĭ��Ϊ1������ᰴ��data�ĳ��Ƚ���fft
    %		scale->��ֵ�ĳ߶ȣ�'amp'Ϊ��ֵ�ף�'ampDB'Ϊ�ֱ���ʾ�ķ�ֵ��,'mag'Ϊ�����׾���fft֮��ֱ��ȡģ,'magDB'Ϊ'mag'��Ӧ�ķֱ�
    %		isdetrend->�Ƿ����ȥ��ֵ����Ĭ��Ϊ1
    %   �õ�����[fre:Ƶ��,Amp:��ֵ,Ph:��λ,Fe:ԭʼ�ĸ���]
    isAddZero = 1;
    scale = 'amp';
    isDetrend = 1;
    while length(varargin)>=2
        prop =varargin{1};
        val=varargin{2};
        varargin=varargin(3:end);
        switch lower(prop)
            case 'isaddzero' %�Ƿ�����0
                isAddZero = val;
            case 'scale'
                scale = val;
            case 'isdetrend'
                isDetrend = val;
        end
    end

    n=length(data);
    if isAddZero
        N=2^nextpow2(n);
    else
        N = n;
    end
    
    if isDetrend
        Y = fft(detrend(data,'constant'),N);
    else
        Y = fft(data,N);
    end
    
    Fre=(0:N-1)*Fs/N;%Ƶ��
    Fre = Fre(1:N/2);
    Amp = dealMag(Y,N,n,scale);
    ang=angle(Y(1:N/2));
    Ph=ang*180/pi;
    Fre = Fre';
    Fe = Amp.*exp(1i.*ang);
end

function amp = dealMag(fftData,fftSize,dataSize,scale)
	switch lower(scale)
		case 'amp'
			amp=abs(fftData);
			amp(1)=amp(1)/dataSize;
			amp(2:fftSize/2-1)=amp(2:fftSize/2-1)/(dataSize/2);
			amp(fftSize/2)=amp(fftSize/2)/dataSize;
			amp=amp(1:fftSize/2);
		case 'ampdb'
			amp=abs(fftData);
			amp(1)=amp(1)/fftSize;
			amp(2:fftSize/2-1)=amp(2:fftSize/2-1)/(fftSize/2);
			amp(fftSize/2)=amp(fftSize/2)/fftSize;
			amp=amp(1:fftSize/2);
			amp = 20*log10(amp);
		case 'mag'
			amp=abs(fftData(1:fftSize/2));
		case 'magdb'
			amp=abs(fftData(1:fftSize/2));
			amp = 20*log(amp);
        case 'nordb'
            amp=abs(fftData(1:fftSize/2));
			amp = 20*log(amp);
            maxamp = max(amp);
            amp = amp - maxamp;
		otherwise
			error('unknow scale type');
	end
end