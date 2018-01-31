%% 迭代相同长径比下，不同体积不同偏置距离的影响
function [X,Y,Z] = oneVesselChangeVAndBiasLengthFixAR(V,lv1,index,varargin)
vType = 'straightInBiasFrontOut';

%biasInBiasOut：侧进侧出 (侧前进侧后出)
%   Detailed explanation goes here
%           |  L2
%        l  |     Lv    outlet
%   bias2___|_______________
%       |                   |
%       |lv2  V          lv1|  Dv
%       |___________________|
%                    l  |   bias1  
%                       |
%              inlet:   | L1 Dpipe 

%EqualBiasInOut:侧中进侧中出
%   Detailed explanation goes here
%                 |  L1
%              l  |      inlet
%       _________ |__________
%       |                   |
%       |     Lv            |  Dv
%       |___________________|
%              l  |    
%                 |
%        outlet:  | L2 Dpipe (Dbias为插入管的管道直径，取0即可)

% BiasFontInStraightOut 侧前进直出
% Dbias 偏置管内插入缓冲罐的管径，如果偏置管没有内插如缓冲罐，Dbias为0
%   Detailed explanation goes here
%   inlet   |  L1
%        l  |     Lv    
%   bias2___|_______________
%       |                   |  Dpipe
%       |lv1  V          lv2|———— L2  
%       |___________________| outlet
%           Dv              l  

% straightInBiasBackOut:直进侧后出
% Dbias 偏置管内插入缓冲罐的管径，如果偏置管没有内插如缓冲罐，Dbias为0
%   Detailed explanation goes here
%           |  L2
%        l  |     Lv    outlet
%   bias2___|_______________
%       |                   |  Dpipe
%       |lv2  V          lv1|———— L1  
%       |___________________| inlet
%           Dv              l      
%          

% straightInBiasFrontOut:直进侧前出
%缓冲罐入口顺接，出口前错位的气流脉动计算
% Dbias 偏置管内插入缓冲罐的管径，如果偏置管没有内插如缓冲罐，Dbias为0
%                       |  L2
%              Lv    l  | outlet
%        _______________|___ bias2
%       |                   |  Dpipe
%       |lv2  V          lv1|———— L1  
%       |___________________| inlet
%           Dv              l   

%BiasFrontInBiasFrontOut:侧前进侧前出
%   Detailed explanation goes here
%           |  L1
%      lv1  |      inlet
%       ___ |_______________
%       |                   |
%       |     Lv            |  Dv
%       |___________________|
%           |    
%           |
%  outlet:  | L2 Dpipe (Dbias为插入管的管道直径，取0即可)
pp = varargin;
massflowData = nan;
ar = [];%长径比，如果不指定，按照param的参数进行计算
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
param.L = 10;%总长度
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv = 1.1;
param.l = 0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%管道直径（m）
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];
param.lv1 = 0.318;
param.lv2 = 0.318;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'massflowdata'
            massflowData = val;
        case 'vtype'
            vType = val;
        case 'param'
            param = val;
		case 'ar'
			ar = val;
        otherwise
            error('错误参数:%s',prop);
    end
end


if isnan(massflowData)
    [massFlowRaw,time,ttmp,opt.meanFlowVelocity] = massFlowMaker(0.25,0.098,param.rpm...
        ,0.14,1.075,param.outDensity,'rcv',0.15,'k',1.4,'pr',0.15,'fs',param.Fs,'oneSecond',6);
    clear ttmp;
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


baseFrequency = 14;
multFreTimes = 3;
semiFreTimes = 3;
allowDeviation = 0.5;


%计算长径比
if isempty(ar)
	ar = param.Lv / param.Dv;
end


dcpss = getDefaultCalcPulsSetStruct();
dcpss.calcSection = [0.2,0.8];
dcpss.fs = param.Fs;
dcpss.isHp = 0;
dcpss.f_pass = 7;%通过频率5Hz
dcpss.f_stop = 5;%截止频率3Hz
dcpss.rp = 0.1;%边带区衰减DB数设置
dcpss.rs = 30;%截止区衰减DB数设置
theoryDataCells{1,1} = '描述';
theoryDataCells{1,2} = 'dataCells';
theoryDataCells{1,3} = 'X';
theoryDataCells{1,4} = '偏置距离';
theoryDataCells{1,5} = '长径比';
theoryDataCells{1,6} = 'input';
Z = cell(length(index),1);
X = [];
Y = [];

for i=1:length(V)
    for j = 1:length(lv1)
        param.Dv = calcDFixAspectRatio(V(i),ar);%根据长径比和体积计算直径
		param.Lv = ar * param.Dv;%计算缓冲罐长度

        X(i,j) = lv1(j);
        Y(i,j) = V(i);
        maxLv1 = param.Lv - param.Dpipe;
        if lv1(j) > maxLv1
            count = 1;
            for kk=index
                Z{count}(i,j) = nan;
                count = count + 1;
            end
            continue;
        end
		if lv1(j) < param.Dpipe
            count = 1;
            for kk=index
                Z{count}(i,j) = nan;
                count = count + 1;
            end
            continue;
        end
        
        [pressure1,pressure2] = oneVesselPulsationCalc(param.massFlowE,param.fre,time...
            ,param.L1,param.L2,param.Lv,param.l,param.Dpipe,param.Dv ...
            ,param.sectionL1,param.sectionL2 ...
            ,'vType',vType...
            ,'a',param.acousticVelocity...
            ,'isDamping',param.isDamping...
            ,'friction',param.coeffFriction...
            ,'isOpening',param.isOpening...
            ,'meanFlowVelocity',param.meanFlowVelocity...
            ,'lv1',param.lv1...
            ,'lv2',param.lv2...
            );
        pressure = [pressure1,pressure2];
        plus = calcPuls(pressure,dcpss);
        count = 1;
        for kk=index
            Z{count}(i,j) = plus(kk);
            count = count + 1;
        end
    end
end


end



function Dv = calcDFixAspectRatio(V,ar)
    Dv = ((4 .* V) ./ (pi .* ar)) .^ (1/3);
end