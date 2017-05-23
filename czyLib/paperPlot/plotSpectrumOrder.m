function h = plotSpectrumOrder( wave,Fs,multFreArr,varargin )

%绘制一个信号的指定频率棒图，其他频率置零

%   wave 波形

%   Fs 采样率

%   multFreArr 计算倍频输入，如[10,30,45]就是获取10,30,45hz对应的幅值

%   'freerr' 频率的误差范围 默认0.9即查找100Hz，实际是查找100-0.9~100+0.9Hz

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