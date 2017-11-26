function [XD,YV,ZPlus] = doubleVesselBeElbowChangLengthDiameterRatioAndV(resIndex,varargin)
% ˫�޵ڶ����������Ϊ��ͷ����˫���м����ӹܳ�����
% resIndex �ǲ�������
    if 0 == nargin
        resIndex = 'end';
    end
    pp = varargin;
    massflowData = nan;
    param.acousticVelocity = 345;%����
    param.isDamping = 1;%�Ƿ��������
    param.coeffFriction = 0.003;%�ܵ�Ħ��ϵ��
    param.coeffFriction = 0.045;
    param.meanFlowVelocity = 25.51;%14.6;%�ܵ�ƽ������
    param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
    param.rpm = 420;
    param.outDensity = 1.5608;
    param.Fs = 4096;
    param.L1 = 3.5;%L1(m)
    param.L2 = 1.5;%1.5;%˫�޴����޶�����ͷ���޼��
    param.L3 = 4;%4%˫�޴����޶�����ͷ���ڹܳ�
    param.Dpipe = 0.098;%�ܵ�ֱ����m��%Ӧ����0.106
    param.l = 0.01;
    param.DV1 = 0.372;%����޵�ֱ����m��
    param.LV1 = 1.1;%������ܳ� ��1.1m��
    param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%����޵�ֱ����0.372m��
    param.LV2 = 1.1;%variant_r(i).*param.DV2;%������ܳ� ��1.1m�� 
    param.lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
    param.Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
    param.sectionL1 = 0:0.25:param.L1;%[2.5,3.5];%0:0.25:param.L1
    param.sectionL2 = 0:0.25:param.L2;%[2.5,3.5];%0:0.25:param.L1
    param.sectionL3 = 0:0.25:param.L3;%[2.5,3.5];%0:0.25:param.L1
    
    param.multFreTimes = 3;
    param.semiFreTimes = 3;
    param.allowDeviation = 0.5;
    param.beforeAfterMeaPoint = nan;
    param.calcPeakPeakValueSection = nan;
    param.notMach = 0;
    
    beElbowVesselV = ((pi * param.DV2 ^ 2) / 4) * param.LV1;
    beElbowVesselV = 0.5*beElbowVesselV : 0.01 : beElbowVesselV*1.5;
    %������
    Ldr = 1:0.5:23.66;
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'massflowdata'
                massflowData = val;
            case 'param'
                param = val;
            case 'ldr'
                Ldr = val;
            case 'beelbowvesselv'
                beElbowVesselV = val;
        end
    end
    
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
        time = makeTime(param.Fs,4096);
        param.fre = massflowData(1,:);
        param.massFlowE = massflowData(2,:);
        if isnan(param.meanFlowVelocity)
            param.meanFlowVelocity = 14;
        end
    end

    param.baseFrequency = param.rpm / 60 * 2;
    param.mach = param.meanFlowVelocity / param.acousticVelocity;
    

    

    count = 1;



    dcpss = getDefaultCalcPulsSetStruct();
    dcpss.calcSection = [0.3,0.7];
    dcpss.sigma = 2.8;
    dcpss.fs = param.Fs;
    dcpss.isHp = 0;
    dcpss.f_pass = 7;%ͨ��Ƶ��5Hz
    dcpss.f_stop = 5;%��ֹƵ��3Hz
    dcpss.rp = 0.1;%�ߴ���˥��DB������
    dcpss.rs = 30;%��ֹ��˥��DB������

%       ���� L1     l    Lv    l    L2   l    Lv
    %                   __________            ___________ 
    %                  |          |          |           |   
    %       -----------|          |----------|           |
    %                  |__________|          |__   ______|      
    % ֱ��      Dpipe       Dv       Dpipe      | |
    %                                           | | L3 
    %                                           | |
    %����˫��-�޶�����ͷ ������ٵ��ڵ�45ʱ��ģ��Ͻӽ�(L1,L3,L4,0.045)
    %����˫��-�޶�����ͷ ������ٵ��ڵ�45ʱ��ģ��Ͻӽ�(L1,L3,L4,0.045)

    
    for i = 1:length(beElbowVesselV)
        for j = 1:length(Ldr)
            %����Ldr����ֱ��
            Dv2 = calcDFromVAndLDR(beElbowVesselV(i),Ldr(j));
            %���ݳ����Ⱥ�������㳤��
            LV2 = calcLFromVAndLDR(beElbowVesselV(i),Ldr(j));
            XD(i,j) = Ldr(j);
            YV(i,j) = beElbowVesselV(i);
            
            [pressure1,pressure2,pressure3] = ...
            doubleVesselElbowPulsationCalc(param.massFlowE,param.fre,time,...
                param.L1,param.L2,param.L3,...
                param.LV1,LV2,param.l,param.Dpipe,param.DV1,Dv2,...
                param.lv3,param.Dbias,...
                param.sectionL1,param.sectionL2,param.sectionL3,...
                'a',param.acousticVelocity,'isDamping',param.isDamping,'friction',param.coeffFriction,...
                'meanFlowVelocity',param.meanFlowVelocity,'isUseStaightPipe',1,...
                'm',param.mach,'notMach',param.notMach...
                ,'isOpening',param.isOpening...
                );%,'coeffDamping',opt.coeffDamping
            pressure = [pressure1,pressure2,pressure3];
            pressurePlus = calcPuls(pressure,dcpss);
            if isstr(resIndex)
                if strcmp(resIndex,'end')
                    ZPlus(i,j) = pressurePlus(end);
                end
            else
                ZPlus(i,j) = pressurePlus(resIndex);
            end
        end
    end
end

%���ݳ����Ⱥ��������ֱ��
function d = calcDFromVAndLDR(V,Ldr)
    d = ((4.*V)/(pi.*Ldr)).^(1/3);
end

%���ݳ����Ⱥ�������㳤��
function l = calcLFromVAndLDR(V,Ldr)
    l = ((4.*V.*Ldr.^2)/pi).^(1/3);
end