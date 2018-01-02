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
            otherwise
                varargin{length(varargin)+1} = prop;
                varargin{length(varargin)+1} = val;
        end
    end
    [fh,sd,mag] = plotSTFT(pressure, STFT, Fs...
                            , 'chartType', 'plot3'...
                            );
    hold on;
    
    x = zeros(1,length(sd.T));
    y = sd.T;
    z = zeros(1,length(sd.T));
    for j=1:length(y)
        [z(j),index] = max(mag(:,j));
        x(j) = sd.F(index);
    end
    %绘制最高线
    fh.maxAmpPlot = plot3(x,y,z,'.b',varargin{:});
    %绘制投影YZ
    sx = ones(1,length(x));
    sx = sx .* sd.F(end);
    colorYZ = [75,144,252]./255;
    fh.shadowYZ = plot3(sx,y,z,'-','color',colorYZ,varargin{:});
    %绘制投影填充
    xf = [sx,sx(end),sx(1),sx(1)];
    yf = [y,y(end),y(1),y(1)];
    zf = [z,0,0,z(1)];
    fh.shadowFillYZ = fill3(xf,yf,zf,colorYZ,'edgealpha',0,'FaceAlpha',0.4);
    %绘制投影XZ
    z = zeros(1,length(sd.F));
    x = sd.F;
    y = zeros(1,length(sd.F));
    for j=1:length(x)
        [z(j),index] = max(mag(j,:));
        y(j) = sd.T(index);
    end
    sy = ones(1,length(y));
    sy = sy .* sd.T(end);
    x = x';
    colorXZ = [255,147,85]./255;
    fh.shadowXZ = plot3(x,sy,z,'-','color',colorXZ,varargin{:});
    xf = [x,x(end),x(1),x(1)];
    yf = [sy,sy(end),sy(1),sy(1)];
    zf = [z,0,0,z(1)];
    fh.shadowFillXZ = fill3(xf,yf,zf,colorXZ,'edgealpha',0,'FaceAlpha',0.4);
    axis tight;
end

