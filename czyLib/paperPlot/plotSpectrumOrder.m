function h = plotSpectrumOrder( wave,Fs,multFreArr,varargin )

%����һ���źŵ�ָ��Ƶ�ʰ�ͼ������Ƶ������

%   wave ����

%   Fs ������

%   multFreArr ���㱶Ƶ���룬��[10,30,45]���ǻ�ȡ10,30,45hz��Ӧ�ķ�ֵ

%   'freerr' Ƶ�ʵ���Χ Ĭ��0.9������100Hz��ʵ���ǲ���100-0.9~100+0.9Hz

%   \see calcWaveFreAmplitude

[ ampValue,~ ] = calcWaveFreAmplitude( wave,Fs,multFreArr,varargin);

if (size(wave,1)>1 && size(wave,2) > 1)

    h = plotSpectrumOrder_nDim(ampValue,multFreArr);

else

    h = plotSpectrumOrder_1Dim(ampValue,multFreArr);

end




end







function h = plotSpectrumOrder_1Dim( ampValue,multFreArr,varargin)

    h = bar(multFreArr,ampValue);

end




function h = plotSpectrumOrder_nDim( ampValue,multFreArr,varargin)

    h = bar(multFreArr,ampValue');

end