%% 直管改变管径
function theoryDataCells = straightPipeChangDpipe(DPipeRang,baseDipe,baseFlowVelocity,varargin)
% DPipeRang 管径的变化范围
% baseDipe 基本管径，用于计算不同管径的流速
% baseFlowVelocity 基本流速，用于计算不同管径的流速
% DPipeRang对应的不同流速通过baseDipe和baseFlowVelocity计算
	pp = varargin;
	Dv = nan;
	Lv = nan;
	massflowData = nan;
	param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
	param.rpm = 420;
	param.outDensity = 1.5608;
	param.Fs = 4096;
	param.acousticVelocity = 345;%声速（m/s）
	param.isDamping = 1;
	param.coeffFriction = 0.03;
	param.meanFlowVelocity = 16;
	param.L1 = 3.5;%(m)
	param.L2 = 6;
	param.L = 3.5+6;
	param.l = 0.01;%(m)缓冲罐的连接管长
	param.Dpipe = 0.098;%管道直径（m）
	param.sectionL = 0:0.5:param.L;%linspace(0,param.L1,14);
	baseFrequency = 14;
	multFreTimes = 3;
	semiFreTimes = 3;
	allowDeviation = 0.5;
	fast = 0;%
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
			case 'fast'%默认0，如果指定1，进行快速计算，只返回脉动值的cell
				fast = val;
			otherwise
				error('错误属性%s',prop);
		end
	end
	%% 初始参数
	%

	if isnan(massflowData)
		[massFlowRaw,time,t,opt.meanFlowVelocity] = massFlowMaker(0.25,0.098,param.rpm...
			,0.14,1.075,param.outDensity,'rcv',0.15,'k',1.4,'pr',0.15,'fs',param.Fs,'oneSecond',6);
		clear t;%兼容旧版本的matlab
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

	if ~fast
		theoryDataCells{1,1} = '描述';
		theoryDataCells{1,2} = 'dataCells';
		theoryDataCells{1,3} = 'X';
		theoryDataCells{1,4} = '脉动值';
		theoryDataCells{1,5} = 'input';
		theoryDataCells{1,6} = '管径';
		theoryDataCells{1,7} = '流速';
	end

	for i = 1:length(DPipeRang)
		%计算流速
		param.Dpipe = DPipeRang(i);
		param.meanFlowVelocity = baseFlowVelocity * ((baseDipe)^2 / (param.Dpipe)^2);
		pressure = straightPipePulsationCalc(param.massFlowE,param.fre,time...
			,param.L ,param.sectionL ...
			,'D',param.Dpipe ...
			,'a',param.acousticVelocity...
			,'isDamping',param.isDamping...
			,'friction',param.coeffFriction...
			,'isOpening',param.isOpening...
			,'meanFlowVelocity',param.meanFlowVelocity...
			);
		if fast
			theoryDataCells.plus{i} = calcPuls(pressure,dcpss);
			theoryDataCells.X{i} = param.sectionL;
			theoryDataCells.Dpipe(i) = param.Dpipe;
			theoryDataCells.V(i) = param.meanFlowVelocity;
		else
			dc = fun_dataProcessing(pressure...
										,'fs',param.Fs...
										,'basefrequency',baseFrequency...
										,'allowdeviation',allowDeviation...
										,'multfretimes',multFreTimes...
										,'semifretimes',semiFreTimes...
										,'calcpeakpeakvaluesection',nan...
										);
			
			theoryDataCells{i+1,1} = '直管';
			theoryDataCells{i+1,2} = dc;
			theoryDataCells{i+1,3} = param.sectionL;
			theoryDataCells{i+1,4} = dc.pulsationValue;
			theoryDataCells{i+1,5} = param;
			theoryDataCells{i+1,6} = param.Dpipe;
			theoryDataCells{i+1,7} = param.meanFlowVelocity;
		end
	end

end

