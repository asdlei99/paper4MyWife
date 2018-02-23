function theoryDataCells = doubleVesselFixVChangeV1V2(V1,varargin)
%在总体积固定情况下迭代体积V1和v2
% 总体积V会根据param计算
%   massFlowE1 经过fft后的质量流量，直接对质量流量进行去直流fft
%  长度 L1     l    Lv1   l   L2  l    Lv2   l     L3
%              __________         __________
%             |          |       |          |
%  -----------|          |-------|          |-------------
%             |__________|       |__________|  
%  直径 Dpipe       Dv1    Dpipe       Dv2          Dpipe
%   
	detalDis = 0.5;
    pp = varargin;
    massflowData = nan;
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
    param.Fs = 4096;
    param.sectionL1 = 0:detalDis:param.L1;
    param.sectionL2 = 0:detalDis:param.L2;
    param.sectionL3 = 0:detalDis:param.L3;
    param.meanFlowVelocity = 16;
    param.mach = param.meanFlowVelocity / param.acousticVelocity;

    ldr = param.LV1 / param.DV1;
	calcMode = 'fixR';%计算模式 fixR 锁定长径比 
	
    while length(pp)>=2
		prop =pp{1};
		val=pp{2};
		pp=pp(3:end);
		switch lower(prop)
			case 'massflowdata'
				massflowData = val;
			case 'param'
				param = val;
			otherwise
				error('错误属性%s',prop);
		end
	end
	
	if isnan(massflowData)
		
		[massFlowRaw,time,tmp,opt.meanFlowVelocity] = massFlowMaker(0.25,0.098,param.rpm...
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

	paramV1 = param.LV1 * (pi * param.DV1 ^ 2 / 4);
	paramV2 = param.LV2 * (pi * param.DV2 ^ 2 / 4);
	paramTotalV = paramV1 + paramV2;
	paramLDR1 = param.LV1 / param.DV1;%长径比
	paramLDR2 = param.LV2 / param.DV2;

    
    dcpss = getDefaultCalcPulsSetStruct();
    dcpss.calcSection = [0.3,0.7];
    dcpss.sigma = 2.8;
    dcpss.fs = param.Fs;
    dcpss.isHp = 0;
    dcpss.f_pass = 7;%通过频率5Hz
    dcpss.f_stop = 5;%截止频率3Hz
    dcpss.rp = 0.1;%边带区衰减DB数设置
    dcpss.rs = 30;%截止区衰减DB数设置


	Ltotal = param.L1 + param.L2 + param.L3;
	paramT = doubleVesselParamToSingleVesselParam(param);
	if strcmpi(calcMode,'fixr')
		calcModeValue(1) = param.LV1 / param.DV1;
		calcModeValue(2) = param.LV2 / param.DV2;
		calcModeValue(3) = paramT.Lv / paramT.Dv;
	end




	for i=1:length(V1)
		%计算V2，如果V1大于V就停下迭代
		V2 = paramTotalV - V1(i);
		if V2 <= 0
			break;
		end 
		[param.DV1,param.LV1] = calcDLFixR(paramLDR1,V1(i));
		[param.DV2,param.LV2] = calcDLFixR(paramLDR2,V2);

		
		XDis = [param.sectionL1...
			,param.L1+param.LV1+2*param.l+param.sectionL2...
			,param.L1+param.LV1+2*param.l+param.L2+param.LV2+2*param.l+param.sectionL3];
		
		[pressure1,pressure2,pressure3] = ...
            doubleVesselPulsationCalc(param.massFlowE,param.fre,time,...
                param.L1,param.L2,param.L3,...
                param.LV1,param.LV2,param.l,param.Dpipe,param.DV1,param.DV2,...
                param.sectionL1,param.sectionL2,param.sectionL3,...
                'a',param.acousticVelocity,'isDamping',param.isDamping,'friction',0.045,...
                'meanFlowVelocity',param.meanFlowVelocity,'isUseStaightPipe',1,...
                'm',param.mach,'notMach',param.notMach...
                ,'isOpening',param.isOpening...
                );%,'coeffDamping',opt.coeffDampingo
		pressureAll = [pressure1,pressure2,pressure3];
		plusVal = calcPuls(pressureAll,dcpss);
        pressurePart = [pressure1,pressure3];
		plusPartVal = calcPuls(pressurePart,dcpss);
        %计算等体积单罐
		paramT = doubleVesselParamToSingleVesselParam(param,'r',ldr);
        vType = 'StraightInStraightOut';
        singleVesselRes = oneVesselPulsation('param',paramT...
									,'vType',vType...
									,'fast',true...
									);
        svPlus = singleVesselRes{1};
        sr = (svPlus - plusPartVal) ./ svPlus;
        res.xDis = XDis;
        res.v1 = V1(i);
		res.v2 = V2;
		res.param = param;
		res.plus = plusVal;
        res.plusL1L3 = plusPartVal;
        res.xDisL1L3 = [param.sectionL1...
			,param.L1+param.LV1+2*param.l+param.L2+param.LV2+2*param.l+param.sectionL3];;
        res.sr = sr;
		theoryDataCells{i} = res;
	end

end

function [D,L] = calcDLFixR(r,v)
	%固定长径比计算直径和长度
	L = ((4 .* v .* r .^ 2) ./ pi) .^ (1/3);
	D = L ./ r;
end