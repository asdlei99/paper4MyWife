function [T,Y] = makeRGS( fs,timeLast,varargin )
%   
    isShowFig = true;
    value = 5;
    savePath = '';
    isXcorr = true;
    while length(varargin)>=2
        prop =varargin{1};
        val=varargin{2};
        varargin=varargin(3:end);
        switch lower(prop)
            case 'isshowfig' %�Ƿ�����0
                isShowFig = val;
            case 'value'
                value = val;
            case 'savepath'
                savePath = val;
            case 'isxcorr'
                isXcorr = val;
        end
    end
    T = 0:1/fs:timeLast;
    Y = idinput(length(T), 'rgs');
    Y = Y + value;
    if isShowFig
        col = 2;
        if isXcorr
            c = xcorr(Y-value,'coeff');
            col = 3;
        end
        figure
        subplot(1,col,1);
        plot(T,Y);
        xlabel('ʱ��');
        ylabel('��ֵ');
        subplot(1,col,2);
        [fre,amp] = frequencySpectrum(Y,fs);
        plot(fre,amp);
        xlabel('Ƶ��(Hz)');
        ylabel('��ֵ');
        if isXcorr
            subplot(1,col,3);
            plot(c);
            title('��غ���');
        end
    end
    
    if length(savePath)>1
        fh = fopen(savePath,'w');
        for i=1:length(T)
            fprintf(fh,'%g,%g\r\n',T(i),Y(i));
        end
        fclose(fh);
    end
    sprintf('��ֵ:%g',mean(Y));
end

