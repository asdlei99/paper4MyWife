function paperPlotOrificeExpSimThe(expCombineData,simDataCell,param,massFlowERaw,isSaveFigure )
%�װ�����ģ��ʵ��Ա�
    vesselInBiasResultCell = vesselInBiasPulsationResult('param',param,'massflowData',massFlowERaw);
    theDataCells = innerOrificTankChangD('param',param,'massflowData',massFlowERaw);
    
    x = constExpMeasurementPointDistance();%����Ӧ�ľ���
    xExp = {x,x};
    x = constSimMeasurementPointDistance();%ģ�����Ӧ�ľ���
    xSim = {x,x};
    xThe = {param.X,theDataCells{3, 3}};
    
    
    vesselInBiasResultCell.pulsationValue(1:8) = vesselInBiasResultCell.pulsationValue(1:8) + ones(1,8).*6e3;
    theDataCells{3, 2}.pulsationValue(1:8) = theDataCells{3, 2}.pulsationValue(1:8) + ones(1,8).*6e3;
    figure();
    paperFigureSet('small',6);
    fh = figureExpAndSimThePressurePlus(expCombineData...
                            ,simDataCell...
                            ,theDataCells{3, 2}...
                            ,{''}...
                            ,'showMeasurePoint',1 ...
                            ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                            ,'showVesselRigion',1,'ylim',[0,30]...
                            ,'xlim',[2,12]...
                            ,'figureHeight',9 ...
                            );
    set(fh.legend,'Position',[0.685346209609021 0.205978015633128 0.21166666477422 0.241064808506657]);
    set(fh.textarrowVessel,'X',[0.365942028985507 0.297101449275362],'Y',[0.748898678414097 0.691629955947137]);
    if isSaveFigure
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch06'),'��������ÿװ�����ģ��ʵ��');
    end


end

