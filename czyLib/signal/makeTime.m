function time = makeTime( Fs,points)
%根据采样率和采样点生成时间
    time = 0:points-1;
    time = time * (1/Fs);
end