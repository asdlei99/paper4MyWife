clear all;
close all;
%单一缓冲罐理论迭
%% 缓冲罐计算的参数设置
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密??
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 335;%声速（m/s）
param.isDamping = 1;
param.coeffFriction = 0.001;
param.meanFlowVelocity = 12;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.L = 10;
param.Lv = 1.1;
param.l = 0.01;%(m)缓冲罐的连接管长
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%管道直径（m
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];
param.lv1 = 0.318;
param.lv2 = 0.318;
coeffFriction = 0.03;
meanFlowVelocity = 12;
param.coeffFriction = coeffFriction;
param.meanFlowVelocity = meanFlowVelocity;
freRaw = [14,21,28,42,56,70];
massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];

%% 1迭代长径比
if 1
    chartType = 'surf';
    Lv = 0.3:0.05:3;
    theoryDataCellsChangLengthDiameterRatio = oneVesselChangLengthDiameterRatio('vType','straightInBiasOut'...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param...
        ,'Lv',Lv);
    %
    %x
    xCells = theoryDataCellsChangLengthDiameterRatio(2:end,3);
    %y
    zCells = theoryDataCellsChangLengthDiameterRatio(2:end,2);
    yValue = cellfun(@(x) x,theoryDataCellsChangLengthDiameterRatio(2:end,6));%长径比值
    expLengthDiameterRatio = param.Lv / param.Dv;
    fh = figureTheoryPressurePlus(zCells,xCells,'Y',yValue...
        ,'yLabelText','长径比'...
        ,'chartType',chartType...
        ,'fixAxis',1 ...
        ,'edgeColor','none'...
        ,'sectionY',expLengthDiameterRatio...
        ,'markSectionY','all'...
        ,'markSectionYLabel',{'a'}...
        );
end

%% 迭代缓冲罐位置
if 0
    chartType = 'surf';
    L1 = 0:0.1:8;
    
    theoryDataCellsChangL1 = oneVesselChangL1FixL(L1,param.L...
        ,'vType','straightInBiasOut'...
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

%% 迭代偏置距离和长径比
if 1
%     chartType = 'surf';
    chartType = 'contourf';
    endIndex = length(param.sectionL1) + length(param.sectionL2);
    Lv = linspace(0.3,3,42);
    lv1 = linspace(0,param.Lv-param.Dpipe,32);
    
    [X,Y,Z] = oneVesselChangBiasLengthAndAspectRatio(lv1,Lv,endIndex...
        ,'vType','straightInBiasOut'...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param);
    Z = Z./1000;
%     paper
    figure
    paperFigureSet_normal(9);
    if strcmpi(chartType,'surf')
        surf(X,Y,Z);
        view(131,29);
    else
        [C,h] = contourf(X,Y,Z,'ShowText','on','LevelStep',0.3);
    end
    annotation('textbox',...
    [0.794313266242073 0.953667953667954 0.12216715542522 0.0540540540540539],...
    'String',{'kPa'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
    colorbar;
    xlabel('偏置距离l1(m)');%l1就是lv1
    ylabel('长径比');
    zlabel('压力脉动峰峰值(kPa)');
    box on;
    
end

%% 迭代缓冲罐lv1的偏置入口管长
if 0
    chartType = 'surf';
    Lv1 = 0:0.05:1;
    
    theoryDataCellsChangLv1 = oneVesselChangLv1(Lv1...
        ,'vType','straightInBiasOut'...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param);
    %x
    xCells = theoryDataCellsChangLv1(2:end,3);
    %y
    zCells = theoryDataCellsChangLv1(2:end,2);
    fh = figureTheoryPressurePlus(zCells,xCells,'Y',Lv1...
        ,'yLabelText','Lv1'...
        ,'chartType',chartType...
        ,'fixAxis',1 ...
        ,'edgeColor','none'...
        ,'sectionY',param.lv1...
        ,'markSectionY','all'...
        ,'markSectionYLabel',{'a'}...
        );
end

