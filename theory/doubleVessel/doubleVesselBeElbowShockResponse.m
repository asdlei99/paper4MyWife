function theoryDataCells = doubleVesselBeElbowShockResponse(varargin)
% ˫�޵ڶ����������Ϊ��ͷ�ĳ��������Ӧ���� - Ƶ�����Է���
    pp = varargin;
    param.meanFlowVelocity = nan;
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
    
    param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
    param.rpm = 420;
    param.outDensity = 1.5608;
    




    param.acousticVelocity = 345;%����
    param.isDamping = 1;%�Ƿ��������
    param.coeffFriction = 0.003;%�ܵ�Ħ��ϵ��

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
    param.Lv1 = param.LV1./2;%�����ǻ1�ܳ�
    param.Lv2 = param.LV1-param.Lv1;%�����ǻ2�ܳ�   
    param.lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
    param.Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
    param.sectionL1 = 0:0.25:param.L1;%[2.5,3.5];%0:0.25:param.L1
    param.sectionL2 = 0:0.25:param.L2;
    param.sectionL3 = 0:0.25:param.L3;
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

   
    [pressure1,pressure2,pressure3] = ...
        doubleVesselElbowPulsationCalc(param.massFlowE,param.fre,shockTime,...
            param.L1,param.L2,param.L3,...
            param.LV1,param.LV2,param.l,param.Dpipe,param.DV1,param.DV2,...
            param.lv3,param.Dbias,...
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
    theoryDataCells{count,1} = sprintf('˫�޹޶�����ͷ�����Ӧ');
    theoryDataCells{count,2} = rawDataStruct;
    theoryDataCells{count,3} = [param.sectionL1...
                                ,param.L1+param.LV1+2*param.l+param.sectionL2...
                                ,param.L1+param.LV1+2*param.l+param.L2+param.lv3+param.DV2/2+param.sectionL3];
    theoryDataCells{count,4} = param;
end