function [T,Y] = makeInvM( fs,timeLast,varargin )
%   
    n = 8;
    p = 2^n -1;
    isShowFig = true;
    isXcorr = true;
    savePath = '';
    midVal = 0.5;
    pp = 1;
    while length(varargin)>=2
        prop =varargin{1};
        val=varargin{2};
        varargin=varargin(3:end);
        switch lower(prop)
            case 'isshowfig' %是否显示图
                isShowFig = val;
            case 'n' %阶次
                n = val;
            case 'p' %循环周期
                n = val;
            case 'savepath'
                savePath = val;
            case 'isxcorr'%是否显示相关图
                isXcorr = val;
            case 'midval'%生成序列的中值
                midVal = val;
            case 'pp'%生成序列的波动范围
                pp = val;
        end
    end
    T = 0:1/fs:timeLast;
    Y = zeros(1,length(T));
    n = 8; %  阶次
    p = 2^n -1; % 循环周期

    ms = idinput(p, 'prbs', [], [0 1]);
    s = 0;
    ims = zeros(2*p, 1);
    mstemp = [ms;ms];
    for i=1:2*p
        ims(i) = xor(mstemp(i),s);
        s = not(s);
    end
    Y(1:length(ims)) = ims;
    index = 1;
    while (length(Y) - index) > length(ims)
        Y(index:(length(ims)+index-1)) = ims;
        index = index + length(ims);
    end
    Y(index:end) = ims(1:(length(Y)-index+1));
    Y = Y .* pp;
    Y = (pp/2 + midVal)+Y;
    if isShowFig
        col = 2;
        if isXcorr
            c = xcorr(Y,'coeff');
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
    
    fprintf('均值:%g',mean(Y));
    sy = trapz(T,Y);
    syd = sy / T(end);
    fprintf('累积值:%g,单位时间累加值:%g',sy,syd);
end

