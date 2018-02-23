function paperPlotDoubleVesselExpSimThe(expCombineData,simDataCells,param,isSaveFigure)
%双罐的理论模拟实验
	freRaw = [14,21,28,42,56,70];
	massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
	massFlowDataCell = [freRaw;massFlowERaw];
	theoryDataCells = doubleVesselPulsation('param',param,'fast',1);
    paramT = doubleVesselParamToSingleVesselParam(param);
    vType = 'StraightInStraightOut';
    singleVesselRes = oneVesselPulsation('param',paramT...
                        ,'vType',vType...
                        ,'fast',true...
                        ,'massflowdata',massFlowDataCell...
                        );
    svPlus = singleVesselRes{1};
    svPlus = svPlus./1000;
    svXDis = singleVesselRes{2};
    %把中间L2的点去掉
    theoryDataCells.plus(length(param.sectionL1)+1) = [];
    theoryDataCells.X(length(param.sectionL1)+1) = [];
    %两个情况缓冲罐对应距离
    vesselRegion1 = [3.5,6];
    thePlusValue = theoryDataCells.plus;
    
    
    xSim{1} = [[2,2.5]+0.5 ,[6.5,7,7.5,8,8.5,9,9.5,10]] ;
    xExp{1} = [2.5,3,6.25,7.05,7.55,8.05,8.55,9.05,9.55,10.05];%缓冲罐串联的距离
    xThe{1} = theoryDataCells.X;
    tmp = ( xThe{1} >= vesselRegion1(1) & xThe{1} < vesselRegion1(2)) | xThe{1}<2.5;
    xThe{1}(tmp) = [];
    thePlusValue(tmp) = [];
    
    %实验对应测点
    expRangStraightLinkVessel = [1,2,4,7,8,9,10,11,12,13];
    expRangElbowLinkVessel = [1,2,4,5,6,7,8,9,10,11,12,13];
    expRang = {expRangStraightLinkVessel,expRangElbowLinkVessel};
    simRang{1} = [4:5,10:17];
    figure();
    paperFigureSet('small',6);
    fh = figureExpAndSimThePressurePlus(expCombineData...
                            ,simDataCells...
                            ,thePlusValue...
                            ,'showMeasurePoint',true ...
                            ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                            ,'expRang',expRang,'simRang',simRang...
                            ,'showVesselRigion',0,'ylim',[0,30]...
                            ,'xlim',[2,11]);
    hold on;
    plot(svXDis,svPlus);
    fixSmallFigurePosition();
    regionHandle = plotVesselRegion(fh.gca,vesselRegion1);
end
