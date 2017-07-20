function [fh,spectrogramData] = plotSTFT( wave,STFT,Fs,varargin )
%绘制一个波形的短时傅立叶变换
%   wave 波
%   SIFT 短时傅立叶变化的参数
%   Fs 采样率
% varargin可选属性：
% chartType：绘图类型，可选‘contour’（默认）或者‘plot3’
% contourfLineStyle:设置云图是否显示等高线,在chartType=‘contour’时可用
% isshowcolorbar或colorbar:云图时是否显示色棒
    pp = varargin;
    chartType = 'contour';
    contourfLineStyle = 'none';
    isShowColorbar = 1;
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'charttype'
                chartType = val;
            case 'contourflinestyle'%set(contourf,'LineStyle',contourfLineStyle);设置云图是否显示等高线
                contourfLineStyle = val;
            case 'colorbar'
                isShowColorbar = val;
            case 'isshowcolorbar'
                isShowColorbar = val;%云图时是否显示色棒
            otherwise
           		error('参数错误%s',prop);
        end
    end

    [spectrogramData.S,spectrogramData.F,spectrogramData.T,spectrogramData.P] = ...
                        spectrogram(...
                        detrend(wave)...
                        ,STFT.windowSectionPointNums...
                        ,STFT.noverlap...
                        ,STFT.nfft...
                        ,Fs);%短时傅里叶变换
    tl = size(spectrogramData.P,2);
    mag=abs(spectrogramData.P);
    n = size(spectrogramData.P,1);
    mag = mag ./ n;
    if strcmp(chartType,'contour')
        [X,Y] = meshgrid(spectrogramData.F,spectrogramData.T);
        [~,fh.contourfHandle] = contourf(X,Y,mag');
        set(fh.contourfHandle,'LineStyle',contourfLineStyle);
        %shading flat%保持光滑效果
        if isShowColorbar
            colorbar;
        end
    else
        for i=1:tl
            if 2 == i
                hold on;
            end
            fre = spectrogramData.F;
            Amp = mag(:,i);
            Y = spectrogramData.T(i);
            fh.plot3CurveHandle(i) = plotSpectrum3(fre,Amp,Y,'isFill',1,'color',[229,44,77]./255);
        end
        view(45,45);
    end
end

