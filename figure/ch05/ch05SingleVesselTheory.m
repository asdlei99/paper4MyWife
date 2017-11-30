%% 第五章 绘图 - 单一缓冲罐理论扩展分析
clear all;
close all;
clc;
if 1
    freRaw = [7,14,21,28,14*3];
    massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
    Dpipe = 0.098;
    Dv = 0.372;
    %% 缓冲罐改变体积对气流脉动的影响
    Vmin = pi* Dpipe^2 / 4 * 1.1 *1.5;
    Vmid = pi* Dv^2 / 4 * 1.1;
    Vmax = Vmid*3;
    VApi618 = 0.1;
    V = Vmin:0.02:Vmax;
    chartTypeChangVolume = 'surf';
    theoryDataCellsStraightInStraightOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','StraightInStraightOut');
    theoryDataCellsBiasInBiasOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','BiasInBiasOut');
    theoryDataCellsEqualBiasInOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','EqualBiasInOut');
    theoryDataCellsBiasFontInStraightOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','BiasFontInStraightOut');
    theoryDataCellsStraightInBiasBackOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','StraightInBiasBackOut');
    theoryDataCellsStraightInBiasFrontOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','StraightInBiasFrontOut');
    titles = {'直进直出','侧进侧出','侧前进侧前出','侧前进直出','直进侧后出','直进侧前出'};
    plotDatasCell{1,1} = theoryDataCellsStraightInStraightOut(2:end,3);
    plotDatasCell{1,2} = theoryDataCellsStraightInStraightOut(2:end,2);
    plotDatasCell{2,1} = theoryDataCellsBiasInBiasOut(2:end,3);
    plotDatasCell{2,2} = theoryDataCellsBiasInBiasOut(2:end,2);
    plotDatasCell{3,1} = theoryDataCellsEqualBiasInOut(2:end,3);
    plotDatasCell{3,2} = theoryDataCellsEqualBiasInOut(2:end,2);
    plotDatasCell{4,1} = theoryDataCellsBiasFontInStraightOut(2:end,3);
    plotDatasCell{4,2} = theoryDataCellsBiasFontInStraightOut(2:end,2);
    plotDatasCell{5,1} = theoryDataCellsStraightInBiasBackOut(2:end,3);
    plotDatasCell{5,2} = theoryDataCellsStraightInBiasBackOut(2:end,2);
    plotDatasCell{6,1} = theoryDataCellsStraightInBiasFrontOut(2:end,3);
    plotDatasCell{6,2} = theoryDataCellsStraightInBiasFrontOut(2:end,2);

    sectionXDatas = {};
    sectionX = [2,7,10];
    markSectionXLabel = {'b','c','d'};
    figure
    paperFigureSet_large(12);
    for i=1:size(plotDatasCell,1)
        subplot(3,2,i)
        fh = figureTheoryPressurePlus(plotDatasCell{i,2},plotDatasCell{i,1},'Y',V...
        ,'yLabelText','体积'...
        ,'chartType',chartTypeChangVolume...
        ,'edgeColor','none'...
        ,'sectionY',Vmid...
        ,'markSectionY','all'...
        ,'markSectionYLabel',{'a'}...
        ,'sectionX',sectionX ...
        ,'markSectionX','all'...
        ,'markSectionXLabel',markSectionXLabel...
        ,'fixAxis',1 ...
        ,'newFigure',0 ...
        );
        view(-161,37);
        sectionXDatas{i} = fh.sectionXHandle.data;
    end
    %绘制sectionX对应截面的图形
    for i=1:length(sectionX)
        figure
        paperFigureSet_normal();
        hold on;
        for j=1:length(sectionXDatas)
            x = sectionXDatas{j}.y;
            y = sectionXDatas{j}.z;
            h(j) = plot(x,y,'color',getPlotColor(j),'marker',getMarkStyle(j));
        end
        box on;
        legend(h,titles);
        hm = plotXMarkerLine(Vmid,':k');
        hm = plotXMarkerLine(VApi618,'--r');
        xlabel('缓冲罐体积(m^3)','FontName',paperFontName(),'FontSize',paperFontSize());
        ylabel('脉动峰峰值(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
    end
%highLowColorbar();
end

%% 单一缓冲罐变长径比对气流脉动的影响
if 0
    Lv = 0.5:0.1:3;


    theoryDataCellsChangLengthDiameterRatio = oneVesselChangLengthDiameterRatio('massflowdata',[freRaw;massFlowERaw]...
                                                        ,'Lv',Lv...
                                                        );
    resChangLengthDiameterRatio = theoryDataCellsChangLengthDiameterRatio(2:end,2);
    XChangLengthDiameterRatio = theoryDataCellsChangLengthDiameterRatio(2:end,3);
    r = 1.1 / 0.372;
    for i=2:size(theoryDataCellsChangLengthDiameterRatio,1)
       % labels{i-1} = sprintf('%g,(Lv:%g)',theoryDataCellsChangLengthDiameterRatio{i,6},theoryDataCellsChangLengthDiameterRatio{i,4});
        YChangLengthDiameterRatio(i-1) = theoryDataCellsChangLengthDiameterRatio{i,6};
    end
    fh = figureTheoryPressurePlus(resChangLengthDiameterRatio,XChangLengthDiameterRatio...
        ,'Y',YChangLengthDiameterRatio...
        ,'yLabelText','长径比'...
        ,'chartType','surf'...
        ,'edgeColor','none'...
        ,'sectionY',r...
        ,'markSectionY','all'...
        ,'markSectionYLabel',{'a'}...
    );
    view(-41,20);
    highLowColorbar();
end
%% 缓冲罐改变接管位置对气流脉动的影响
if 0
    theoryDataCellsChangL1 = oneVesselChangL1FixL('massflowdata',[freRaw;massFlowERaw]);
    resChangL1 = theoryDataCellsChangL1(2:end,2);
    XChangL1 = theoryDataCellsChangL1(2:end,3);
    YChangL1 = cell2mat(theoryDataCellsChangL1(2:end,4));
    fh = figureTheoryPressurePlus(resChangL1,XChangL1...
        ,'Y',YChangL1...
        ,'yLabelText','缓冲罐距压缩机出口距离(m)'...
        ,'chartType','contourf'...
        ,'edgeColor','none'...
        ,'figureheight',8 ...
    );
    set(fh.plotHandle,'ShowText','on');
    plot([YChangL1(1),YChangL1(end)],[YChangL1(1),YChangL1(end)],'--r');
    box on;
    colorbar;
end
