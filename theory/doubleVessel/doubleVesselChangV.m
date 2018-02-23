function theoryDataCells = doubleVesselChangV(V,varargin)
%迭代体积V,其中输出两个一个是等体积的单罐，一个是双罐
%既是length(param.sectionL1) + length(param.sectionL2) + length(param.sectionL3) 
%theoryDataCells每个内容是一个结构体，结构体定义为:
% res.X V1 
% res.Y V2
% res.Z 计算的脉动结果
%
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




	for i=1:length(V)
		%计算LV和D
		v1 = V(i) / 2;
		v2 = v1;
		if strcmpi(calcMode,'fixr')
			[param.DV1,param.LV1] = calcDLFixR(calcModeValue(1),v1);
			[param.DV2,param.LV2] = calcDLFixR(calcModeValue(2),v2);
			[paramT.Dv,paramT.Lv] = calcDLFixR(calcModeValue(3),V(i));
			param.L3 = Ltotal - param.L1 - param.L2;
			paramT.L2 = Ltotal - paramT.L1;
			paramT.sectionL2 = 0:0.25:paramT.L2;%
		end
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
		pressure = [pressure1,pressure2,pressure3];
		plus = calcPuls(pressure,dcpss);
		vType = 'StraightInStraightOut';
		singleVesselRes = oneVesselPulsation('param',paramT...
									,'vType',vType...
									,'fast',true...
									);
		svPlus = singleVesselRes{1};
		svXDis = singleVesselRes{2};
        pr = [];
		for kk=1:length(plus)
			dvesselXDis = XDis(kk);
			[ clVal,index ] = closeValue(svXDis,dvesselXDis);
			sv = svPlus(index);
			pr(kk) = (sv - plus(kk))./sv .* 100;
        end
        res.pr = pr;
		res.doubleVesselX = XDis;
		res.doubleVesselPlus = plus;
		res.singleVesselX =	svXDis;
		res.singleVesselPlus = svPlus; 
		theoryDataCells{i} = res;
	end

end

function [D,L] = calcDLFixR(r,v)
	L = ((4 .* v .* r .^ 2) ./ pi) .^ (1/3);
	D = L ./ r;
end