%% 孔管扫频扫频
function pressure = PerforateCloseFrequencyResponse(varargin)
pp = varargin;
responseType = 'n';%响应类型:m M序列 n:理想冲击，r,高斯随机信号

%% 数据路径
%缓冲罐中间插入孔管,两端堵死，开孔个数不足以等效为亥姆霍兹共鸣器,缓冲罐入口偏置
%                 L1
%                     |
%                     |
%           l   LBias |                                    L2  
%              _______|_________________________________        
%             |    dp(n1)            |    dp(n2)        |
%             |           ___ _ _ ___|___ _ _ ___ lc    |     
%             |          |___ _ _ ___ ___ _ _ ___|Din   |----------
%             |           la1 lp1 la2|lb1 lp2 lb2       |
%             |______________________|__________________|       
%                             Lin         Lout          l
%                       Lv1                  Lv2
%    Dpipe                       Dv                     Dpipe             
%           
%
% Lin 内插孔管入口段长度 
% Lout内插孔管出口段长度
% lc  孔管壁厚
% dp  孔管每一个孔孔径
% n1  孔管入口段开孔个数；    n2  孔管出口段开孔个数
% la1 孔管入口段距入口长度 
% la2 孔管入口段距隔板长度
% lb1 孔管出口段距隔板长度
% lb2 孔管出口段距开孔长度
% lp1 孔管入口段开孔长度
% lp2 孔管出口段开孔长度
% Din 孔管管径；
% xSection1，xSection2 孔管每圈孔的间距，从0开始算，x的长度为孔管孔的圈数+1，x的值是当前一圈孔和上一圈孔的距离，如果间距一样，那么x里的值都一样
param.acousticVelocity = 345;%声速（m/s）
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
param.L1 = 3.5;%(m)
param.L2 = 6;

param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%管道直径（m）
param.Lbias = 0.168+0.150;
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.l  =  0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;%缓冲罐的直径（m）
param.Lv1 = 1.1/2;%缓冲罐腔1总长
param.Lv2 =  1.1/2;
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2];
%
param.lc   = 0.005;%内插管壁厚
param.dp1  = 0.013;%开孔径
param.dp2  = 0.013;%开孔径
param.lp1  = 0.16;%内插管入口段非孔管开孔长度
param.lp2  = 0.16;%内插管出口段孔管开孔长度
param.n1   = 24;%入口段孔数
param.n2   = 24;%出口段孔数
param.la1  = 0.03;%孔管入口段靠近入口长度
param.la2  = 0.06;
param.lb1  = 0.06;
param.lb2  = 0.03;
param.Din  = 0.049;
param.Lout = param.lb1 + param.lp2+ param.lb2;%内插管入口段长度
param.bp1 = calcPerforatingRatios(param.n1,param.dp1,param.Din,param.lp1);
param.bp2 = calcPerforatingRatios(param.n2,param.dp2,param.Din,param.lp2);
param.Lin  = param.la1 + param.lp1+ param.la2;%内插管入口段长度
param.LBias = (0.150+0.168);%232
param.Dbias = 0;%无内插管
param.sectionNum1 = [1];%对应孔1的组数
param.sectionNum2 = [1];%对应孔2的组数
param.xSection1 = [0,ones(1,param.sectionNum1).*(param.lp1/(param.sectionNum1))];
param.xSection2 = [0,ones(1,param.sectionNum2).*(param.lp2/(param.sectionNum2))];
param.pressureBoundary2 = 0;

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
index = find(param.fre == 0);
param.fre(index) = [];
param.massFlowE(index) = [];

[pressure1,pressure2] = vesselInBiasHaveInnerPerfBothClosedCompCalc(param.massFlowE,param.fre,time...
	,param.L1,param.L2,param.Dpipe,param.Dv,param.l...
	,param.Lv1,param.Lv2,param.lc,param.dp1,param.dp2,param.lp1,param.lp2...
	,param.n1,param.n2,param.la1,param.la2,param.lb1...
	,param.lb2,param.Din,param.Dbias...
	,param.LBias,param.xSection1,param.xSection2...
	,param.sectionL1,param.sectionL2...
	,'a',param.acousticVelocity...
	,'isDamping',param.isDamping...
	,'friction',param.coeffFriction...
	,'meanFlowVelocity',param.meanFlowVelocity...
	,'isOpening',param.isOpening...
    ,'pressureBoundary2',param.pressureBoundary2...
);
pressure = [pressure1,pressure2];

end

