fs = 1024;
signal = [100,zeros(1,1023)];
[f,m] = frequencySpectrum(signal,fs);
plotSpectrum(f,m)