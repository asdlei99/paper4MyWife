function res = paperPlotOrificeTheChangeOrificeD(param,massFlowERaw)
%缁樺埗瀛旀澘鍙樺瓟寰?
%
% Syntax: paperPlotOrificeTheChangeOrificeD(paramFun(input)
%
% Long description
    D = [0.25:0.05:1.5].*param.Dpipe;
    res.theRes = innerOrificTankChangD('orificd',D,'param',param,'massflowdata',massFlowERaw);
    %缁樺浘
    x = res.theRes{2,3};
    y = D.*1000;
    [X,Y] = meshgrid(x,y);
    for i=2:size(res.theRes,1)
        Z(i-1,:) = res.theRes{i,2}.pulsationValue;
    end
    Z = Z./1000;
    
    if 0
        figure
        paperFigureSet('small',6);
        contourfSmooth(X,Y,Z);
        xlabel('管线距离(m)','FontSize',paperFontSize());
        ylabel('孔管大小(mm)','FontSize',paperFontSize());
        colorbar;
    end
    %截取末端
    figure
    paperFigureSet('small',6);
    hold on;
    plot(y,Z(:,end));
    xlabel('孔管大小(mm)','FontSize',paperFontSize());
    ylabel('压力脉动峰峰值(kPa)','FontSize',paperFontSize());
end
