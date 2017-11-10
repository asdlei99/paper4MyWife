function theoryDataCells = doubleVesselShockResponse(varargin)
% 双罐串联冲击脉动响应分析 - 频率特性分析
%计算管容管容的脉动
%   massFlowE1 经过fft后的质量流量，直接对质量流量进行去直流fft
%  长度 L1     l    Lv1   l   L2  l    Lv2   l     L3
%              __________         __________
%             |          |       |          |
%  -----------|          |-------|          |-------------
%             |__________|       |__________|  
%  直径 Dpipe       Dv1    Dpipe       Dv2          Dpipe
%  
    %计算双罐串联
    pp = varargin;
    shockFreTimes = 1;
    shockFs = 1024*shockFreTimes;
    shockPulsWave = [100,zeros(1,1024*shockFreTimes-1)];
    shockTime = 0:1:(size(shockPulsWave,2)-1);
    shockTime = shockTime .* (1/shockFs);
    [shockFrequency,~,~,shockMagE] = frequencySpectrum(shockPulsWave,shockFs);
    shockFrequency(1) = [];
    shockMagE(1) = [];
    param.Fs = shockFs;
    param.fre = shockFrequency;
    param.massFlowE = shockMagE;
    param.meanFlowVelocity = 14;
    param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
    param.rpm = 420;
    param.outDensity = 1.5608;
    param.acousticVelocity = 345;%声速
    param.isDamping = 1;%是否计算阻尼
    param.coeffFriction = 0.003;%管道摩察系数
    param.mach = param.meanFlowVelocity / param.acousticVelocity;
    param.notMach = 0;

    param.L1 = 3.5;%L1(m)
    param.L2 = 0;%4%双罐串联接管长
    param.L3 = 5.85;%4;%4%双罐串联出口管长
    
    param.Dpipe = 0.098;%管道直径（m）%应该是0.106
    param.l = 0.01;
    param.DV1 = 0.372;%缓冲罐的直径（m）
    param.LV1 = 1.1;%缓冲罐总长 （1.1m）
    param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
    param.LV2 = 1.1;%variant_r(i).*param.DV2;%缓冲罐总长 （1.1m）
    param.Lv1 = param.LV1./2;%缓冲罐腔1总长
    param.Lv2 = param.LV1-param.Lv1;%缓冲罐腔2总长   
    param.Dbias = 0;%偏置管伸入罐体部分为0，所以对应直径为0
    param.sectionL1 = 0:0.25:param.L1;%[2.5,3.5];%0:0.25:param.L1
    param.sectionL2 = 0:0.25:param.L2;
    param.sectionL3 = 0:0.25:param.L3;
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'meanflowvelocity'
                param.meanFlowVelocity = val;
        end
    end
    if isnan(param.meanFlowVelocity)
        param.meanFlowVelocity = 14;
    end
    
    count = 1;

    baseFrequency = 14;
    multFreTimes = 3;
    semiFreTimes = 3;
    allowDeviation = 0.5;
    beforeAfterMeaPoint = nan;
    calcPeakPeakValueSection = nan;

    dcpss = getDefaultCalcPulsSetStruct();
    dcpss.calcSection = [0.3,0.7];
    dcpss.sigma = 2.8;
    dcpss.fs = param.Fs;
    dcpss.isHp = 0;
    dcpss.f_pass = 7;%通过频率5Hz
    dcpss.f_stop = 5;%截止频率3Hz
    dcpss.rp = 0.1;%边带区衰减DB数设置
    dcpss.rs = 30;%截止区衰减DB数设置

    theoryDataCells{1,1} = '名称';
    theoryDataCells{1,2} = 'dataStrcutCell';
    theoryDataCells{1,3} = 'X';
    theoryDataCells{1,4} = 'param';
    theoryDataCells{1,5} = '中间接管长';
    count = count + 1;
   [pressure1,pressure2,pressure3] = ...
        doubleVesselPulsationCalc(param.massFlowE,param.fre,shockTime,...
            param.L1,param.L2,param.L3,...
            param.LV1,param.LV2,param.l,param.Dpipe,param.DV1,param.DV2,...
            param.sectionL1,param.sectionL2,param.sectionL3,...
            'a',param.acousticVelocity,'isDamping',param.isDamping,'friction',0.003,...
            'meanFlowVelocity',param.meanFlowVelocity,'isUseStaightPipe',1,...
            'm',param.mach,'notMach',param.notMach...
            ,'isOpening',param.isOpening...
            );%,'coeffDamping',opt.coeffDamping
    
     rawDataStruct = fun_dataProcessing([pressure1,pressure2,pressure3]...
            ,'fs',param.Fs...
            ,'basefrequency',baseFrequency...
            ,'allowdeviation',allowDeviation...
            ,'multfretimes',multFreTimes...
            ,'semifretimes',semiFreTimes...
            ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
            ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
            );
    theoryDataCells{count,1} = sprintf('双罐串联冲击响应');
    theoryDataCells{count,2} = rawDataStruct;
    theoryDataCells{count,3} = [param.sectionL1...
                                ,param.L1+param.LV1+2*param.l+param.sectionL2...
                                ,param.L1+param.LV1+2*param.l+param.L2+param.sectionL3];
    theoryDataCells{count,4} = param;
    theoryDataCells{count,5} = param.L3;
end