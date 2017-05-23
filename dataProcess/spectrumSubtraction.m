function filteringData= spectrumSubtraction( noiseData,originData,str_way)
%谱减法的集成函数
% by:czy 20151110
% 参考：http://blog.csdn.net/xiahouzuoxin/article/details/41124245
% noiseData 噪声数据
% originData 原始数据
% str_way 为减谱的方法，'mean'为均值减法，不失真但会有音乐频率，'direct'为比较暴力的直接减谱
if nargin<=2
    str_way = 'mean';
end
dcNData = fun_delete_DC(noiseData);
N=length(originData);
%n=2^nextpow2(n);
noise_fft = fft(dcNData);%获得噪声的频谱
[dcOData,meanOriginData ]= fun_delete_DC(originData);
origin_fft = fft(dcOData);%获得信号的频谱
mag_data = abs(origin_fft);
phase_data = angle(origin_fft);

if strcmp(str_way,'mean')
    E_noise = sum(abs(noise_fft)) / N;
elseif strcmp(str_way,'direct')
    E_noise = abs(noise_fft);
else
    E_noise = sum(abs(noise_fft)) / N;
end

mag_filtering = mag_data - E_noise;
mag_filtering(mag_filtering<0) = 0;
%复原数据
fft_filtering = mag_filtering .* exp(1i.*phase_data);
Y = ifft(fft_filtering);
filteringData=real(Y);
filteringData = filteringData + meanOriginData;
%由于进行傅里叶正负变化后有泄露，对边缘进行修正，修正长度选50
% correctLength = 50;
% diffx(1:correctLength) = originPressure(1:correctLength);
% diffx(end - correctLength:end) = originPressure(end - correctLength:end);


end

