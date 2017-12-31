function fh  = plotSweepFrequency( pressure,Fs,varargin )
%绘制扫频数据
    pp = varargin;
    varargin = {};
    STFT.windowSectionPointNums = 512;
    STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
    STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'stft' %误差带的类型
                STFT = val;
            case 'legendtitle'
                legendTitle = val;
            case 'figureheight'
                figureHeight = val;
            otherwise
                varargin{length(varargin)+1} = prop;
                varargin{length(varargin)+1} = val;
        end
    end
    [fh,sd] = plotSTFT(pressure, STFT, Fs...
                            , 'chartType', 'plot3'...
                            );
    x = zeros(1,length(sd.T));
    y = sd.T;
    z = zeros(1,length(sd.T));
    for j=1:length(y)
        [z(j),index] = max(mag(:,j));
        x(j) = sd.F(index);
    end
    %绘制最高线
    fh.maxAmpPlot = plot3(x,y,z,'.b');
    %绘制投影
    sx = ones(1,length(x));
    sx = sx .* sd.F(end);
    fh.shadowYZ = plot3(sx,y,z,'-b');
    
    axis tight;
end

