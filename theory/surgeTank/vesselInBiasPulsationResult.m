function [resCell,param] = vesselInBiasPulsationResult( varargin )
%缓冲罐入口错位，出口顺接的气流脉动计算
% Dbias 偏置管内插入缓冲罐的管径，如果偏置管没有内插如缓冲罐，Dbias为0
%   Detailed explanation goes here
%   inlet   |  L1
%        l  |     Lv    
%   Dbias___|_______________
%       |                   |  Dpipe
%       |lv1  V          lv2|———— L2  
%       |___________________| outlet
%           Dv              l     
%容器的传递矩阵
massflowData = nan;
%% 初始参数
%
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 345;%声速（m/s）
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
param.LBias = 0.168+0.15;
param.Dbias = 0;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv = 1.1;
param.l = 0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%管道直径（m）
param.X = [param.sectionL1, param.sectionL1(end) + param.l + param.Lv - param.Dbias + param.sectionL2];
param.notMach = 0;
param.allowDeviation = 0.5;
param.multFreTimes = 3;
param.semiFreTimes = 3;

pp = varargin;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'massflowdata'
            massflowData = val;
        case 'param'
            param = val;
    end
end

if isnan(massflowData)
    [massFlowRaw,time,~,opt.meanFlowVelocity] = massFlowMaker(0.25,0.098,param.rpm...
        ,0.14,1.075,param.outDensity,'rcv',0.15,'k',1.4,'pr',0.15,'fs',param.Fs,'oneSecond',6);
    [freRaw,AmpRaw,PhRaw,massFlowERaw] = frequencySpectrum(detrend(massFlowRaw,'constant'),param.Fs);
    freRaw = [7,14,21,28,14*3];
    massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
    massFlowE = massFlowERaw;
    param.fre = freRaw;
    param.massFlowE = massFlowE;
else
    time = makeTime(param.Fs,1024);
    param.fre = massflowData(1,:);
    param.massFlowE = massflowData(2,:);
end
param.mach = param.meanFlowVelocity / param.acousticVelocity;

[pressure1,pressure2] = ...
        vesselBiasStraightPulsationCalc(param.massFlowE,param.fre,time,...
            param.L1,param.L2,...
            param.Lv,param.l,param.Dpipe,param.Dv,...
            param.LBias,param.Dbias,...
            param.sectionL1,param.sectionL2,...
            'a',param.acousticVelocity,'isDamping',param.isDamping,'friction',param.coeffFriction,...
            'meanFlowVelocity',param.meanFlowVelocity,'isUseStaightPipe',1,...
            'm',param.mach,'notMach',param.notMach...
            ,'isOpening',param.isOpening...
            );%,'coeffDamping',opt.coeffDamping
pressure = [pressure1,pressure2];
param.baseFrequency = param.rpm / 60 * 2;
param.beforeAfterMeaPoint = [length(param.sectionL1),length(param.sectionL1)+1];
resCell = fun_dataProcessing(pressure...
                            ,'fs',param.Fs...
                            ,'basefrequency',param.baseFrequency...
                            ,'allowdeviation',param.allowDeviation...
                            ,'multfretimes',param.multFreTimes...
                            ,'semifretimes',param.semiFreTimes...
                            ,'beforeAfterMeaPoint',param.beforeAfterMeaPoint...
                            ,'calcpeakpeakvaluesection',nan...
                            );

end

