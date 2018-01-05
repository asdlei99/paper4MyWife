function res = paperPlot04StraightPipeExpSimThe(straightPipeCombineData,straightPipeSimData,isSavePlot)
%绘制直管理论模拟实验
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
	freRaw = [14,21,28,42,56,70];
	massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];

	theoryDataCells = straightPipePulsation('param',param...
		,'massflowdata',[freRaw;massFlowERaw]...
	);
	res.theoryDataCells = theoryDataCells;
	theDataStruct.pulsationValue = theoryDataCells{2,3};
	
	res.fig = figure;
	paperFigureSet('normal',7);
	legnedText = {'实验','模拟','理论'};
	xSim = [0.3,0.8,1.3,1.8,2.3,2.6,2.8,3.1,3.6,4.1,4.6,5.1,5.6,5.9,6.1,6.6,7.1,7.6,8.1,8.6,9.1,9.6];
	
	fh = figureExpAndSimThePressurePlus(straightPipeCombineData...
                                ,straightPipeSimData...
                                ,theDataStruct...
                                ,{''}...
                                ,'legendPrefixLegend',legnedText...
                                ,'showMeasurePoint',1 ...
                                ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                                ,'showVesselRigion',1,'ylim',[0,40]...
                                ,'xlim',[2,12]...
                                ,'figureHeight',7 ...
                                ,'expVesselRang',expVesselRang);
	
	
end