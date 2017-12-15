%% ������ ��ͼ - ��һ�����������չ����
clear all;
close all;
clc;
%% ����޼���Ĳ�������
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 345;%���٣�m/s��
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 10;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv = 1.1;
param.l = 0.01;%(m)����޵����ӹܳ�
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%�ܵ�ֱ����m��
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];
lvLen = 0.318;
param.lv1 = lvLen;
param.lv2 = lvLen;
if 1
    coeffFriction = 0.03;
    meanFlowVelocity = 12;
    coeffFrictionBias = 0.03;
    meanFlowVelocityBias = 10;
    
    param.coeffFriction = coeffFriction;
    param.meanFlowVelocity = meanFlowVelocity;
    
    freRaw = [14,21,28,42,56,70];
    massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
%     freRaw = [7,14,21,28,14*3];
%     massFlowERaw = [0.02,0.2,0.03,0.003,0.007];

    %% ����޸ı����������������Ӱ��
    Vmin = pi* param.Dpipe^2 / 4 * param.Lv *1.5;
    Vmid = pi* param.Dv^2 / 4 * param.Lv;
    Vmax = Vmid*3;
    VApi618 = 0.1;
    V = Vmin:0.02:Vmax;
    chartTypeChangVolume = 'surf';
    theoryDataCellsStraightInStraightOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','StraightInStraightOut'...
                                                        ,'param',param);
    param.coeffFriction = coeffFrictionBias;
    param.meanFlowVelocity = meanFlowVelocityBias;
    theoryDataCellsBiasInBiasOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','BiasInBiasOut'...
                                                        ,'param',param);
    param.coeffFriction = coeffFrictionBias;
    param.meanFlowVelocity = meanFlowVelocityBias;
    theoryDataCellsEqualBiasInOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','EqualBiasInOut'...
                                                        ,'param',param);
    param.meanFlowVelocity = meanFlowVelocity;
    param.coeffFriction = coeffFriction;
    theoryDataCellsBiasFontInStraightOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','BiasFontInStraightOut'...
                                                        ,'param',param);
    param.lv1 = param.Lv - lvLen;
    theoryDataCellsStraightInBiasBackOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','straightInBiasOut'...
                                                        ,'param',param);
    param.lv1 = lvLen;
    theoryDataCellsStraightInBiasFrontOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','straightInBiasOut'...
                                                        ,'param',param);
    param.meanFlowVelocity = meanFlowVelocityBias;
    param.coeffFriction = coeffFrictionBias;
    theoryDataCellsBiasFrontInBiasFrontOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','BiasFrontInBiasFrontOut'...
                                                        ,'param',param);
    if 0
        titles = {'ֱ��ֱ��','������','���н����г�','��ǰ��ֱ��','ֱ������','ֱ����ǰ��','��ǰ����ǰ��'};
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
        plotDatasCell{7,1} = theoryDataCellsBiasFrontInBiasFrontOut(2:end,3);
        plotDatasCell{7,2} = theoryDataCellsBiasFrontInBiasFrontOut(2:end,2);
    else
        titles = {'ֱ��ֱ��','��ǰ��ֱ��','ֱ������','ֱ����ǰ��'};
        plotDatasCell{1,1} = theoryDataCellsStraightInStraightOut(2:end,3);
        plotDatasCell{1,2} = theoryDataCellsStraightInStraightOut(2:end,2);
        plotDatasCell{2,1} = theoryDataCellsBiasFontInStraightOut(2:end,3);
        plotDatasCell{2,2} = theoryDataCellsBiasFontInStraightOut(2:end,2);
        plotDatasCell{3,1} = theoryDataCellsStraightInBiasBackOut(2:end,3);
        plotDatasCell{3,2} = theoryDataCellsStraightInBiasBackOut(2:end,2);
        plotDatasCell{4,1} = theoryDataCellsStraightInBiasFrontOut(2:end,3);
        plotDatasCell{4,2} = theoryDataCellsStraightInBiasFrontOut(2:end,2);

    end
    sectionXDatas = {};
    sectionX = [2,7,10];
    markSectionXLabel = {'b','c','d'};
    figure
    paperFigureSet_large(12);
    for i=1:size(plotDatasCell,1)
        subplot(3,3,i)
        fh = figureTheoryPressurePlus(plotDatasCell{i,2},plotDatasCell{i,1},'Y',V...
        ,'yLabelText','���'...
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
    %����sectionX��Ӧ�����ͼ��
    for i=1:length(sectionX)
        figure
        paperFigureSet_normal();
        hold on;
        for j=1:length(sectionXDatas)
            x = sectionXDatas{j}(i).y;
            y = sectionXDatas{j}(i).z;
            h(j) = plot(x,y,'color',getPlotColor(j),'marker',getMarkStyle(j));
        end
        box on;
        legend(h,titles);
        hm = plotXMarkerLine(Vmid,':k');
        hm = plotXMarkerLine(VApi618,'--r');
        xlabel('��������(m^3)','FontName',paperFontName(),'FontSize',paperFontSize());
        ylabel('�������ֵ(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
        title(sprintf('�����%g',sectionX(i)));
    end
    
    %����������
    figure
    paperFigureSet_normal(7);
    hold on;
    count = 1;
    h = [];
    for i = 2:size(plotDatasCell,1)
        for j = 1:size(plotDatasCell{i,2})
            pv(j) = plotDatasCell{i, 2}{j, 1}.pulsationValue(1);
            psv(j) = plotDatasCell{1, 2}{j, 1}.pulsationValue(1);
            sr(j) = ((psv(j) - pv(j))/pv(j))*100;
        end
        h(count) = plot(V,sr);
        count = count + 1;
    end
    legend(h,titles(2:end));
    xlabel('���V(m)');
    ylabel('����������(%)');
    box on;
%highLowColorbar();
end

%�ı����Խ����Ӱ��
if 1
    coeffFriction = 0.03;
    meanFlowVelocity = 12;
    coeffFrictionBias = 0.03;
    meanFlowVelocityBias = 10;
    
    param.coeffFriction = coeffFriction;
    param.meanFlowVelocity = meanFlowVelocity;
    
    freRaw = [14,21,28,42,56,70];
    massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
%     freRaw = [7,14,21,28,14*3];
%     massFlowERaw = [0.02,0.2,0.03,0.003,0.007];

    chartTypeChangVolume = 'surf';
    L1 = 0.25:0.25:5;
    L = 9.5;
    theoryDataCellsStraightInStraightOut = oneVesselChangL1FixL(L1,L,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','StraightInStraightOut'...
                                                        ,'param',param);
    param.coeffFriction = coeffFrictionBias;
    param.meanFlowVelocity = meanFlowVelocityBias;
    theoryDataCellsBiasInBiasOut = oneVesselChangL1FixL(L1,L,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','BiasInBiasOut'...
                                                        ,'param',param);
    param.coeffFriction = coeffFrictionBias;
    param.meanFlowVelocity = meanFlowVelocityBias;
    theoryDataCellsEqualBiasInOut = oneVesselChangL1FixL(L1,L,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','EqualBiasInOut'...
                                                        ,'param',param);
    param.meanFlowVelocity = meanFlowVelocity;
    param.coeffFriction = coeffFriction;
    theoryDataCellsBiasFontInStraightOut = oneVesselChangL1FixL(L1,L,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','BiasFontInStraightOut'...
                                                        ,'param',param);
    param.lv1 = param.Lv - lvLen; 
    theoryDataCellsStraightInBiasBackOut = oneVesselChangL1FixL(L1,L,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','StraightInBiasOut'...
                                                        ,'param',param);
    param.lv1 = lvLen;
    theoryDataCellsStraightInBiasFrontOut = oneVesselChangL1FixL(L1,L,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','StraightInBiasOut'...
                                                        ,'param',param);
    param.meanFlowVelocity = meanFlowVelocityBias;
    param.coeffFriction = coeffFrictionBias;
    theoryDataCellsBiasFrontInBiasFrontOut = oneVesselChangL1FixL(L1,L,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType','BiasFrontInBiasFrontOut'...
                                                        ,'param',param);
    if 0
        titles = {'ֱ��ֱ��','������','���н����г�','��ǰ��ֱ��','ֱ������','ֱ����ǰ��','��ǰ����ǰ��'};
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
        plotDatasCell{7,1} = theoryDataCellsBiasFrontInBiasFrontOut(2:end,3);
        plotDatasCell{7,2} = theoryDataCellsBiasFrontInBiasFrontOut(2:end,2);
    else
        titles = {'ֱ��ֱ��','��ǰ��ֱ��','ֱ������','ֱ����ǰ��'};
        plotDatasCell{1,1} = theoryDataCellsStraightInStraightOut(2:end,3);
        plotDatasCell{1,2} = theoryDataCellsStraightInStraightOut(2:end,2);
        plotDatasCell{2,1} = theoryDataCellsBiasFontInStraightOut(2:end,3);
        plotDatasCell{2,2} = theoryDataCellsBiasFontInStraightOut(2:end,2);
        plotDatasCell{3,1} = theoryDataCellsStraightInBiasBackOut(2:end,3);
        plotDatasCell{3,2} = theoryDataCellsStraightInBiasBackOut(2:end,2);
        plotDatasCell{4,1} = theoryDataCellsStraightInBiasFrontOut(2:end,3);
        plotDatasCell{4,2} = theoryDataCellsStraightInBiasFrontOut(2:end,2);
    end
    measurePoint = [1,5,13];
    for mea = measurePoint
        figure
        paperFigureSet_normal(7);
        hold on;
        count = 1;
        h = [];
        for i = 2:size(plotDatasCell,1)
            for j = 1:size(plotDatasCell{i,2})
                pv(j) = plotDatasCell{i, 2}{j, 1}.pulsationValue(mea);
                psv(j) = plotDatasCell{1, 2}{j, 1}.pulsationValue(mea);
                sr(j) = ((psv(j) - pv(j))/pv(j))*100;
            end
            h(count) = plot(L1,sr);
            count = count + 1;
        end
        legend(h,titles(2:end));
        xlabel('����L1(m)');
        ylabel('����������(%)');
        box on;
    end
end

%% ��һ����ޱ䳤���ȶ�����������Ӱ��
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
        ,'yLabelText','������'...
        ,'chartType','surf'...
        ,'edgeColor','none'...
        ,'sectionY',r...
        ,'markSectionY','all'...
        ,'markSectionYLabel',{'a'}...
    );
    view(-41,20);
    highLowColorbar();
end
%% ����޸ı�ӹ�λ�ö�����������Ӱ��
if 0
    theoryDataCellsChangL1 = oneVesselChangL1FixL('massflowdata',[freRaw;massFlowERaw]);
    resChangL1 = theoryDataCellsChangL1(2:end,2);
    XChangL1 = theoryDataCellsChangL1(2:end,3);
    YChangL1 = cell2mat(theoryDataCellsChangL1(2:end,4));
    fh = figureTheoryPressurePlus(resChangL1,XChangL1...
        ,'Y',YChangL1...
        ,'yLabelText','����޾�ѹ�������ھ���(m)'...
        ,'chartType','contourf'...
        ,'edgeColor','none'...
        ,'figureheight',8 ...
    );
    set(fh.plotHandle,'ShowText','on');
    plot([YChangL1(1),YChangL1(end)],[YChangL1(1),YChangL1(end)],'--r');
    box on;
    colorbar;
end
