%% �ڲ�ܵ���������
function theoryDataCells = PerforateClosePulsationChangedp(param,rang,varargin)
pp = varargin;

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
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2];
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.l  =  0.01;%(m)����޵����ӹܳ�
param.Dv = 0.372;%����޵�ֱ����m��
param.Lv1 = 1.1/2;%�����ǻ1�ܳ�
param.Lv2 =  1.1/2;
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



baseFrequency = 14;
multFreTimes = 3;
semiFreTimes = 3;
massflowData = nan;
isFast = true;
allowDeviation = 0.5;
fixFunPtr = [];
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
		case 'fast'%���ټ��㣬�˼��㷵�ص�cellֻ��3������һ��������ѹ�����ݣ��ڶ�����ѹ���������ֵ���������Ƿ��ֵ��Ӧxֵ
			isFast = val;
		case 'fixfunptr'
            fixFunPtr = val;
        otherwise
            error('��������%s',prop);
	end
end


if isnan(massflowData)
    [massFlowRaw,time,tmp,opt.meanFlowVelocity] = massFlowMaker(0.25,0.098,param.rpm...
        ,0.14,1.075,param.outDensity,'rcv',0.15,'k',1.4,'pr',0.15,'fs',param.Fs,'oneSecond',6);
    clear tmp;
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




dcpss = getDefaultCalcPulsSetStruct();
dcpss.calcSection = [0.2,0.8];
dcpss.fs = param.Fs;
dcpss.isHp = 0;
dcpss.f_pass = 7;%ͨ��Ƶ��5Hz
dcpss.f_stop = 5;%��ֹƵ��3Hz
dcpss.rp = 0.1;%�ߴ���˥��DB������
dcpss.rs = 30;%��ֹ��˥��DB������
if ~isFast
	theoryDataCells{1,1} = '����';
	theoryDataCells{1,2} = 'dataCells';
	theoryDataCells{1,3} = 'X';
	theoryDataCells{1,4} = 'input';
end
for i=1:length(rang)
	param.dp1 = rang(i);
	param.dp2 = rang(i);
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
	);
	pressure = [pressure1,pressure2];
	X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2];
	if ~isFast
		beforeAfterMeaPoint = [length(param.sectionL1),length(param.sectionL1)+1];
		%[plus,filterData] = calcPuls(pressure,dcpss);
		theoryDataCells{1+i,1} = sprintf('�ڲ��ֱ��:%g,Lin:%g,Lout:%g',param.Dinnerpipe,param.Lin,param.Lout);
		st = fun_dataProcessing(pressure...
									,'fs',param.Fs...
									,'basefrequency',baseFrequency...
									,'allowdeviation',allowDeviation...
									,'multfretimes',multFreTimes...
									,'semifretimes',semiFreTimes...
									,'beforeAfterMeaPoint',beforeAfterMeaPoint...
									,'calcpeakpeakvaluesection',nan...
									);
		if ~isempty(fixFunPtr)
			st.pulsationValue = fixFunPtr(param,st.pulsationValue);
		end
		theoryDataCells{1+i,2} = st;
		theoryDataCells{1+i,3} = X;
		theoryDataCells{1+i,4} = param;
	else
		theoryDataCells{i,1} = pressure;
		pulsV = calcPuls(pressure,dcpss);
		if ~isempty(fixFunPtr)
			pulsV = fixFunPtr(param,pulsV);
		end
		theoryDataCells{i,2} = pulsV;
		theoryDataCells{i,3} = X;
		theoryDataCells{i,4} = param;
	end
end

end
