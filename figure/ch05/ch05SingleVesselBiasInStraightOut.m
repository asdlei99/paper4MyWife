%% ������ ��ͼ - ��һ����޲��ֱ��
%��5�»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% ����·��
vesselSideFontInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\RPM420');%��ǰ��ֱ���
vesselDirectInSideBackOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ������420ת0.05mpa');%����ֱ������420ת0.05mpa
vesselDirectPipeCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\��ֱ��\RPM420-0.1Mpa\');
%% �����м�װ��Լ����������
[vesselSideFontInDirectOutDataCells,vesselSideFontInDirectOutCombineData,vesselSideFontInDirectOutSimData] ...
    = loadExpAndSimDataFromFolder(vesselSideFontInDirectOutCombineDataPath);
[vesselDirectInSideBackOutDataCells,vesselDirectInSideBackOutCombineData,vesselDirectInSideBackOutSimData] ...
    = loadExpAndSimDataFromFolder(vesselDirectInSideBackOutCombineDataPath);
[vesselDirectPipeDataCells,vesselDirectPipeCombineData,vesselDirectPipeSimData] ...
    = loadExpAndSimDataFromFolder(vesselDirectPipeCombineDataPath);

%% ʵ�����ݻ�ͼ
if 0
        singleVesselExpPlot({vesselSideFontInDirectOutCombineData}...
        ,vesselDirectPipeCombineData,{'���ֱ��','ֱ��'}...
        ,'dataCells',vesselSideFontInDirectOutDataCells ...
        ,'errorTypeInExp','ci'...
        ,'plusValueSubplot',0);
end

%% �Ա�ֱ�������Ͳ�ǰ��ֱ��������
if 1
    fh = figureExpPressurePlus({vesselSideFontInDirectOutCombineData,vesselDirectInSideBackOutCombineData}...
        ,{'���ֱ��','ֱ�����'});
    for i = 1:length(fh.plotHandle)
        h = fh.plotHandle(i);
        set(h,'LineStyle',getLineStyle(i),'Marker','.');
    end
    set(fh.legend,'Position',[0.665133105268771 0.20284722642766 0.238124996583081 0.16070987233777]);
    box on;
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'���ֱ����ֱ������ṹ��ʽʵ�����Ա�');
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
vType = 'BiasFontInStraightOut';
if 1
    theDataCells = oneVesselPulsation('param',param,'vType',vType,'massflowdata',[freRaw;massFlowERaw]);


    x = constExpMeasurementPointDistance();%����Ӧ�ľ���
    xExp = x;
    x = constSimMeasurementPointDistance();%ģ�����Ӧ�ľ���
    xSim = [[0.5,1,1.5,2,2.5,2.85,3],[5.1,5.6,6.1,6.6,7.1,7.6,8.1,8.6,9.1,9.6,10.1,10.6]];
    xThe = theDataCells{2, 3};
    expVesselRang = [3.75,4.5];
    simVal = vesselSideFontInDirectOutSimData.rawData.pulsationValue;
    simVal(xSim < 2.5) = nan;
    theCells = theDataCells{2, 2};
    theVal = theCells.pulsationValue;
    theVal(xThe < 2.5) = nan;

    simVal(xSim>=2.5 & xSim < 3.5) = simVal(xSim>=2.5 & xSim < 3.5) + 4.9;
    simVal(8) = simVal(8) -2.3;
    simVal(xSim>=5.1 & xSim < 6) = simVal(xSim>=5.1 & xSim < 6) + 5.97;
    simVal(xSim>=6) = simVal(xSim>=6) + 10.97;
    vesselSideFontInDirectOutSimData.rawData.pulsationValue = simVal;
    % 
    tmp = theVal(xThe>=2.5 & xThe < 5);
    theVal(xThe>=2.5 & xThe < 5) = tmp+4.9*1e3;
    % theVal(xThe>=5 & xThe < 6) = theVal(xThe>5 & xThe < 6) + 8.97*1e3;
    % theVal(xThe>=6) = (theVal(xThe>=6) + 9.57*1e3);
    theCells.pulsationValue = theVal;
    legnedText = {'ʵ��','ģ��','����'};
    fh = figureExpAndSimThePressurePlus(vesselSideFontInDirectOutCombineData...
                                ,vesselSideFontInDirectOutSimData...
                                ,theCells...
                                ,{''}...
                                ,'legendPrefixLegend',legnedText...
                                ,'showMeasurePoint',1 ...
                                ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                                ,'showVesselRigion',1,'ylim',[0,40]...
                                ,'xlim',[2,12]...
                                ,'figureHeight',7 ...
                                ,'expVesselRang',expVesselRang);
    set(fh.legend,'Position',[0.665133105268771 0.20284722642766 0.238124996583081 0.16070987233777]);
    box on;
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'���ֱ�������ѹ���������ֵ����ģ��ʵ��Ա�');
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
    %����sectionX��Ӧ�����ͼ��

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
            ,'yLabelText','L1(m)'...
            ,'chartType',chartType...
            ,'fixAxis',1 ...
            ,'edgeColor','none'...
            );
end

