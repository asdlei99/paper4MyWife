function [t,y] = makePulse( fs,timeLast,varargin )
%
    isShowFig = true;
    offset = 1;
    while length(varargin)>=2
        prop =varargin{1};
        val=varargin{2};
        varargin=varargin(3:end);
        switch lower(prop)
            case 'isshowfig' % «∑Ò‘ –Ì≤π0
                isShowFig = val;
            case 'offset'
                offset = val;
        end
    end
    num = [0,0,4];
    den = [1,-1,4];
    T = 0:1/fs:timeLast;
    
%     num = [0,0,1];
%     den = [0.1,0.5,1];
    
%     num = [0,0,25];
%     den = [1,4,25];
    
%     num = [0,0,10];
%     den = [0.1,1,10];
    s = tf(num,den);
    [mag,t,tmp] = impulse(s,0:1/50:1);
    clear tmp;
    y = zeros(1,length(T));
    
    indexStart = 0/(1/fs)+1;
    y(indexStart:(indexStart+length(mag)-1)) = mag;
    
    indexStart = 0.5/(1/fs)+1;
    y(indexStart:(indexStart+length(mag)-1)) = mag;
    
    if isShowFig
        figure
        subplot(1,2,1);
        plot(T,y);
        subplot(1,2,2);
        [fre,amp] = frequencySpectrum(y,fs);
        plot(fre,amp);
    end
    
    
    
end

