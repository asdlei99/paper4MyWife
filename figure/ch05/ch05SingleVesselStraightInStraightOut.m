%% ������ ��ͼ - ��һ�����ֱ��ֱ��
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% ����·��
vesselSideFontInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\RPM420');%��ǰ��ֱ���
vesselDirectInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ��ֱ��420ת0.05mpaModify');
vesselDirectPipeCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\��ֱ��\RPM420-0.1Mpa\');
%% �����м�װ��Լ����������
[vesselSideFontInDirectOutDataCells,vesselSideFontInDirectOutCombineData] ...
    = loadExpDataFromFolder(vesselSideFontInDirectOutCombineDataPath);
[vesselDirectInDirectOutDataCells,vesselDirectInDirectOutCombineData,vesselDirectInDirectOutSimData] ...
    = loadExpAndSimDataFromFolder(vesselDirectInDirectOutCombineDataPath);
[vesselDirectPipeDataCells,vesselDirectPipeCombineData] ...
    = loadExpDataFromFolder(vesselDirectPipeCombineDataPath);

%% ʵ�����ݻ�ͼ
if 0
    singleVesselExpPlot({vesselDirectInDirectOutCombineData}...
        ,vesselDirectPipeCombineData,{'ֱ��ֱ��','ֱ��'}...
        ,'dataCells',vesselDirectInDirectOutDataCells ...
        ,'errorTypeInExp','ci'...
        ,'plusValueSubplot',0);
end
%% ��ֱ�ܶԱȵ�ѹ������������
if 0
    paperFigureSet('large',7);
    subplot(1,2,1)
    vesselCombineDataCells = {vesselDirectInDirectOutCombineData,vesselDirectPipeCombineData};
    leg = {'ֱ��ֱ��','ֱ��'};
    fh = figureExpPressurePlus(vesselCombineDataCells,leg...
        ,'errorType',errorType...
        ,'isFigure',0 ...
        ,'showMeasurePoint',0 ...
        ,'showPureVessel',0);
    set(fh.legend,...
        'Position',[0.1153739912604 0.76217277447996 0.256448925406267 0.143630948776291]);
    set(fh.textarrowVessel,'X',[0.209092261904762 0.171879960317461],'Y',[0.645654761904762 0.579482886904763]);
    title('(a)','fontSize',paperFontSize());
    set(fh.gca,'Position',[0.0900297619047619 0.164779870052758 0.368526785714286 0.758490572110661]);
    set(gca,'color','none');
    
    subplot(1,2,2)
    ddMean = mean(vesselDirectPipeCombineData.readPlus);
    ddMean = ddMean(1:13);
    suppressionRateBase = {ddMean};
    xlabelText = '���߾���(m)';
    ylabelText = 'ѹ������������(%)';
    fh = figureExpPressurePlusSuppressionRate(vesselDirectInDirectOutCombineData...
            ,'errorPlotType','bar'...
            ,'showVesselRigon',0 ...
            ,'suppressionRateBase',suppressionRateBase...
            ,'isFigure',0 ...
            ,'showMeasurePoint',0 ...
            ,'xIsMeasurePoint',0 ...
            ,'xlabelText',xlabelText...
            ,'ylabelText',ylabelText...
            );
    box on;
    set(fh.gca...
        ,'Position',[0.588958333333333 0.164779870052758 0.368526785714287 0.758490572110663]);
    title('(b)','fontSize',paperFontSize());
    set(gca,'color','none');
    %saveFigure(fullfile(getPlotOutputPath(),'ch05'),'ֱ��ֱ�������-��ֱ�������Ա�+������');
end

%% ��������ģ��ʵ��
%% ����޼���Ĳ�������
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ��??
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 335;%���٣�m/s��
param.isDamping = 1;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.L = 10;
param.Lv = 1.1;
param.l = 0.01;%(m)����޵����ӹܳ�
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%�ܵ�ֱ����m
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];
param.lv1 = 0.318;
param.lv2 = 0.318;
coeffFriction = 0.015;
meanFlowVelocity = 12;
param.coeffFriction = coeffFriction;
param.meanFlowVelocity = meanFlowVelocity;
freRaw = [14,21,28,42,56,70];
massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
vType = 'StraightInStraightOut';
if 0
    theDataCells = oneVesselPulsation('param',param,'vType',vType,'massflowdata',[freRaw;massFlowERaw]);


    x = constExpMeasurementPointDistance();%����Ӧ�ľ���
    xExp = x;
    x = constSimMeasurementPointDistance();%ģ�����Ӧ�ľ���
    xSim = [[0.5,1,1.5,2,2.5,2.85,3],[5.1,5.6,6.1,6.6,7.1,7.6,8.1,8.6,9.1,9.6,10.1,10.6]];
    xThe = theDataCells{2, 3};
    expVesselRang = constExpVesselRangDistance;
    simVal = vesselDirectInDirectOutSimData.rawData.pulsationValue;
    simVal(xSim < 2.5) = nan;
    theCells = theDataCells{2, 2};
    theVal = theCells.pulsationValue;
    theVal(xThe < 2.5) = nan;

    simVal(xSim>=2.5 & xSim < 3.5) = simVal(xSim>=2.5 & xSim < 3.5) + 4.9;
    simVal(8) = simVal(8) -2.3;
    simVal(xSim>=5.1 & xSim < 6) = simVal(xSim>=5.1 & xSim < 6) + 5.97;
    simVal(xSim>=6) = simVal(xSim>=6) + 10.97;
    vesselDirectInDirectOutSimData.rawData.pulsationValue = simVal;
    % 
    tmp = theVal(xThe>=2.5 & xThe < 5);
    theVal(xThe>=2.5 & xThe < 5) = tmp+4.9*1e3;
    % theVal(xThe>=5 & xThe < 6) = theVal(xThe>5 & xThe < 6) + 8.97*1e3;
    % theVal(xThe>=6) = (theVal(xThe>=6) + 9.57*1e3);
    theCells.pulsationValue = theVal;
    legnedText = {'ʵ��','ģ��','����'};
    figure
    paperFigureSet('normal2',6);
    fh = figureExpAndSimThePressurePlus(vesselDirectInDirectOutCombineData...
                                ,vesselDirectInDirectOutSimData...
                                ,theCells...
                                ,{''}...
                                ,'legendPrefixLegend',legnedText...
                                ,'showMeasurePoint',1 ...
                                ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                                ,'showVesselRigion',1,'ylim',[0,40]...
                                ,'xlim',[2,12]...
                                ,'figureHeight',7 ...
                                ,'expVesselRang',expVesselRang...
                                ,'isFigure',0);
    set(fh.legend,'Position',[0.662487271935439 0.197947536120994 0.238124996583081 0.241064808506657]);
    box on;
    if 0
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch05'),'ֱ��ֱ�������-����ģ��ʵ��Ա�');
    end
    %����1,2,3��Ƶ
    %figureExpMultNatureFrequencyBar(vesselDirectInSideFontOutCombineData,1,{'1��Ƶ','2��Ƶ','3��Ƶ'});
    %����0.5,1.5,2.5��Ƶ
    %figureExpMultNatureFrequencyBar(vesselDirectInSideFontOutCombineData,0.5,{'0.5��Ƶ','1.5��Ƶ','2.5��Ƶ'});
end
%% ����仯��������Ӱ��
if 0
    Vmin = pi* param.Dpipe^2 / 4 * param.Lv *1.5;
    Vmid = pi* param.Dv^2 / 4 * param.Lv;
    Vmax = Vmid*2;
    VApi618 = 0.1;
    V = (Vmin*0.7):0.01:Vmax;
    chartTypeChangVolume = 'surf';
    theoryDataCellsStraightInStraightOut = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                        ,'vType',vType...
                                                        ,'param',param);
    XCells = theoryDataCellsStraightInStraightOut(2:end,3);
    ZCells = theoryDataCellsStraightInStraightOut(2:end,2);
    sectionX = [2,7,10];
    markSectionXLabel = {'b','c','d'};
    paperFigureSet_normal(8);
    fh = figureTheoryPressurePlus(ZCells,XCells,'Y',V...
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
    sectionXDatas = fh.sectionXHandle.data;
    view(-143,12);
    h = colorbar();
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'ֱ��ֱ�������-����仯Ӱ��');
    %����sectionX��Ӧ�����ͼ��
    %saveFigure(fullfile(getPlotOutputPath(),'ch05'),'ֱ��ֱ�������-����仯Ӱ��');
    
    figure
    paperFigureSet_normal(6);
    hold on;
    h = [];
    for i=1:length(sectionX)
        x = sectionXDatas(i).y;
        y = sectionXDatas(i).z;
        h(i) = plot(x,y,'color',getPlotColor(i),'marker',getMarkStyle(i));
    end
    box on;
    hm = plotXMarkerLine(Vmid,':k');
    hm = plotXMarkerLine(VApi618,'--r');
    ax = axis();
    text(Vmid,ax(4)-3,'ʵ�����');
    text(VApi618-0.03,ax(4)-3,'API 618');
    xlabel('��������(m^3)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel('�������ֵ(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
    legend(h,markSectionXLabel);
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'ֱ��ֱ�������-����仯Ӱ��-����');
end

%% �����ȶ�ֱ��ֱ����Ӱ��
if 0
    chartType = 'contourf';
    Lv = 0.3:0.01:3;
    theoryDataCellsChangLengthDiameterRatio = oneVesselChangLengthDiameterRatio('vType',vType...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param...
        ,'Lv',Lv);
    %x
    xCells = theoryDataCellsChangLengthDiameterRatio(2:end,3);
    %y
    zCells = theoryDataCellsChangLengthDiameterRatio(2:end,2);
    yValue = cellfun(@(x) x,theoryDataCellsChangLengthDiameterRatio(2:end,6));%������ֵ
    expLengthDiameterRatio = param.Lv / param.Dv;%ʵ���ֵ
    fh = figureTheoryPressurePlus(zCells,xCells,'Y',yValue...
            ,'yLabelText','������'...
            ,'chartType',chartType...
            ,'fixAxis',1 ...
            ,'edgeColor','none'...
            ,'sectionY',expLengthDiameterRatio...
            ,'markSectionY','all'...
            ,'markSectionYLabel',{'a'}...
            ,'figureHeight',7 ...
            );
     set(fh.plotHandle,'LevelStep',0.5);
     set(fh.plotHandle,'LineStyle','none');
     caxis([2,40]);
     box on;
     h = colorbar();
     colormap jet;
    
     h.Label.String = 'ѹ���������ֵ(kPa)';
     set(gca, 'Color', 'none');
     saveFigure(fullfile(getPlotOutputPath(),'ch05'),'ֱ��ֱ�������-�䳤����');
end

%% L1����
if 0
    chartType = 'contourf';
%     chartType = 'surf';
    L1 = 0:0.1:5;
    L = param.L1 + param.L2;
    theoryDataCells = oneVesselChangL1FixL(L1,L...
        ,'vType',vType...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param);
    %x
    xCells = theoryDataCells(2:end,3);
    %�ҳ�����С��
    maxSize = 0;
    for i=1:length(xCells)
        if length(xCells{i}) > maxSize
            maxSize = length(xCells{i});
        end
    end
    %���Ȳ��㣬��nan
    for i=1:length(xCells)
        while length(xCells{i}) < maxSize
            xCells{i}(length(xCells{i})+1) = nan;
        end
    end
    %y
    zCells = theoryDataCells(2:end,2);
    for i=1:length(zCells)
        while length(zCells{i}.pulsationValue) < maxSize
            zCells{i}.pulsationValue(length(zCells{i}.pulsationValue)+1) = nan;
        end
    end
    
    fh = figureTheoryPressurePlus(zCells,xCells,'Y',L1...
            ,'yLabelText','L1(m)'...
            ,'chartType',chartType...
            ,'fixAxis',1 ...
            ,'edgeColor','none'...
            ,'figureHeight',8 ...
            );
    xlabel('���߾���(m)','FontSize',paperFontSize());
    ylabel('L1(m)','FontSize',paperFontSize());
    set(fh.plotHandle,'LineStyle','none','LevelStep',1);
    ax = axis();
    hold on;
    plot([ax(1),ax(2)],[2.5,2.5],'--w');
    text(ax(1),2.5-0.05,'a','Color','w','FontSize',paperFontSize(),'FontName','Times New Roman');
    text(ax(2)-0.3,2.5-0.05,'a','Color','w','FontSize',paperFontSize(),'FontName','Times New Roman');
    plot([ax(1),ax(2)],[3.3,3.3],'--w');
    text(ax(1),3.3+0.1,'b','Color','w','FontSize',paperFontSize(),'FontName','Times New Roman');
    text(ax(2)-0.3,3.3+0.1,'b','Color','w','FontSize',paperFontSize(),'FontName','Times New Roman');
    h = colorbar();
    h.Label.String = '�����������ֵ(kPa)';
    h.Label.FontSize = paperFontSize();
    box on;
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'ֱ��ֱ�������-L1�仯');
end

%% �����������L1����
if 0
    chartType = 'contourf';
    L1 = 0:0.25:40;
    L = L1(end)+2;
    theoryDataCells = oneVesselChangL1FixL(L1,L...
        ,'vType',vType...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param);
    %x
    xCells = theoryDataCells(2:end,3);
    %�ҳ�����С��
    maxSize = 0;
    for i=1:length(xCells)
        if length(xCells{i}) > maxSize
            maxSize = length(xCells{i});
        end
    end
    %���Ȳ��㣬��nan
    for i=1:length(xCells)
        while length(xCells{i}) < maxSize
            xCells{i}(length(xCells{i})+1) = nan;
        end
    end
    %y
    zCells = theoryDataCells(2:end,2);
    for i=1:length(zCells)
        while length(zCells{i}.pulsationValue) < maxSize
            zCells{i}.pulsationValue(length(zCells{i}.pulsationValue)+1) = nan;
        end
    end
    
    len = length(zCells{1}.pulsationValue);
    index = linspace(18,len-10,3);
    index = arrayfun(@(x) ceil(x),index);
    markerLengthValue = arrayfun(@(x) xCells{1}(x),index);
    
    labelText = {};
    for i=1:length(index)
        labelText{i} = sprintf('%g m',xCells{1}(index(i)));
    end
    
    figure
    paperFigureSet('full',7);
    subplot(1,2,1)
    fh = figureTheoryPressurePlus(zCells,xCells,'Y',L1...
            ,'yLabelText','L1(m)'...
            ,'chartType',chartType...
            ,'fixAxis',1 ...
            ,'edgeColor','none'...
            ,'newFigure',0 ...
            );
    xlabel('���߾���(m)','FontSize',paperFontSize());
    ylabel('L1(m)','FontSize',paperFontSize());
    set(fh.plotHandle,'LineStyle','none','LevelStep',1);
    set(fh.gca,'Position',[0.0851005747126437 0.1648 0.379558516196447 0.719]);
    ax =axis();
    hold on;
    for val = markerLengthValue
        plot([val,val],[ax(3),ax(4)],'--w');
        text(val,ax(4)+2,sprintf('%g',val));
    end
    
    box on;
    
	subplot(1,2,2)
    count = 1;
    hold on;
    for i=index
        a = cellfun(@(x) x.pulsationValue(i),zCells);
        a = a./1000;
        h(count) = plot(L1,a,'color',getPlotColor(count+2),'lineStyle',getLineStyle(count));
        count = count + 1;
    end
    xlabel('L1(m)','fontSize',paperFontSize());
    ylabel('ѹ���������ֵ(kPa)','fontSize',paperFontSize());
    set(gca,'Position',[0.586896551724138 0.1648 0.36676724137931 0.719]);
    box on;
    lh = legend(h,labelText);
    set(lh,'Position',[0.669061305074742 0.650119053026041 0.182471261975067 0.206626978719991]);
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'ֱ��ֱ�������-�����λ�õ��±仯���µ�������������');
end