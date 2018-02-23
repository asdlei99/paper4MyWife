%% 孔管扫频扫频
function pressure = doubleVesselFrequencyResponse(varargin)
pp = varargin;
responseType = 'n';%响应类型:m M序列 n:理想冲击，r,高斯随机信号
%   massFlowE1 经过fft后的质量流量，直接对质量流量进行去直流fft
%  长度 L1     l    Lv1   l   L2  l    Lv2   l     L3
%              __________         __________
%             |          |       |          |
%  -----------|          |-------|          |-------------
%             |__________|       |__________|  
%  直径 Dpipe       Dv1    Dpipe       Dv2          Dpipe
%   
%% 数据路径
param.acousticVelocity = 345;%声速
param.isDamping = 1;%是否计算阻尼
param.coeffFriction = 0.003;%管道摩察系数
param.notMach = 0;

param.L1 = 3.5;%L1(m)
param.L2 = 1.5;%1.5;%双罐串联两罐间距
param.L3 = 4;%4%双罐串联罐二出口管长
param.Dpipe = 0.098;%管道直径（m）%应该是0.106
param.l = 0.01;
param.DV1 = 0.372;%缓冲罐的直径（m）
param.LV1 = 1.1;%缓冲罐总长 （1.1m）
param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
param.LV2 = 1.1;%variant_r(i).*param.DV2;%缓冲罐总长 （1.1m）
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 300;
param.outDensity = 1.5608;
param.sectionL1 = 0:0.5:param.L1;
param.sectionL2 = 0:0.5:param.L2;
param.sectionL3 = 0:0.5:param.L3;
param.meanFlowVelocity = 16;
param.mach = param.meanFlowVelocity / param.acousticVelocity;


while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'responsetype' %扫频类型:m 逆M序列 n:理想冲击，r,高斯随机信号
            responseType = val;
        case 'param'
            param = val;
        case 'fs' %最大的扫频频率，默认200Hz
            fs = val;
        otherwise
            error('错误属性%s',prop);
	end
end
%% 初始参数
%


if strcmpi(responseType,'m')
    [time,Y] = makeInvM(fs,6 ...
                    ,'isshowfig',false...
                    ,'midval',0.1 ...
                    ,'pp',0.1*0.1 ...
                    );
    [param.fre,AmpRaw,PhRaw,param.massFlowE] = frequencySpectrum(detrend(Y,'constant'),fs);
elseif strcmpi(responseType,'n')
    %理想脉冲
    [time,Y] = makeIdealPuls(fs,6,'isshowfig',false...
                    ,'midval',10 ...
                    ,'pp',10*0.1 ...
                    );
    [param.fre,AmpRaw,PhRaw,param.massFlowE] = frequencySpectrum(detrend(Y,'constant'),fs);
end


[pressure1,pressure2,pressure3] = ...
			doubleVesselPulsationCalc(param.massFlowE,param.fre,time,...
				param.L1,param.L2,param.L3,...
				param.LV1,param.LV2,param.l,param.Dpipe,param.DV1,param.DV2,...
				param.sectionL1,param.sectionL2,param.sectionL3,...
				'a',param.acousticVelocity,'isDamping',param.isDamping,'friction',0.045,...
				'meanFlowVelocity',param.meanFlowVelocity,'isUseStaightPipe',1,...
				'm',param.mach,'notMach',param.notMach...
				,'isOpening',param.isOpening...
				);%,'coeffDamping',opt.coeffDamping
pressure = [pressure1,pressure2,pressure3];

end

