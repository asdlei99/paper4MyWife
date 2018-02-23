function theoryDataCells = doubleVesselFixVChangeV1V2(V1,varargin)
%��������̶�����µ������V1��v2
% �����V�����param����
%   massFlowE1 ����fft�������������ֱ�Ӷ�������������ȥֱ��fft
%  ���� L1     l    Lv1   l   L2  l    Lv2   l     L3
%              __________         __________
%             |          |       |          |
%  -----------|          |-------|          |-------------
%             |__________|       |__________|  
%  ֱ�� Dpipe       Dv1    Dpipe       Dv2          Dpipe
%   
	detalDis = 0.5;
    pp = varargin;
    massflowData = nan;
	param.acousticVelocity = 345;%����
    param.isDamping = 1;%�Ƿ��������
    param.coeffFriction = 0.003;%�ܵ�Ħ��ϵ��
    param.notMach = 0;

    param.L1 = 3.5;%L1(m)
    param.L2 = 1.5;%1.5;%˫�޴������޼��
    param.L3 = 4;%4%˫�޴����޶����ڹܳ�
    param.Dpipe = 0.098;%�ܵ�ֱ����m��%Ӧ����0.106
    param.l = 0.01;
    param.DV1 = 0.372;%����޵�ֱ����m��
    param.LV1 = 1.1;%������ܳ� ��1.1m��
    param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%����޵�ֱ����0.372m��
    param.LV2 = 1.1;%variant_r(i).*param.DV2;%������ܳ� ��1.1m��
	param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
    param.rpm = 300;
    param.outDensity = 1.5608;
    param.Fs = 4096;
    param.sectionL1 = 0:detalDis:param.L1;
    param.sectionL2 = 0:detalDis:param.L2;
    param.sectionL3 = 0:detalDis:param.L3;
    param.meanFlowVelocity = 16;
    param.mach = param.meanFlowVelocity / param.acousticVelocity;

    ldr = param.LV1 / param.DV1;
	calcMode = 'fixR';%����ģʽ fixR ���������� 
	
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
				error('��������%s',prop);
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
	paramLDR1 = param.LV1 / param.DV1;%������
	paramLDR2 = param.LV2 / param.DV2;

    
    dcpss = getDefaultCalcPulsSetStruct();
    dcpss.calcSection = [0.3,0.7];
    dcpss.sigma = 2.8;
    dcpss.fs = param.Fs;
    dcpss.isHp = 0;
    dcpss.f_pass = 7;%ͨ��Ƶ��5Hz
    dcpss.f_stop = 5;%��ֹƵ��3Hz
    dcpss.rp = 0.1;%�ߴ���˥��DB������
    dcpss.rs = 30;%��ֹ��˥��DB������


	Ltotal = param.L1 + param.L2 + param.L3;
	paramT = doubleVesselParamToSingleVesselParam(param);
	if strcmpi(calcMode,'fixr')
		calcModeValue(1) = param.LV1 / param.DV1;
		calcModeValue(2) = param.LV2 / param.DV2;
		calcModeValue(3) = paramT.Lv / paramT.Dv;
	end




	for i=1:length(V1)
		%����V2�����V1����V��ͣ�µ���
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
        %������������
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
	%�̶������ȼ���ֱ���ͳ���
	L = ((4 .* v .* r .^ 2) ./ pi) .^ (1/3);
	D = L ./ r;
end