%% �׹�ɨƵɨƵ
function pressure = doubleVesselFrequencyResponse(varargin)
pp = varargin;
responseType = 'n';%��Ӧ����:m M���� n:��������r,��˹����ź�
%   massFlowE1 ����fft�������������ֱ�Ӷ�������������ȥֱ��fft
%  ���� L1     l    Lv1   l   L2  l    Lv2   l     L3
%              __________         __________
%             |          |       |          |
%  -----------|          |-------|          |-------------
%             |__________|       |__________|  
%  ֱ�� Dpipe       Dv1    Dpipe       Dv2          Dpipe
%   
%% ����·��
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
param.sectionL1 = 0:0.5:param.L1;
param.sectionL2 = 0:0.5:param.L2;
param.sectionL3 = 0:0.5:param.L3;
param.meanFlowVelocity = 16;
param.mach = param.meanFlowVelocity / param.acousticVelocity;


while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'responsetype' %ɨƵ����:m ��M���� n:��������r,��˹����ź�
            responseType = val;
        case 'param'
            param = val;
        case 'fs' %����ɨƵƵ�ʣ�Ĭ��200Hz
            fs = val;
        otherwise
            error('��������%s',prop);
	end
end
%% ��ʼ����
%


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

end

