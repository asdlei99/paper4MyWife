function [fh,spectrogramData] = plotSTFT( wave,STFT,Fs,varargin )
%����һ�����εĶ�ʱ����Ҷ�任
%   wave ��
%   SIFT ��ʱ����Ҷ�仯�Ĳ���
%   Fs ������
% varargin��ѡ���ԣ�
% chartType����ͼ���ͣ���ѡ��contour����Ĭ�ϣ����ߡ�plot3��
% contourfLineStyle:������ͼ�Ƿ���ʾ�ȸ���,��chartType=��contour��ʱ����
% isshowcolorbar��colorbar:��ͼʱ�Ƿ���ʾɫ��
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
            case 'contourflinestyle'%set(contourf,'LineStyle',contourfLineStyle);������ͼ�Ƿ���ʾ�ȸ���
                contourfLineStyle = val;
            case 'colorbar'
                isShowColorbar = val;
            case 'isshowcolorbar'
                isShowColorbar = val;%��ͼʱ�Ƿ���ʾɫ��
            otherwise
           		error('��������%s',prop);
        end
    end

    [spectrogramData.S,spectrogramData.F,spectrogramData.T,spectrogramData.P] = ...
                        spectrogram(...
                        detrend(wave)...
                        ,STFT.windowSectionPointNums...
                        ,STFT.noverlap...
                        ,STFT.nfft...
                        ,Fs);%��ʱ����Ҷ�任
    tl = size(spectrogramData.P,2);
    mag=abs(spectrogramData.P);
    n = size(spectrogramData.P,1);
    mag = mag ./ n;
    if strcmp(chartType,'contour')
        [X,Y] = meshgrid(spectrogramData.F,spectrogramData.T);
        [~,fh.contourfHandle] = contourf(X,Y,mag');
        set(fh.contourfHandle,'LineStyle',contourfLineStyle);
        %shading flat%���ֹ⻬Ч��
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

