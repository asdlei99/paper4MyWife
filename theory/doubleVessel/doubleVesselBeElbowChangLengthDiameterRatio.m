function theoryDataCells = doubleVesselBeElbowChangLengthDiameterRatio(varargin)
% ˫�޵ڶ����������Ϊ��ͷ����˫���м����ӹܳ�����
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
    param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
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
        time = makeTime(param.Fs,4096);
        param.fre = massflowData(1,:);
        param.massFlowE = massflowData(2,:);
        if isnan(param.meanFlowVelocity)
            param.meanFlowVelocity = 14;
        end
    end

    param.acousticVelocity = 345;%����
    param.isDamping = 1;%�Ƿ��������
    param.coeffFriction = 0.003;%�ܵ�Ħ��ϵ��
    param.coeffFriction = 0.045;
param.meanFlowVelocity = 25.51;%14.6;%�ܵ�ƽ������
    param.mach = param.meanFlowVelocity / param.acousticVelocity;
    param.notMach = 0;

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
    beElbowVesselV = ((pi * param.DV2 ^ 2) / 4) * param.LV1;
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
    theoryDataCells{1,1} = '����';
    theoryDataCells{1,2} = 'dataStrcutCell';
    theoryDataCells{1,3} = 'X';
    theoryDataCells{1,4} = 'param';
    theoryDataCells{1,5} = '�޶�ֱ��';
    theoryDataCells{1,6} = '�޶�������';
    DV2 = param.DV2/2:0.01:2*(param.DV2);%�����ı���DV2

    for count = 1:length(DV2)
        param.DV2 = DV2(count);
        param.LV2 = beElbowVesselV / ((pi * param.DV2 ^ 2) / 4);


        [pressure1,pressure2,pressure3] = ...
            doubleVesselElbowPulsationCalc(param.massFlowE,param.fre,time,...
                param.L1,param.L2,param.L3,...
                param.LV1,param.LV2,param.l,param.Dpipe,param.DV1,param.DV2,...
                param.lv3,param.Dbias,...
                param.sectionL1,param.sectionL2,param.sectionL3,...
                'a',param.acousticVelocity,'isDamping',param.isDamping,'friction',param.coeffFriction,...
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
        cellIndex = count + 1;
        theoryDataCells{cellIndex,1} = sprintf('˫�޹޶�����ͷDV2=%g,LV2=%g',param.DV2,param.LV2);
        theoryDataCells{cellIndex,2} = rawDataStruct;
        theoryDataCells{cellIndex,3} = [param.sectionL1...
                                    ,param.L1+param.LV1+2*param.l+param.sectionL2...
                                    ,param.L1+param.LV1+2*param.l+param.L2+param.lv3+param.DV2/2+param.sectionL3];
        theoryDataCells{cellIndex,4} = param;
        theoryDataCells{cellIndex,5} = param.DV2;
        theoryDataCells{cellIndex,6} = param.LV2 / param.DV2;
    end
end