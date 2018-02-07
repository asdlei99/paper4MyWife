%% ֱ��ɨƵ
function pressure = oneVesselFrequencyResponse(varargin)
vType = 'StraightInStraightOut';
pp = varargin;
responseType = 'm';%��Ӧ����:m M���� n:��������r,��˹����ź�

param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 345;%���٣�m/s��
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv = 1.1;
param.l = 0.01;%(m)����޵����ӹܳ�
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%�ܵ�ֱ����m��

param.lv1 = 0.318;
param.lv2 = 0.318;
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
        case 'vtype' %
            vType = val;
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
end


[pressure1,pressure2] = oneVesselPulsationCalc(param.massFlowE,param.fre,time...
    ,param.L1,param.L2,param.Lv,param.l,param.Dpipe,param.Dv ...
    ,param.sectionL1,param.sectionL2 ...
    ,'a',param.acousticVelocity...
    ,'isDamping',param.isDamping...
    ,'friction',param.coeffFriction...
    ,'isOpening',param.isOpening...
    ,'meanFlowVelocity',param.meanFlowVelocity...
    ,'lv1',param.lv1...
    ,'lv2',param.lv2...
    ,'vType',vType...
    );
pressure=[pressure1,pressure2];

end

