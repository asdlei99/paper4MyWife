function theoryDataCells = doubleVesselChangDistanceToFirstVessel(L2,varargin)

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
    param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�


	baseFrequency = 14;
	multFreTimes = 3;
	semiFreTimes = 3;
	allowDeviation = 0.5;
	
	isFast = true;
	
	
	
    while length(pp)>=2
		prop =pp{1};
		val=pp{2};
		pp=pp(3:end);
		switch lower(prop)
			case 'massflowdata'
				massflowData = val;
			case 'param'
				param = val;
			case 'basefrequency'
				baseFrequency = val;
			case 'multfretimes'
				multFreTimes = val;
			case 'semifretimes'
				semiFreTimes = val;
			case 'fast'
				isFast = val;
			case 'fixpipelength'
				fixPipeLength = val;
			otherwise
				error('��������%s',prop);
		end
	end
	fixPipeLength = param.L1 + param.L2 + param.L3;
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

    


    beforeAfterMeaPoint = [length(param.sectionL1),length(param.sectionL1)+length(param.sectionL2)+1];;


    dcpss = getDefaultCalcPulsSetStruct();
    dcpss.calcSection = [0.3,0.7];
    dcpss.sigma = 2.8;
    dcpss.fs = param.Fs;
    dcpss.isHp = 0;
    dcpss.f_pass = 7;%ͨ��Ƶ��5Hz
    dcpss.f_stop = 5;%��ֹƵ��3Hz
    dcpss.rp = 0.1;%�ߴ���˥��DB������
    dcpss.rs = 30;%��ֹ��˥��DB������

	if ~isFast
		theoryDataCells{1,1} = '����';
		theoryDataCells{1,2} = 'dataStrcutCell';
		theoryDataCells{1,3} = 'X';
		theoryDataCells{1,4} = 'param';
		theoryDataCells{1,5} = '�ӹܳ�';
		theoryDataCells{1,6} = 'vesselRagion1';
		theoryDataCells{1,7} = 'vesselRagion2';
	end
	
    
    
    
    for count = 1:length(L2)
        param.L2 = L2(count);
        param.L3 = fixPipeLength - param.L2 - param.L1;
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
		pressure = [pressure1,pressure2,pressure3];
		X = [param.sectionL1...
			,param.L1+param.LV1+2*param.l+param.sectionL2...
			,param.L1+param.LV1+2*param.l+param.L2+param.LV2+2*param.l+param.sectionL3];
		vesselRagion1 = [param.sectionL1(end),param.L1+param.LV1+2*param.l+param.sectionL2(1)];
		vesselRagion2 = [param.L1+param.LV1+2*param.l+param.sectionL2(end),param.L1+param.LV1+2*param.l+param.L2+param.LV2+2*param.l+param.sectionL3(1)];
		
		if isFast
		
			res.plus = calcPuls(pressure,dcpss);
			res.X = X;
			res.param = param;
			res.vesselRagion1 = vesselRagion1;
			res.vesselRagion2 = vesselRagion2;
			theoryDataCells{count} = res;
		else
			rawDataStruct = fun_dataProcessing(pressure...
					,'fs',param.Fs...
					,'basefrequency',baseFrequency...
					,'allowdeviation',allowDeviation...
					,'multfretimes',multFreTimes...
					,'semifretimes',semiFreTimes...
					,'beforeAfterMeaPoint',beforeAfterMeaPoint...
					,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
					);
			theoryDataCells{count+1,1} = sprintf('˫�޴���L2=%g',L2(count));
			theoryDataCells{count+1,2} = rawDataStruct;
			theoryDataCells{count+1,3} = X;
			theoryDataCells{count+1,4} = param;
			theoryDataCells{count+1,5} = param.L2;
			theoryDataCells{count+1,6} = vesselRagion1;
			theoryDataCells{count+1,7} = vesselRagion2;
		end
    end
end