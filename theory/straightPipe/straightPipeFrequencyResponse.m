%% 直管扫频
function pressure = straightPipeFrequencyResponse(varargin)

pp = varargin;
responseType = 'n';%响应类型:m M序列 n:理想冲击，r,高斯随机信号
massflowData = nan;
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 345;%声速（m/s）
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.L = 3.5+6;
param.l = 0.01;%(m)缓冲罐的连接管长
param.Dpipe = 0.098;%管道直径（m）
param.sectionL = 0:0.5:param.L;%linspace(0,param.L1,14);

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



pressure = straightPipePulsationCalc(param.massFlowE,param.fre,time...
    ,param.L ,param.sectionL ...
	,'D',param.Dpipe ...
    ,'a',param.acousticVelocity...
    ,'isDamping',param.isDamping...
    ,'friction',param.coeffFriction...
    ,'isOpening',param.isOpening...
    ,'meanFlowVelocity',param.meanFlowVelocity...
    ,'notMach',param.notMach...
    );

end

