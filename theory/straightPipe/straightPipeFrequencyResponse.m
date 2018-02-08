%% ֱ��ɨƵ
function pressure = straightPipeFrequencyResponse(varargin)

pp = varargin;
responseType = 'n';%��Ӧ����:m M���� n:��������r,��˹����ź�
massflowData = nan;
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
param.L = 3.5+6;
param.l = 0.01;%(m)����޵����ӹܳ�
param.Dpipe = 0.098;%�ܵ�ֱ����m��
param.sectionL = 0:0.5:param.L;%linspace(0,param.L1,14);

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



pressure = straightPipePulsationCalc(param.massFlowE,param.fre,time...
    ,param.L ,param.sectionL ...
	,'D',param.Dpipe ...
    ,'a',param.acousticVelocity...
    ,'isDamping',param.isDamping...
    ,'friction',param.coeffFriction...
    ,'isOpening',param.isOpening...
    ,'meanFlowVelocity',param.meanFlowVelocity...
    ,'notMach',param.notMach...
    );

end

