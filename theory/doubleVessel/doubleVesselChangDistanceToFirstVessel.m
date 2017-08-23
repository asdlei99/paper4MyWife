function theoryDataCells = doubleVesselChangDistanceToFirstVessel(varargin)

%   massFlowE1 经过fft后的质量流量，直接对质量流量进行去直流fft
%  长度 L1     l    Lv1   l   L2  l    Lv2   l     L3
%              __________         __________
%             |          |       |          |
%  -----------|          |-------|          |-------------
%             |__________|       |__________|  
%  直径 Dpipe       Dv1    Dpipe       Dv2          Dpipe
%   
    pp = varargin;
    massflowData = nan;
    param.meanFlowVelocity = nan;
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'massflowdata'
                massflowData = val;
            case 'meanflowvelocity'
                param.meanFlowVelocity = val;
        end
    end
    param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
    param.rpm = 420;
    param.outDensity = 1.5608;
    param.Fs = 4096;
    if isnan(massflowData)
        [massFlowRaw,time,~,param.meanFlowVelocity] = massFlowMaker(0.25,0.098,param.rpm...
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
        if isnan(param.meanFlowVelocity)
            param.meanFlowVelocity = 14;
        end
    end

    param.acousticVelocity = 345;%声速
    param.isDamping = 1;%是否计算阻尼
    param.coeffFriction = 0.003;%管道摩察系数
    param.mach = param.meanFlowVelocity / param.acousticVelocity;
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
    detalDis = 0.25;
    param.sectionL1 = 0:detalDis:param.L1;
    param.sectionL2 = 0:detalDis:param.L2;
    param.sectionL3 = 0:detalDis:param.L3;

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
    theoryDataCells{1,5} = '接管长';
    L2 = [0.25:0.25:10];
    maxLLength = param.L1 + L2(end) + param.L3;
    
    for count = 1:length(L2)
        param.L2 = L2(count);
        param.L3 = maxLLength - param.L2 - param.L1;
        param.sectionL2 = 0:detalDis:param.L2;
        param.sectionL3 = 0:detalDis:param.L3;
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
         rawDataStruct = fun_dataProcessing([pressure1,pressure2,pressure3]...
                ,'fs',param.Fs...
                ,'basefrequency',baseFrequency...
                ,'allowdeviation',allowDeviation...
                ,'multfretimes',multFreTimes...
                ,'semifretimes',semiFreTimes...
                ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
                );
        theoryDataCells{count,1} = sprintf('双罐串联L2=%g',L2(count));
        theoryDataCells{count,2} = rawDataStruct;
        theoryDataCells{count,3} = [param.sectionL1...
                                    ,param.L1+param.LV1+2*param.l+param.sectionL2...
                                    ,param.L1+param.LV1+2*param.l+param.L2+param.LV2+2*param.l+param.sectionL3];
        theoryDataCells{count,4} = param;
        theoryDataCells{count,5} = L2(count);
    end
end