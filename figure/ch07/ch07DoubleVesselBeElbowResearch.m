%% ������ ��ͼ - ˫�޹޶�����ͷ���۷����Ա�
%�����»�ͼ�Ĳ�������clear all;
close all;
clear all;
clc;
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
%% ���������Ӧ
if 1
    shockResponseBeElbowDataCells = doubleVesselBeElbowShockResponse('meanflowvelocity',25.51);
    shockResponseStraingDataCells = doubleVesselShockResponse('meanflowvelocity',25.51);
    
    dataCells = {shockResponseBeElbowDataCells{2, 2}...
        ,shockResponseStraingDataCells{2, 2}};
    legendLabels = {shockResponseBeElbowDataCells{2, 1}...
        ,shockResponseStraingDataCells{2, 1}};
    xs = {shockResponseBeElbowDataCells{2, 3}...
        ,shockResponseStraingDataCells{2, 3}};
    
    fhBeElbow = figureShockSpectrumContourf(dataCells,{'(a)','(b)'}...
        ,'x',xs...
        ,'LevelList',0:10000:60000 ...
        ,'figureHeight',6 ...
        ,'xlim',[0,100] ...
        ,'xlabel','Ƶ��(Hz)'...
        ,'ylabel','���߾���(m)'...
        );
    set(fhBeElbow.contourfHandle(1).contourfHandle,'LevelList',0:5000:60000);
    set(fhBeElbow.contourfHandle(2).contourfHandle,'LevelList',0:5000:60000);
end
%% �ı�ڶ�������޵���һ������޾����������Ӱ��
if 1 % �ı�ڶ�������޵���һ������޾����������Ӱ��
    
    % ���� x:���߾��� y:�������޵ľ��� z:�������ֵ
    theoryDataCells = doubleVesselBeElbowChangDistanceToFirstVessel('massflowdata',[freRaw;massFlowERaw]...
        ,'meanFlowVelocity',14);
    plusValue = theoryDataCells(2:end,2);
    X = theoryDataCells(2:end,3);
    legendLabels = theoryDataCells(2:end,1);
    linkPipeLength = cell2mat(theoryDataCells(2:end,5));
    if 0
        xlabelText = 'distance(m)';
        ylabelText = 'connect distance(m)';
        zLabelText = 'pressure plus(kPa)';
    else
        xlabelText = '���߾���(m)';
        ylabelText = '���ӹܳ�(m)';
        zLabelText = 'ѹ���������ֵ(kPa)';
    end
    figure;
    paperFigureSet_large(6);
    subplot(1,2,1)

    fh = figureTheoryPressurePlus(plusValue,X...
        ,'Y',linkPipeLength...
        ,'legendLabels',legendLabels...
        ,'xLabelText',xlabelText...
        ,'yLabelText',ylabelText...
        ,'zLabelText',zLabelText...
        ,'chartType','contourf'...
        ,'edgeColor','none'...
        ,'newFigure',0 ...
    );
    set(fh.plotHandle,'LevelList',0:3:25,'showText','on');
    xlim([0,10.37]);
    box on;
    colorbarHandle = colorbar;
    set(gca,...
    'Position',[0.0789732142857141 0.192364165480092 0.334659090909091 0.732635834519908]);
%     ax = axis;
%     plot([X{1}(1),X{1}(1)],[linkPipeLength(1),linkPipeLength(end)],'color','w');
    set(colorbarHandle,'Position',...
    [0.423227934535719 0.189618055555556 0.0308995532304277 0.732013888888889]);
    title('(a)');
    % ����ͼ�Ĺ�ǰ�͹޺�������ƽ��л���
    subplot(1,2,2)
    for i=2:size(theoryDataCells,1)
        Y1(i-1) = theoryDataCells{i, 2}.pulsationValue(end);
        Y2(i-1) = theoryDataCells{i, 2}.pulsationValue(1);
    end
    plot(linkPipeLength,Y1./1000,'--');
    hold on;
    plot(linkPipeLength,Y2./1000,'-');
    xlabel(ylabelText);
    ylabel(zLabelText);
    set(gca,...
    'Position',[0.617587932900433 0.192364165480092 0.334659090909091 0.732635834519909]);
    annotation('textarrow',[0.794955357142858 0.753377976190477],...
    [0.770902777777779 0.651840277777779],'String',{'�޺���'});
    annotation('textarrow',[0.728809523809524 0.764717261904762],...
    [0.329930555555556 0.404895833333334],'String',{'��ǰ���'});
    title('(b)');
end

%% �о��ı䳤���ȶ�������Ӱ��
if 1
    theoryDataCells =  doubleVesselBeElbowChangLengthDiameterRatio('massflowdata',[freRaw;massFlowERaw]...
        ,'meanFlowVelocity',14);
    plusValue = theoryDataCells(2:end,2);
    X = theoryDataCells(2:end,3);
    legendLabels = theoryDataCells(2:end,1);
    LengthDiameterRatio = cell2mat(theoryDataCells(2:end,6));
    if 0
        xlabelText = 'distance(m)';
        ylabelText = 'Length-DiameterRatio';
        zLabelText = 'pressure plus(kPa)';
    else
        xlabelText = '���߾���(m)';
        ylabelText = '������';
        zLabelText = 'ѹ���������ֵ(kPa)';
    end
    fh = figureTheoryPressurePlus(plusValue,X...
        ,'Y',LengthDiameterRatio...
        ,'legendLabels',legendLabels...
        ,'xLabelText',xlabelText...
        ,'yLabelText',ylabelText...
        ,'zLabelText',zLabelText...
        ,'chartType','surf'...%'contourf'...
        ,'edgeColor','none'...
        ,'sectionX',[0,10] ...
        ,'markSectionX','all'...
        ,'markSectionXLabel',{'A','B'}...
        ,'sectionY',1.1 / 0.372 ...%Ĭ�ϳ�����
        ,'markSectionY','all'...
        ,'markSectionYLabel',{'C'}...
        ,'fixAxis',1 ...
    );
    xlim([0,10.37]);
    ylim([0,25]);
    box on;
    view(137,41);
    colorbar;
    %����a��b�����ͶӰͼ
    figure
    paperFigureSet_normal();
    linkPipeLength = cell2mat(theoryDataCells(2:end,6));
    for i=2:size(theoryDataCells,1)
        Y1(i-1) = theoryDataCells{i, 2}.pulsationValue(end);
        Y2(i-1) = theoryDataCells{i, 2}.pulsationValue(1);
    end
    plot(linkPipeLength,Y1./1000,'--');
    hold on;
    plot(linkPipeLength,Y2./1000,'-');
    xlabel(ylabelText);
    ylabel(zLabelText);
    annotation('textarrow',[0.39828125 0.4578125],...
        [0.723697916666667 0.783229166666667],'String',{'A-A'});
    annotation('textarrow',[0.393871527777778 0.455607638888889],...
        [0.528567708333333 0.39296875],'String',{'B-B'});
end
