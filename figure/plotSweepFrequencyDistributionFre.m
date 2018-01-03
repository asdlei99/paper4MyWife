function [fh,X,Y,Z]  = plotSweepFrequencyDistributionFre( pressures,Fs,varargin )
%����ɨƵ���ݵ�Ƶ�ʷֲ������Ƶ�ʷֲ���x��Ƶ�ʣ�y���ֵ����Ӧ��������x��Ƶ�ʣ�y���㣬z���ֵ
    pp = varargin;
    varargin = {};
    STFT.windowSectionPointNums = 512;
    STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
    STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
    chartType = 'plot3';
    rang = 1:13;
    lineColor = [222,104,54]./255;
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
        y(:,count) = zeros(1,length(sd.F));
        x(:,count) = sd.F;
        for j=1:length(sd.F)
            [tmp,index] = max(mag(j,:));
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
            Z(count,:) = zs;
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
        xlabel('Ƶ��(Hz)','FontSize',paperFontSize());
        ylabel('���','FontSize',paperFontSize());
        zlabel('��ֵ','FontSize',paperFontSize());
        [X,Y] = meshgrid(sd.F,rang);
    else
        Z = y';
        [X,Y] = meshgrid(sd.F,rang);
        fh.contourfHandle = contourf(X,Y,Z,varargin{:});
        xlabel('Ƶ��(Hz)','FontSize',paperFontSize());
        ylabel('���','FontSize',paperFontSize());
    end

    axis tight;
end

