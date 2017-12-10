clear all;
close all;
%��һ��������۵�
%% ����޼���Ĳ�������
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ��??
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 345;%���٣�m/s��
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 10;
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
coeffFriction = 0.03;
meanFlowVelocity = 12;
param.coeffFriction = coeffFriction;
param.meanFlowVelocity = meanFlowVelocity;
freRaw = [14,21,28,42,56,70];
massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];

%% 1����������
if 0
    chartType = 'surf';
    Lv = 0.3:0.05:3;
    theoryDataCellsChangLengthDiameterRatio = oneVesselChangLengthDiameterRatio('vType','straightInBiasFrontOut'...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param...
        ,'Lv',Lv);
    %
    %x
    xCells = theoryDataCellsChangLengthDiameterRatio(2:end,3);
    %y
    zCells = theoryDataCellsChangLengthDiameterRatio(2:end,2);
    yValue = cellfun(@(x) x,theoryDataCellsChangLengthDiameterRatio(2:end,6));%������ֵ
    expLengthDiameterRatio = param.Lv / param.Dv;
    fh = figureTheoryPressurePlus(zCells,xCells,'Y',yValue...
        ,'yLabelText','������'...
        ,'chartType',chartType...
        ,'fixAxis',1 ...
        ,'edgeColor','none'...
        ,'sectionY',expLengthDiameterRatio...
        ,'markSectionY','all'...
        ,'markSectionYLabel',{'a'}...
        );
end

%% ���������λ��
if 0
    chartType = 'surf';
    L1 = 0:0.1:8;
    
    theoryDataCellsChangL1 = oneVesselChangL1FixL(L1,param.L...
        ,'vType','straightInBiasFrontOut'...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param);
    %x
    xCells = theoryDataCellsChangL1(2:end,3);
    %y
    zCells = theoryDataCellsChangL1(2:end,2);
    fh = figureTheoryPressurePlus(zCells,xCells,'Y',L1...
        ,'yLabelText','L1'...
        ,'chartType',chartType...
        ,'fixAxis',1 ...
        ,'edgeColor','none'...
        ,'sectionY',param.L1...
        ,'markSectionY','all'...
        ,'markSectionYLabel',{'a'}...
        );
end

%% ����ƫ�þ���ͳ�����
if 1
    chartType = 'surf';
    endIndex = length(param.sectionL1) + length(param.sectionL2);
    Lv = linspace(0.3,3,42);
    lv1 = linspace(0,param.Lv-param.Dpipe,32);
    
    [X,Y,Z] = oneVesselChangBiasLengthAndAspectRatio(lv1,Lv,endIndex...
        ,'vType','straightInBiasFrontOut'...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param);
    paper
    figure
    paperFigureSet_normal(8);
    surf(X,Y,Z);
    xlabel('lv1');
    ylabel('������');
    zlabel('�������ֵ');
    box on;
    view(131,29);
end


