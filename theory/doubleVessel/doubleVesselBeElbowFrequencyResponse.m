function pressure = doubleVesselBeElbowFrequencyResponse(varargin)
% ˫�޵ڶ����������Ϊ��ͷ�ĳ��������Ӧ���� - Ƶ�����Է���
    pp = varargin;
    responseType = 'n';%��Ӧ����:m M���� n:��������r,��˹����ź�
    
    param.meanFlowVelocity = 14;
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
    fs = 400;
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'mresponsetype'
                responseType = val;
            case 'param'
                param = val;
            case 'fs' %����ɨƵƵ�ʣ�Ĭ��200Hz
                fs = val;
            otherwise
                error('��������%s',prop);
        end
    end
   
    if strcmpi(responseType,'m')
        [time,Y] = makeInvM(fs,6 ...
                    ,'isshowfig',false...
                    ,'midval',0.1 ...
                    ,'pp',0.1*0.1 ...
                    );
        [param.fre,AmpRaw,PhRaw,param.massFlowE] = frequencySpectrum(detrend(Y,'constant'),fs);
    elseif strcmpi(responseType,'n')
    %��������
        [time,Y] = makeIdealPuls(fs,6,'isshowfig',false...
                    ,'midval',10 ...
                    ,'pp',10*0.1 ...
                    );
        [param.fre,AmpRaw,PhRaw,param.massFlowE] = frequencySpectrum(detrend(Y,'constant'),fs);
    end
    
    

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

   
    [pressure1,pressure2,pressure3] = ...
        doubleVesselElbowPulsationCalc(param.massFlowE,param.fre,time,...
            param.L1,param.L2,param.L3,...
            param.LV1,param.LV2,param.l,param.Dpipe,param.DV1,param.DV2,...
            param.lv3,param.Dbias,...
            param.sectionL1,param.sectionL2,param.sectionL3,...
            'a',param.acousticVelocity,'isDamping',param.isDamping,'friction',0.045,...
            'meanFlowVelocity',param.meanFlowVelocity,'isUseStaightPipe',1,...
            'm',param.mach,'notMach',param.notMach...
            ,'isOpening',param.isOpening...
            );%,'coeffDamping',opt.coeffDamping
    pressure = [pressure1,pressure2,pressure3];
end