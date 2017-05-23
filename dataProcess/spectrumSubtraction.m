function filteringData= spectrumSubtraction( noiseData,originData,str_way)
%�׼����ļ��ɺ���
% by:czy 20151110
% �ο���http://blog.csdn.net/xiahouzuoxin/article/details/41124245
% noiseData ��������
% originData ԭʼ����
% str_way Ϊ���׵ķ�����'mean'Ϊ��ֵ��������ʧ�浫��������Ƶ�ʣ�'direct'Ϊ�Ƚϱ�����ֱ�Ӽ���
if nargin<=2
    str_way = 'mean';
end
dcNData = fun_delete_DC(noiseData);
N=length(originData);
%n=2^nextpow2(n);
noise_fft = fft(dcNData);%���������Ƶ��
[dcOData,meanOriginData ]= fun_delete_DC(originData);
origin_fft = fft(dcOData);%����źŵ�Ƶ��
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
%��ԭ����
fft_filtering = mag_filtering .* exp(1i.*phase_data);
Y = ifft(fft_filtering);
filteringData=real(Y);
filteringData = filteringData + meanOriginData;
%���ڽ��и���Ҷ�����仯����й¶���Ա�Ե������������������ѡ50
% correctLength = 50;
% diffx(1:correctLength) = originPressure(1:correctLength);
% diffx(end - correctLength:end) = originPressure(end - correctLength:end);


end

