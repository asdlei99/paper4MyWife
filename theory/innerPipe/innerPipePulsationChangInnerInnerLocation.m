%% 内插管的气流脉动改变内插管管径Dinnerpipe
function theoryDataCells = innerPipePulsationChangInnerInnerLocation(Lv1,varargin)
pp = varargin;

param.acousticVelocity = 345;%声速（m/s）
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv1 = 1.1/2;
param.Lv2 = 1.1/2;
Lv = param.Lv1 + param.Lv2;
param.l = 0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%管道直径（m）
param.Lbias = 0.168+0.150;
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2];
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.Lin = 200;
param.Lout = 200;
param.Dinnerpipe = param.Dpipe;
param.isOpening = false;
baseFrequency = 14;
multFreTimes = 3;
semiFreTimes = 3;
massflowData = nan;
isFast = false;
allowDeviation = 0.5;
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
		case 'fast'%快速计算，此计算返回的cell只有3个，第一个是所有压力数据，第二个是压力脉动峰峰值，第三个是峰峰值对应x值
			isFast = val;
        otherwise
            error('错误属性%s',prop);
	end
end
Lv = param.Lv1 + param.Lv2;

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
dcpss.f_pass = 7;%通过频率5Hz
dcpss.f_stop = 5;%截止频率3Hz
dcpss.rp = 0.1;%边带区衰减DB数设置
dcpss.rs = 30;%截止区衰减DB数设置
if ~isFast
	theoryDataCells{1,1} = '描述';
	theoryDataCells{1,2} = 'dataCells';
	theoryDataCells{1,3} = 'X';
	theoryDataCells{1,4} = 'Lv1';
	theoryDataCells{1,5} = 'input';
end
for i=1:length(Lv1)
	param.Lv1 = Lv1(i);
	param.Lv2 = Lv - param.Lv1;
	[pressure1,pressure2] = innerPipeVesselInBiasPulsationCalc(param.massFlowE,param.fre,time...
	,param.L1,param.L2,param.Dpipe,param.Dv...
	,param.Lin,param.Lout,param.Dinnerpipe...
	,param.Lv1,param.Lv2,param.l,param.Lbias...
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
		theoryDataCells{i+1,1} = sprintf('内插管直径:%g,Lin:%g,Lout:%g',param.Dinnerpipe,param.Lin,param.Lout);
		theoryDataCells{i+1,2} = fun_dataProcessing(pressure...
									,'fs',param.Fs...
									,'basefrequency',baseFrequency...
									,'allowdeviation',allowDeviation...
									,'multfretimes',multFreTimes...
									,'semifretimes',semiFreTimes...
									,'beforeAfterMeaPoint',beforeAfterMeaPoint...
									,'calcpeakpeakvaluesection',nan...
									);
		theoryDataCells{i+1,3} = X;
		theoryDataCells{i+1,4} = Lv1(i);
		theoryDataCells{i+1,5} = param;
	else
		theoryDataCells{i,1} = pressure;
		theoryDataCells{i,2} = calcPuls(pressure,dcpss);
		theoryDataCells{i,3} = X;
	end
end





end
