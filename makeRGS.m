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
            case 'isshowfig' %是否允许补0
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
        xlabel('时间');
        ylabel('幅值');
        subplot(1,col,2);
        [fre,amp] = frequencySpectrum(Y,fs);
        plot(fre,amp);
        xlabel('频率(Hz)');
        ylabel('幅值');
        if isXcorr
            subplot(1,col,3);
            plot(c);
            title('相关函数');
        end
    end
    
    if length(savePath)>1
        fh = fopen(savePath,'w');
        for i=1:length(T)
            fprintf(fh,'%g,%g\r\n',T(i),Y(i));
        end
        fclose(fh);
    end
    sprintf('均值:%g',mean(Y));
end

