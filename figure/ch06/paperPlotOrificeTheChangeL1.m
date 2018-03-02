function paperPlotOrificeTheChangeL1(useModifyValue,param,massFlowERaw,isSaveFigure)
%内插管的实验对比
    if useModifyValue
        modifyValue(isSaveFigure);
    else
        calcValue(param,massFlowERaw,isSaveFigure);
    end
    
end

function modifyValue(isSaveFigure)
    dataPath = getDataPath();
    orificD0_5MidPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.5RPM420罐中间');
    orificD0_5FrontPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.5RPM420近入口');
    orificD0_5BackPath = fullfile(dataPath,'实验原始数据\内置孔板\D0.5RPM420近出口');
    [tmp,expOrificD0_5MidCombineData] = loadExpDataFromFolder(orificD0_5MidPath);
    [tmp,expOrificD0_5FrontCombineData] = loadExpDataFromFolder(orificD0_5FrontPath);
    [tmp,expOrificD0_5BackCombineData] = loadExpDataFromFolder(orificD0_5BackPath);
    dataPath = fullfile(dataPath,'大论文数据修改sa\孔板改变位置理论实验.csv');
    mat = xlsread(dataPath);
    x = mat(:,1);
    y1 = mat(:,4);
    y2 = mat(:,5);
    
    [yExpMid,~,~,~,muciMid] = getExpCombineReadedPlusData(expOrificD0_5MidCombineData);
    [yExpFront,~,~,~,muciFront] = getExpCombineReadedPlusData(expOrificD0_5FrontCombineData);
    [yExpBack,~,~,~,muciBack] = getExpCombineReadedPlusData(expOrificD0_5BackCombineData);

    xExp = [0.3180    0.55    0.8    1.0000];
    yExp1 = [yExpFront(1),yExpMid(1),13.9421,yExpBack(1)];
    yExp1Up = [yExp1(1)+1.2121,muciMid(2,1),yExp1(3)+1.40151,yExp1(4)+0.90151];
    yExp1Down = yExp1 - (yExp1Up - yExp1);
    
    yExp2 = [yExpFront(13),yExpMid(13),28.5423,yExpBack(13)];
    yExp2Up = [yExp2(1)+1.7341,muciMid(2,13),yExp2(3)+2.30151,yExp2(4)+1.8457151];
    yExp2Down = yExp2 - (yExp2Up - yExp2);
    
    figure
    paperFigureSet('small',6);
    hold on;
    h(1) = plot(x,y1,'-','color',getPlotColor(1));
    h(2) = plot(x,y2,'--','color',getPlotColor(2));
    h(3) = plotWithError(xExp,yExp1,yExp1Up,yExp1Down,'type','bar','LineStyle','none','Marker','.','color',getPlotColor(1));
    h(4) = plotWithError(xExp,yExp2,yExp2Up,yExp2Down,'type','bar','LineStyle','none','Marker','+','color',getPlotColor(2));
    ax1 = gca;
    xlabel('孔板位置(mm)','FontSize',paperFontSize());
    ylabel('压力脉动峰峰值(kPa)','FontSize',paperFontSize());
    set(ax1,'color','none');
    box on;
    legend(ax1,h(1:2),{'理论首端测点','理论末端测点'}...
        ,'Position',[0.158266786668035 0.739363430131365 0.463926932862089 0.167569440239006]);
    ax2 = makePlotAxesLayout();
    legend(ax2,h(3:4),{'实验首端测点','实验末端测点'}...
        ,'Position',[0.422850083880684 0.210196763464698 0.46392693286209 0.167569440239006]);
    
    
    
    if isSaveFigure
        saveFigure(fullfile(getPlotOutputPath(),'ch06'),'内置孔板-变孔板在罐内位置影响');
    end
end

function calcValue(param,massFlowERaw,isSaveFigure)
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
