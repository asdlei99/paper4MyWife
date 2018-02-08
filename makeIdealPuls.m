function [T,Y] = makeIdealPuls( fs,timeLast,varargin )
%   
    midVal = 0.5;
    pp = 1;
    isShowFig = true;
    isXcorr = true;
    savePath = '';
    while length(varargin)>=2
        prop =varargin{1};
        val=varargin{2};
        varargin=varargin(3:end);
        switch lower(prop)
            case 'isshowfig' %�Ƿ���ʾͼ
                isShowFig = val;
            case 'savepath'
                savePath = val;
            case 'isxcorr'%�Ƿ���ʾ���ͼ
                isXcorr = val;
            case 'midval'%�������е���ֵ
                midVal = val;
            case 'pp'%�������еĲ�����Χ
                pp = val;
        end
    end
    T = 0:1/fs:timeLast;
    Y = zeros(1,length(T));
    Y(1) = (pp/2 + midVal);
    if isShowFig
        col = 2;
        if isXcorr
            c = xcorr(Y,'coeff');
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
    
    fprintf('��ֵ:%g',mean(Y));
    sy = trapz(T,Y);
    syd = sy / T(end);
    fprintf('�ۻ�ֵ:%g,��λʱ���ۼ�ֵ:%g',sy,syd);
end

