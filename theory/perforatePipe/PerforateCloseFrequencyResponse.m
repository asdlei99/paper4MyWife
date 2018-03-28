%% �׹�ɨƵɨƵ
function pressure = PerforateCloseFrequencyResponse(varargin)
pp = varargin;
responseType = 'n';%��Ӧ����:m M���� n:��������r,��˹����ź�

%% ����·��
%������м����׹�,���˶��������׸��������Ե�ЧΪ��ķ���ȹ�����,��������ƫ��
%                 L1
%                     |
%                     |
%           l   LBias |                                    L2  
%              _______|_________________________________        
%             |    dp(n1)            |    dp(n2)        |
%             |           ___ _ _ ___|___ _ _ ___ lc    |     
%             |          |___ _ _ ___ ___ _ _ ___|Din   |----------
%             |           la1 lp1 la2|lb1 lp2 lb2       |
%             |______________________|__________________|       
%                             Lin         Lout          l
%                       Lv1                  Lv2
%    Dpipe                       Dv                     Dpipe             
%           
%
% Lin �ڲ�׹���ڶγ��� 
% Lout�ڲ�׹ܳ��ڶγ���
% lc  �׹ܱں�
% dp  �׹�ÿһ���׿׾�
% n1  �׹���ڶο��׸�����    n2  �׹ܳ��ڶο��׸���
% la1 �׹���ڶξ���ڳ��� 
% la2 �׹���ڶξ���峤��
% lb1 �׹ܳ��ڶξ���峤��
% lb2 �׹ܳ��ڶξ࿪�׳���
% lp1 �׹���ڶο��׳���
% lp2 �׹ܳ��ڶο��׳���
% Din �׹ܹܾ���
% xSection1��xSection2 �׹�ÿȦ�׵ļ�࣬��0��ʼ�㣬x�ĳ���Ϊ�׹ܿ׵�Ȧ��+1��x��ֵ�ǵ�ǰһȦ�׺���һȦ�׵ľ��룬������һ������ôx���ֵ��һ��
param.acousticVelocity = 345;%���٣�m/s��
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
param.L1 = 3.5;%(m)
param.L2 = 6;

param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%�ܵ�ֱ����m��
param.Lbias = 0.168+0.150;
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.l  =  0.01;%(m)����޵����ӹܳ�
param.Dv = 0.372;%����޵�ֱ����m��
param.Lv1 = 1.1/2;%�����ǻ1�ܳ�
param.Lv2 =  1.1/2;
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2];
%
param.lc   = 0.005;%�ڲ�ܱں�
param.dp1  = 0.013;%���׾�
param.dp2  = 0.013;%���׾�
param.lp1  = 0.16;%�ڲ����ڶηǿ׹ܿ��׳���
param.lp2  = 0.16;%�ڲ�ܳ��ڶο׹ܿ��׳���
param.n1   = 24;%��ڶο���
param.n2   = 24;%���ڶο���
param.la1  = 0.03;%�׹���ڶο�����ڳ���
param.la2  = 0.06;
param.lb1  = 0.06;
param.lb2  = 0.03;
param.Din  = 0.049;
param.Lout = param.lb1 + param.lp2+ param.lb2;%�ڲ����ڶγ���
param.bp1 = calcPerforatingRatios(param.n1,param.dp1,param.Din,param.lp1);
param.bp2 = calcPerforatingRatios(param.n2,param.dp2,param.Din,param.lp2);
param.Lin  = param.la1 + param.lp1+ param.la2;%�ڲ����ڶγ���
param.LBias = (0.150+0.168);%232
param.Dbias = 0;%���ڲ��
param.sectionNum1 = [1];%��Ӧ��1������
param.sectionNum2 = [1];%��Ӧ��2������
param.xSection1 = [0,ones(1,param.sectionNum1).*(param.lp1/(param.sectionNum1))];
param.xSection2 = [0,ones(1,param.sectionNum2).*(param.lp2/(param.sectionNum2))];
param.pressureBoundary2 = 0;

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
index = find(param.fre == 0);
param.fre(index) = [];
param.massFlowE(index) = [];

[pressure1,pressure2] = vesselInBiasHaveInnerPerfBothClosedCompCalc(param.massFlowE,param.fre,time...
	,param.L1,param.L2,param.Dpipe,param.Dv,param.l...
	,param.Lv1,param.Lv2,param.lc,param.dp1,param.dp2,param.lp1,param.lp2...
	,param.n1,param.n2,param.la1,param.la2,param.lb1...
	,param.lb2,param.Din,param.Dbias...
	,param.LBias,param.xSection1,param.xSection2...
	,param.sectionL1,param.sectionL2...
	,'a',param.acousticVelocity...
	,'isDamping',param.isDamping...
	,'friction',param.coeffFriction...
	,'meanFlowVelocity',param.meanFlowVelocity...
	,'isOpening',param.isOpening...
    ,'pressureBoundary2',param.pressureBoundary2...
);
pressure = [pressure1,pressure2];

end

