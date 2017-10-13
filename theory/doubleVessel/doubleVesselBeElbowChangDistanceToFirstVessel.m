function theoryDataCells = doubleVesselBeElbowChangDistanceToFirstVessel(varargin)
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
        time = makeTime(param.Fs,1024);
        param.fre = massflowData(1,:);
        param.massFlowE = massflowData(2,:);
        if isnan(param.meanFlowVelocity)
            param.meanFlowVelocity = 14;
        end
    end

    param.acousticVelocity = 345;%����
    param.isDamping = 1;%�Ƿ��������
    param.coeffFriction = 0.003;%�ܵ�Ħ��ϵ��

    param.mach = param.meanFlowVelocity / param.acousticVelocity;
    param.notMach = 0;

    param.L1 = 3.5;%L1(m)
    param.L3 = 1.5;%1.5;%˫�޴����޶�����ͷ���޼��
    param.L4 = 4;%4%˫�޴����޶�����ͷ���ڹܳ�
    param.L5 = 5.85;%4.5;%˫���޼������L2��m������
    param.Dpipe = 0.098;%�ܵ�ֱ����m��%Ӧ����0.106
    param.l = 0.01;
    param.DV1 = 0.372;%����޵�ֱ����m��
    param.LV1 = 1.1;%������ܳ� ��1.1m��
    param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%����޵�ֱ����0.372m��
    param.LV2 = 1.1;%variant_r(i).*param.DV2;%������ܳ� ��1.1m��
    param.Lv1 = param.LV1./2;%�����ǻ1�ܳ�
    param.Lv2 = param.LV1-param.Lv1;%�����ǻ2�ܳ�   
    param.lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
    param.Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
    param.sectionL1 = 0:0.25:param.L1;%[2.5,3.5];%0:0.25:param.L1
    
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
    theoryDataCells{1,5} = '�ӹܳ�';
    L3 = [0.25:0.25:10];
    maxLLength = param.L1 + L3(end) + param.L4;
    
    for count = 1:length(L3)
        param.L3 = L3(count);
        param.L4 = maxLLength - param.L3 - param.L1;
        param.sectionL3 = 0:0.25:param.L3;
        param.sectionL4 = 0:0.25:param.L4;
        [pressure1,pressure2,pressure3] = ...
            doubleVesselElbowPulsationCalc(param.massFlowE,param.fre,time,...
                param.L1,param.L3,param.L4,...
                param.LV1,param.LV2,param.l,param.Dpipe,param.DV1,param.DV2,...
                param.lv3,param.Dbias,...
                param.sectionL1,param.sectionL3,param.sectionL4,...
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
        cellIndex = count + 1;
        theoryDataCells{cellIndex,1} = sprintf('˫�޹޶�����ͷL3=%g',L3(count));
        theoryDataCells{cellIndex,2} = rawDataStruct;
        theoryDataCells{cellIndex,3} = [param.sectionL1...
                                    ,param.L1+param.LV1+2*param.l+param.sectionL3...
                                    ,param.L1+param.LV1+2*param.l+param.L3+param.lv3+param.DV2/2+param.sectionL4];
        theoryDataCells{cellIndex,4} = param;
        theoryDataCells{cellIndex,5} = L3(count);
    end
end