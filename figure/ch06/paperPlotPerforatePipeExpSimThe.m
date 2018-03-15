function paperPlotPerforatePipeExpSimThe(param,expDataCells,simDataCells,isSaveFigure)
%孔管的理论计算
	freRaw = [7,14,21,28,42,56,70];
	massFlowERaw = [0.02,0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
	massFlowDataCell = [freRaw;massFlowERaw];
	xExp = constExpMeasurementPointDistance();
	xSim = constSimMeasurementPointDistance();
    
    
	param.n1 = 24;
	param.n2 = 24;
	expRes = expDataCells{1};
	simRes = simDataCells{1};
	theCell = PerforateClosePulsation('param',param,'massflowdata',massFlowDataCell...
        ,'fast',1,'fixFunPtr',@fixTheoryPerforate);
	theRes = theCell{1,2};
%     
%     theRes(1:length(param.sectionL1)) = theRes(1:length(param.sectionL1)) + ( 3000/2.5 * param.sectionL1);
% 	theRes(param.sectionL1 >=3 & param.sectionL1<=3.5) = ...
%         theRes(param.sectionL1 >=3 & param.sectionL1<=3.5)-(1000+6000.*(param.sectionL1(param.sectionL1 >=3 & param.sectionL1<=3.5)-3));
%     
    xThe = theCell{1,3};
	plotPerforatePipeN24(expRes,simRes,theRes,xExp,xSim,xThe,isSaveFigure);
end

function plotPerforatePipeN24(expRes,simRes,theRes,xExp,xSim,xThe,isSaveFigure)
	figure('Name','N24');
    paperFigureSet('small',6);
	expVesselRang = constExpVesselRangDistance;
	fh = figureExpAndSimThePressurePlus(expRes...
                            ,simRes...
                            ,theRes...
                            ,{''}...
                            ,'showMeasurePoint',1 ...
                            ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                            ,'showVesselRigion',1 ...
                            ,'xlim',[2,11]...
                            ,'figureHeight',9 ...
                            ,'expVesselRang',expVesselRang);
    if isSaveFigure
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch06'),'内置孔管-N24-理论模拟实验');
	end		
end