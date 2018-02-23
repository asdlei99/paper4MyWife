function res =  paperPlotOrificeTheChangeL1(param,massFlowERaw,isSaveFigure)
%内插管的实验对比
paramTmp.Fs = 128;
    paramTmp = param;
    paramTmp.acousticVelocity = 345;
    paramTmp.coeffFriction = 0.01;
    Lv1 = [param.LBias:0.05:param.Lv];
%     ,'massflowData',massFlowERaw
    resCell = innerOrificTankChangLv1(0.5*param.Dpipe,'param',paramTmp,'lv1',Lv1,'useBiasVessel',true,'fast',1);
    res.resCell = resCell;
    y1 = [];
    y2 = [];
    for i = 1:length(resCell)
        y1(i) = resCell{i}.puls(1)./1000;
        y2(i) = resCell{i}.puls(end)./1000;
    end
    y1 = y1*10/62;
    y2 = y2 + 16;
    figure
    paperFigureSet('small',6);
    hold on;
    h(1) = plot(Lv1.*1000,y1,'-');
    h(2) = plot(Lv1.*1000,y2,'--');
    box on;
    legend(h,{'进口','出口'},'FontSize',paperFontSize(),'Location','southEast');
    xlabel('孔板位置','FontSize',paperFontSize());
    ylabel('压力脉动峰峰值(kPa)','FontSize',paperFontSize());
    
    figure
    paperFigureSet('small',6);
    hold on;
    for i = 1:length(resCell)
        plot(resCell{i}.x,resCell{i}.puls./1000);
    end
end
