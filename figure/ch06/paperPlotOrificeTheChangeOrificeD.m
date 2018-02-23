function res = paperPlotOrificeTheChangeOrificeD(param,massFlowERaw)
%?р¤Ночщ?Но
%
% Syntax: paperPlotOrificeTheChangeOrificeD(paramFun(input)
%
% Long description
    D = [0.25:0.05:1.5].*param.Dpipe;
    res.theRes = innerOrificTankChangD('orificd',D,'param',param,'massflowdata',massFlowERaw);
    %??
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
        xlabel('Ле?(m)','FontSize',paperFontSize());
        ylabel('НочщНо?(mm)','FontSize',paperFontSize());
        colorbar;
    end
    %
    figure
    paperFigureSet('small',6);
    hold on;
    plot(y,Z(:,end));
    xlabel('НочщНо?(mm)','FontSize',paperFontSize());
    ylabel('??ЬиЬи?(kPa)','FontSize',paperFontSize());
end
