function fh  = plotSweepFrequencyDistributionAmp( pressures,Fs,varargin )
%����ɨƵ���ݷ�ֵ�ֲ��������ֵ�ֲ���x��ʱ�䣬y���ֵ����Ӧ��������x��ʱ�䣬y���㣬z���ֵ
    pp = varargin;
    varargin = {};
    STFT.windowSectionPointNums = 512;
    STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
    STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
    chartType = 'plot3';%contourf,surf
    rang = 1:13;
    lineColor = [75,144,252]./255;
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'stft' %����������
                STFT = val;
            case 'charttype'
                chartType = val;
            case 'rang'
                rang = val;
            case 'linecolor'
                lineColor = val;
            otherwise
                varargin{length(varargin)+1} = prop;
                varargin{length(varargin)+1} = val;
        end
    end
    count = 1;

    for i = rang
        [sd.S,sd.F,sd.T,sd.P] = ...
                        spectrogram(...
                        detrend(pressures(:,i))...
                        ,STFT.windowSectionPointNums...
                        ,STFT.noverlap...
                        ,STFT.nfft...
                        ,Fs);%��ʱ����Ҷ�任
        mag=abs(sd.P);
        n = length(pressures(i));
        y(:,count) = zeros(1,length(sd.T));
        x(:,count) = sd.T;
        for j=1:length(sd.T)
            [tmp,index] = max(mag(:,j));
            y(j,count) = tmp;
        end
        count = count + 1;
    end

    if strcmpi(chartType,'plot3')
        count = 1;
        hold on;
        for i = rang
            zs = y(:,i);
            xs = x(:,i);
            ys = ones(length(xs),1) .* i;
            fh.plot3Handle(count) = plot3(xs,ys,zs,'color',lineColor,varargin{:});
            xs = xs';
            ys = ys';
            zs = zs';
            xsf = [xs,xs(end),xs(1),xs(1)];
            ysf = [ys,ys(end),ys(1),ys(1)];
            zsf = [zs,0,0,zs(1)];
            fh.plot3FillHandle(count) = fill3(xsf,ysf,zsf,lineColor,'edgealpha',0,'FaceAlpha',0.4);
            count = count + 1;
        end
        view(-35,41);
        box on;
        xlabel('ʱ��(s)','FontSize',paperFontSize());
        ylabel('���','FontSize',paperFontSize());
        zlabel('��ֵ','FontSize',paperFontSize());
    elseif strcmpi(chartType,'contourf')
        Z = y';
        [X,Y] = meshgrid(sd.T,rang);
        [C,fh.contourfHandle] = contourf(X,Y,Z,varargin{:});
        xlabel('ʱ��(s)','FontSize',paperFontSize());
        ylabel('���','FontSize',paperFontSize());
    else
        Z = y';
        [X,Y] = meshgrid(sd.T,rang);
        surf(X,Y,Z,varargin{:});
        xlabel('ʱ��(s)','FontSize',paperFontSize());
        ylabel('���','FontSize',paperFontSize());
        zlabel('��ֵ','FontSize',paperFontSize());
    end

    axis tight;
end

