function [Fre,Amp,Ph,Fe] = frequencySpectrum( wave,Fs,varargin)
    %傅里叶变换
    %   data:波形数据
    %   Fs:采样率
    %   varargin:
    %		isaddzero->是否补零，默认为1，否则会按照data的长度进行fft
    %		scale->幅值的尺度，'amp'为幅值谱，'ampDB'为分贝显示的幅值谱,'mag'为幅度谱就是fft之后直接取模,'magDB'为'mag'对应的分贝
    %		isdetrend->是否进行去均值处理，默认为1
    %   得到的是[fre:频率,Amp:幅值,Ph:相位,Fe:原始的复数]

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
    %傅里叶变换
    %   data:波形数据
    %   Fs:采样率
    %   varargin:
    %		isaddzero->是否补零，默认为1，否则会按照data的长度进行fft
    %		scale->幅值的尺度，'amp'为幅值谱，'ampDB'为分贝显示的幅值谱,'mag'为幅度谱就是fft之后直接取模,'magDB'为'mag'对应的分贝
    %		isdetrend->是否进行去均值处理，默认为1
    %   得到的是[fre:频率,Amp:幅值,Ph:相位,Fe:原始的复数]
    isAddZero = 1;
    scale = 'amp';
    isDetrend = 1;
    while length(varargin)>=2
        prop =varargin{1};
        val=varargin{2};
        varargin=varargin(3:end);
        switch lower(prop)
            case 'isaddzero' %是否允许补0
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
    
    Fre=(0:N-1)*Fs/N;%频率
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