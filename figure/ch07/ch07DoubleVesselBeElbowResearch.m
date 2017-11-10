%% ������ ��ͼ - ˫�޹޶�����ͷ���۷����Ա�
%�����»�ͼ�Ĳ�������clear all;
close all;
clear all;
clc;
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
%% ���������Ӧ
if 0
    %����
    shockFreTimes = 1;
    shockFs = 1024*shockFreTimes;
    shockPulsWave = [100,zeros(1,1024*shockFreTimes-1)];
    shockTime = 0:1:(size(shockPulsWave,2)-1);
    shockTime = shockTime .* (1/shockFs);
    [shockFrequency,~,~,shockMagE] = frequencySpectrum(shockPulsWave,shockFs);
    shockFrequency(1) = [];
    shockMagE(1) = [];
    
    param.meanFlowVelocity = 25.51;
    param.Fs = shockFs;
    param.fre = shockFrequency;
    param.massFlowE = shockMagE; 
    param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
    param.rpm = 420;
    param.outDensity = 1.5608;
    param.acousticVelocity = 345;%����
    param.isDamping = 1;%�Ƿ��������
    param.coeffFriction = 0.003;%�ܵ�Ħ��ϵ��
    param.mach = param.meanFlowVelocity / param.acousticVelocity;
    param.notMach = 0;
    param.L1 = 3.5;%L1(m)
    param.L2 = 1.5;%1.5;%˫�޴����޶�����ͷ���޼��
    param.L3 = 4;%4%˫�޴����޶�����ͷ���ڹܳ�
    param.Dpipe = 0.098;%�ܵ�ֱ����m��%Ӧ����0.106
    param.l = 0.01;
    param.DV1 = 0.372;%����޵�ֱ����m��
    param.LV1 = 1.1;%������ܳ� ��1.1m��
    param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%����޵�ֱ����0.372m��
    param.LV2 = 1.1;%variant_r(i).*param.DV2;%������ܳ� ��1.1m��
    param.Lv1 = param.LV1./2;%�����ǻ1�ܳ�
    param.Lv2 = param.LV1-param.Lv1;%�����ǻ2�ܳ�   
    param.lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
    param.Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
    param.sectionL1 = 0:0.25:param.L1;%[2.5,3.5];%0:0.25:param.L1
    param.sectionL2 = 0:0.25:param.L2;
    param.sectionL3 = 0:0.25:param.L3;
    %�����������
    
    
    shockResponseBeElbowDataCells = doubleVesselBeElbowShockResponse('param',param);
    shockResponseStraingDataCells = doubleVesselShockResponse('param',param);
    
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
    ax = axis(fhBeElbow.gca(1));
    %���ƹ޶�����ͷ��L1�ֽ�
    plot(fhBeElbow.gca(1),[ax(1),ax(2)],[param.L1,param.L1],'--w');
    plot(fhBeElbow.gca(1),[ax(1),ax(2)],[param.L1+param.LV1+2*param.l,param.L1+param.LV1+2*param.l],'--w');
    %����˫�޹�ǰ�޺�ֽ�
    ax = axis(fhBeElbow.gca(2));
    plot(fhBeElbow.gca(2),[ax(1),ax(2)],[param.L1,param.L1],'--w');
    set(fhBeElbow.contourfHandle(1).contourfHandle,'LevelList',0:5000:60000);
    set(fhBeElbow.contourfHandle(2).contourfHandle,'LevelList',0:5000:60000);
    %
    annotation('textbox',...
        [0.095 0.34 0.05 0.11],...
        'String',{'a'},...
        'Color',[1 1 1],...
        'EdgeColor','none');
    annotation('textbox',...
        [0.389 0.34 0.05 0.11],...
        'String',{'a'},...
        'Color',[1 1 1],...
        'EdgeColor','none');
    annotation('textbox',...
        [0.095 0.5 0.05 0.11],...
        'String',{'b'},...
        'Color',[1 1 1],...
        'EdgeColor','none');
    annotation('textbox',...
        [0.389 0.5 0.05 0.11],...
        'Color',[1 1 1],...
        'String',{'b'},...
        'EdgeColor','none');
    annotation('textbox',...
        [0.501 0.42 0.05 0.11],...
        'String',{'a'},...
        'Color',[1 1 1],...
        'EdgeColor','none');
    annotation('textbox',...
        [0.8 0.42 0.05 0.11],...
        'String',{'a'},...
        'Color',[1 1 1],...
        'EdgeColor','none');
end
%% �ı�ڶ�������޵���һ������޾����������Ӱ��
if 0 % �ı�ڶ�������޵���һ������޾����������Ӱ��
    
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
    hold on;
    plot(linkPipeLength+3.5,linkPipeLength,'--w');
    plot(ones(size(linkPipeLength)).*3.5,linkPipeLength,'--w');
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
    param.acousticVelocity = 345;%����
    param.isDamping = 1;%�Ƿ��������
    param.coeffFriction = 0.003;%�ܵ�Ħ��ϵ��
    param.coeffFriction = 0.045;
    param.meanFlowVelocity = 25.51;%14.6;%�ܵ�ƽ������
    param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
    param.rpm = 420;
    param.outDensity = 1.5608;
    param.Fs = 4096;
    param.L1 = 3.5;%L1(m)
    param.L2 = 1.5;%1.5;%˫�޴����޶�����ͷ���޼��
    param.L3 = 4;%4%˫�޴����޶�����ͷ���ڹܳ�
    param.Dpipe = 0.098;%�ܵ�ֱ����m��%Ӧ����0.106
    param.l = 0.01;
    param.DV1 = 0.372;%����޵�ֱ����m��
    param.LV1 = 1.1;%������ܳ� ��1.1m��
    param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%����޵�ֱ����0.372m��
    param.LV2 = 1.1;%variant_r(i).*param.DV2;%������ܳ� ��1.1m�� 
    param.lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
    param.Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
    param.sectionL1 = 0:0.25:param.L1;%[2.5,3.5];%0:0.25:param.L1
    param.sectionL2 = 0:0.25:param.L2;%[2.5,3.5];%0:0.25:param.L1
    param.sectionL3 = 0:0.25:param.L3;%[2.5,3.5];%0:0.25:param.L1
    param.notMach = 0;
    param.multFreTimes = 3;
    param.semiFreTimes = 3;
    param.allowDeviation = 0.5;
    param.beforeAfterMeaPoint = nan;
    param.calcPeakPeakValueSection = nan;
    param.notMach = 0;
    theoryDataCells = doubleVesselBeElbowChangLengthDiameterRatio('massflowdata',[freRaw;massFlowERaw],...
        'param',param);
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
        ,'figureHeight',7 ...
    );
    xlim([0,10.37]);
    ylim([0,25]);
    box on;
    view(137,41);
    colorbar;
    %����a��b�����ͶӰͼ
    figure
    paperFigureSet_normal(7);
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
    annotation('textarrow',[0.411510416666667 0.4578125],...
        [0.800625 0.72125],'String',{'A-A'});
    annotation('textarrow',[0.393871527777778 0.455607638888889],...
        [0.528567708333333 0.39296875],'String',{'B-B'});
end


%%
if 0
    [X,Y,Z] = doubleVesselBeElbowChangLengthDiameterRatioAndV();
    figure
    paperFigureSet_normal(7);
    [c,f] = contourf(X,Y,Z);
    xlabel('������');
    ylabel('��������');
    set(f,'levelList',1:500:14000);
end