function paperPlotInnerPipeExpTheSim(expDataCells,simDataCells,param,isSaveFigure)
%内插管理论模拟实验对比
	
	x = constExpMeasurementPointDistance();%
    xExp = x;
    x = constSimMeasurementPointDistance();%
    xSim = x;
    xThe = param.X;
    param.Dinnerpipe = 0.5 * param.Dpipe;
    plotInnerPipe(expDataCells{1},simDataCells{1},xExp,xSim,xThe,param,isSaveFigure,'内插管0_5D理论模拟实验对比');
%     param.Dinnerpipe = 0.75 * param.Dpipe;
%     plotInnerPipe(expDataCells{2},simDataCells{2},xExp,xSim,xThe,param,isSaveFigure,'内插管0_75D理论模拟实验对比');
%     param.Dinnerpipe = param.Dpipe;
%     plotInnerPipe(expDataCells{3},simDataCells{3},xExp,xSim,xThe,param,isSaveFigure,'内插管1D理论模拟实验对比');

end

function plotInnerPipe(expDataCells,simDataCells,xExp,xSim,xThe,param,isSaveFigure,saveName)
    figure();
    paperFigureSet('small',6);
	InnerPipeResultCell = innerPipePulsation('param',param);
	theCell = InnerPipeResultCell{2,2};
	expVesselRang = constExpVesselRangDistance();
	fh = figureExpAndSimThePressurePlus(expDataCells...
                            ,simDataCells...
                            ,theCell...
                            ,{''}...
                            ,'showMeasurePoint',1 ...
                            ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                            ,'showVesselRigion',1 ...
                            ,'xlim',[2,11]...
                            ,'figureHeight',9 ...
                            ,'expVesselRang',expVesselRang);
    set(fh.legend,'Position',[0.618142761457845 0.197324485133277 0.28995433530715 0.241064808506657]);
    set(fh.textarrowVessel,'X',[0.382876712328767 0.324885844748859]...
        ,'Y',[0.709166666666667 0.638611111111111]);
	box on;
    if isSaveFigure
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch06'),saveName);
	end
end

