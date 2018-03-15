%% 第七章 绘图 - 双罐罐二做弯头理论分析对比
%第七章画图的参数设置clear all;
close all;
clear all;
clc;
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
% grootDefaultPlotPropertySet();
isEnglish = 0;
isSaveFigure = 0;
%% 冲击脉动响应
if 0
    %参数
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
    param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
    param.rpm = 420;
    param.outDensity = 1.5608;
    param.acousticVelocity = 345;%声速
    param.isDamping = 1;%是否计算阻尼
    param.coeffFriction = 0.003;%管道摩察系数
    param.mach = param.meanFlowVelocity / param.acousticVelocity;
    param.notMach = 0;
    param.L1 = 3.5;%L1(m)
    param.L2 = 1.5;%1.5;%双罐串联罐二作弯头两罐间距
    param.L3 = 4;%4%双罐串联罐二作弯头出口管长
    param.Dpipe = 0.098;%管道直径（m）%应该是0.106
    param.l = 0.01;
    param.DV1 = 0.372;%缓冲罐的直径（m）
    param.LV1 = 1.1;%缓冲罐总长 （1.1m）
    param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
    param.LV2 = 1.1;%variant_r(i).*param.DV2;%缓冲罐总长 （1.1m）
    param.Lv1 = param.LV1./2;%缓冲罐腔1总长
    param.Lv2 = param.LV1-param.Lv1;%缓冲罐腔2总长   
    param.lv3 = 0.150+0.168;%针对单一偏置缓冲罐入口偏置长度
    param.Dbias = 0;%偏置管伸入罐体部分为0，所以对应直径为0
    param.sectionL1 = 0:0.25:param.L1;%[2.5,3.5];%0:0.25:param.L1
    param.sectionL2 = 0:0.25:param.L2;
    param.sectionL3 = 0:0.25:param.L3;
    %参数输入结束
    
    
    shockResponseBeElbowDataCells = doubleVesselBeElbowShockResponse('param',param);
    shockResponseStraingDataCells = doubleVesselShockResponse('param',param);
    
    dataCells = {shockResponseBeElbowDataCells{2, 2}...
        ,shockResponseStraingDataCells{2, 2}};
    legendLabels = {shockResponseBeElbowDataCells{2, 1}...
        ,shockResponseStraingDataCells{2, 1}};
    xs = {shockResponseBeElbowDataCells{2, 3}...
        ,shockResponseStraingDataCells{2, 3}};
    if isEnglish
        fontName = 'Cambria';
        barHighText = 'High';
        barLowText = 'Low';
        xlabelText = 'Frequency(Hz)';
        ylabelText = 'Distance(m)';
    else
        fontName = '黑体';
        barHighText = '高';
        barLowText = '低';
        xlabelText = '频率(Hz)';
        ylabelText = '距离(m)';
    end
    fhBeElbow = figureShockSpectrumContourf(dataCells,{'(a)','(b)'}...
        ,'x',xs...
        ,'LevelList',0:10000:60000 ...
        ,'figureHeight',6 ...
        ,'xlim',[0,100] ...
        ,'xlabel',xlabelText...
        ,'ylabel',ylabelText...
        ,'fontName',fontName...
        );
    ax = axis(fhBeElbow.gca(1));
    set(fhBeElbow.lowText,'String',barLowText);
    set(fhBeElbow.heighText,'String',barHighText);
    %绘制罐二做弯头的L1分界
    plot(fhBeElbow.gca(1),[ax(1),ax(2)],[param.L1,param.L1],'--w');
    plot(fhBeElbow.gca(1),[ax(1),ax(2)],[param.L1+param.LV1+2*param.l,param.L1+param.LV1+2*param.l],'--w');
    %绘制双罐罐前罐后分界
    ax = axis(fhBeElbow.gca(2));
    plot(fhBeElbow.gca(2),[ax(1),ax(2)],[param.L1,param.L1],'--w');
%     set(fhBeElbow.contourfHandle(1).contourfHandle,'LevelList',0:5000:60000);
%     set(fhBeElbow.contourfHandle(2).contourfHandle,'LevelList',0:5000:60000);
    %
    annotation('textbox',...
        [0.095 0.34 0.05 0.11],...
        'String',{'a'},...
        'Color',[1 1 1],...
        'EdgeColor','none'...
        ,'FontName',fontName...
        ,'FontSize',paperFontSize());
    annotation('textbox',...
        [0.389 0.34 0.05 0.11],...
        'String',{'a'},...
        'Color',[1 1 1],...
        'EdgeColor','none'...
        ,'FontName',fontName...
        ,'FontSize',paperFontSize());
    annotation('textbox',...
        [0.095 0.5 0.05 0.11],...
        'String',{'b'},...
        'Color',[1 1 1],...
        'EdgeColor','none'...
        ,'FontName',fontName...
        ,'FontSize',paperFontSize());
    annotation('textbox',...
        [0.389 0.5 0.05 0.11],...
        'Color',[1 1 1],...
        'String',{'b'},...
        'EdgeColor','none'...
        ,'FontName',fontName...
        ,'FontSize',paperFontSize());
    annotation('textbox',...
        [0.501 0.42 0.05 0.11],...
        'String',{'c'},...
        'Color',[1 1 1],...
        'EdgeColor','none'...
        ,'FontName',fontName...
        ,'FontSize',paperFontSize());
    annotation('textbox',...
        [0.8 0.42 0.05 0.11],...
        'String',{'c'},...
        'Color',[1 1 1],...
        'EdgeColor','none'...
        ,'FontName',fontName...
        ,'FontSize',paperFontSize());
end
%% 改变第二个缓冲罐到第一个缓冲罐距离对脉动的影响
if 1 % 改变第二个缓冲罐到第一个缓冲罐距离对脉动的影响
    % 绘制 x:管线距离 y:连接两罐的距离 z:脉动峰峰值
    theoryDataCells = doubleVesselBeElbowChangDistanceToFirstVessel('massflowdata',[freRaw;massFlowERaw]...
        ,'meanFlowVelocity',14);
    plusValue = theoryDataCells(2:end,2);
    X = theoryDataCells(2:end,3);
    legendLabels = theoryDataCells(2:end,1);
    linkPipeLength = cell2mat(theoryDataCells(2:end,5));
    if isEnglish
        fontName = 'Cambria';
        xlabelText = 'Distance(m)';
        ylabelText = 'Lc(m)';
        zLabelText = 'Peak-to-peak pressure pulsation(kPa)';
        arr1Text = 'Point 1';
        arr2Text = 'Point 12';
    else
        fontName = '黑体';
        xlabelText = '管线距离(m)';
        ylabelText = '连接管长(m)';
        zLabelText = '压力脉动峰峰值(kPa)';
        arr1Text = '测点 1';
        arr2Text = '测点 12';
    end
    figure;
    paperFigureSet_large(7);
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
        ,'fontName',fontName...
    );
    hold on;
    plot(linkPipeLength+3.5,linkPipeLength,'--w');
    plot(ones(size(linkPipeLength)).*3.5,linkPipeLength,'--w');
    set(fh.plotHandle,'LevelList',0:3:25,'showText','on');
    xlim([0,10.37]);
    box on;
    colorbarHandle = colorbar;
%     set(gca,...
%         'Position',[0.0789732142857141 0.192364165480092 0.334659090909091 0.732635834519908]);
    set(gca,...
    	'Position',[0.0789732142857141 0.192364165480092 0.334659090909091 0.671142778964353]);
    set(colorbarHandle,'Position',...
        [0.427007696440481 0.189618055555556 0.0296589702261858 0.675262896825397]);
    titleHandle = title('(a)');
    set(titleHandle,'Position',[0.087,4.331,0]);
    %绘制顶部L1,L2,L3的标注线
    annotation('line',[0.0827232796486091 0.411420204978038],...
    [0.883256528417819 0.883256528417819]);
    %四个小斜杠
    annotation('line',[0.0856515373352855 0.0797950219619327],...
        [0.895545314900154 0.872503840245776]);
    annotation('line',[0.194729136163983 0.18887262079063],...
        [0.895545314900154 0.872503840245776]);
    annotation('line',[0.326500732064422 0.320644216691069],...
        [0.895545314900154 0.872503840245776]);
    annotation('line',[0.415080527086384 0.409224011713031],...
        [0.895545314900154 0.872503840245776]);
    %显示L1,L2,L3
    annotation('textbox',...
        [0.112273792093704 0.872503840245776 0.0484067372068629 0.0897603106976205],...
        'String',{'L1'},...
        'FitBoxToText','off',...
        'EdgeColor','none');
    annotation('textbox',...
        [0.242099674238252 0.864823348694316 0.052796356007495 0.0974408022490798],...
        'String','Lc',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    annotation('textbox',...
        [0.354892949762945 0.866359447004608 0.0496439122408364 0.0959047039387879],...
         'String','L2',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    % 对上图的罐前和罐后测点的趋势进行绘制
    subplot(1,2,2)
    for i=2:size(theoryDataCells,1)
        Y1(i-1) = theoryDataCells{i, 2}.pulsationValue(end);
        Y2(i-1) = theoryDataCells{i, 2}.pulsationValue(1);
    end
    plot(linkPipeLength,Y1./1000,'--');
    hold on;
    plot(linkPipeLength,Y2./1000,'-');
    xlabel(ylabelText,'fontName',fontName);
    ylabel(zLabelText,'fontName',fontName); 
    set(gca,'Position',[0.617587932900433 0.192364165480092 0.334659090909091 0.668013193010474]);
    
    annotation('textarrow',[0.794955357142858 0.753377976190477],...
    [0.770902777777779 0.651840277777779],'String',{arr1Text},'fontName',fontName);

    annotation('textarrow',[0.728809523809524 0.764717261904762],...
    [0.329930555555556 0.404895833333334],'String',{arr2Text},'fontName',fontName);

    titleHandle = title('(b)');
    set(titleHandle,'Position',[0.011,32.33,0]);
    if isSaveFigure
        set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch07'),'弯头式缓冲罐-变连接管长');
    end
    
    
    
    figure
    paperFigureSet('Small',6.5);
    plot(linkPipeLength,Y2./Y1);
    if isEnglish
        xlabel('Lc(m)','FontSize',paperFontSize());
        ylabel('Peak-Peak Pressure ratio','FontSize',paperFontSize());
    else
        xlabel('偏置距离(m)','FontSize',paperFontSize());
        ylabel('脉动压力比','FontSize',paperFontSize());
    end
    if isSaveFigure
        set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch07'),'弯头式缓冲罐-变连接管长-P1比P2');
	end
end

%% 研究改变长径比对脉动的影响
param.acousticVelocity = 345;%声速
param.isDamping = 1;%是否计算阻尼
param.coeffFriction = 0.003;%管道摩察系数
param.coeffFriction = 0.045;
param.meanFlowVelocity = 25.51;%14.6;%管道平均流速
param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.L1 = 3.5;%L1(m)
param.L2 = 1.5;%1.5;%双罐串联罐二作弯头两罐间距
param.L3 = 4;%4%双罐串联罐二作弯头出口管长
param.Dpipe = 0.098;%管道直径（m）%应该是0.106
param.l = 0.01;
param.DV1 = 0.372;%缓冲罐的直径（m）
param.LV1 = 1.1;%缓冲罐总长 （1.1m）
param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
param.LV2 = 1.1;%variant_r(i).*param.DV2;%缓冲罐总长 （1.1m） 
param.lv3 = 0.150+0.168;%针对单一偏置缓冲罐入口偏置长度
param.Dbias = 0;%偏置管伸入罐体部分为0，所以对应直径为0
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

%长径比变化对脉动的影响
if 0
   
    theoryDataCells = doubleVesselBeElbowChangLengthDiameterRatio('massflowdata',[freRaw;massFlowERaw],...
        'param',param);
    plusValue = theoryDataCells(2:end,2);
    X = theoryDataCells(2:end,3);
    legendLabels = theoryDataCells(2:end,1);
    LengthDiameterRatio = cell2mat(theoryDataCells(2:end,6));
    if isEnglish
        xlabelText = 'Distance(m)';
        ylabelText = 'r';
        zLabelText = 'Peak-to-peak pressure pulsation(kPa)';
        arr1Text = 'A-A(Point 1)';
        arr2Text = 'B-B(Point 12)';
    else
        xlabelText = '管线距离(m)';
        ylabelText = '长径比';
        zLabelText = '压力脉动峰峰值(kPa)';
        arr1Text = 'A-A(测点 1)';
        arr2Text = 'B-B(测点 12)';
    end
    figure
    paperFigureSet_large(7);
    subplot(1,2,1)
    fh = figureTheoryPressurePlus(plusValue,X,...
        'Y',LengthDiameterRatio,...
        'legendLabels',legendLabels,...
        'xLabelText',xlabelText,...
        'yLabelText',ylabelText,...
        'zLabelText',zLabelText,...
        'chartType','surf',...%'contourf',...
        'edgeColor','none',...
        'sectionX',[0,10] ,...
        'markSectionX','all',...
        'markSectionXLabel',{'A','B'},...
        'sectionY',1.1 / 0.372 ,...%默认长径比
        'markSectionY','all',...
        'markSectionYLabel',{'C'},...
        'fixAxis',1 ,...
        'figureHeight',7 ,...
        'newfigure',0 ...
    );
    xlim([0,10.37]);
    ylim([0,30]);
    box on;
    view(137,41);
    title('(a)');
    set(gca,'Position',[0.105006132415159 0.164779870052758 0.313320027680261 0.718238997871771]);
    colorbar('peer',gca,'Position',...
        [0.481076703224317 0.172327039864078 0.0126023944549464 0.760220129947242]);
    %绘制a，b截面的投影图
    subplot(1,2,2)   
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
    set(gca,'Position',[0.649434523809524 0.229880952380953 0.308050595238096 0.646339285714286]);
    title('(b)');
    annotation('textarrow',[0.847872023809524 0.811964285714286],...
    [0.766607142857143 0.675892857142858],'String',{arr1Text});
    annotation('textarrow',[0.838422619047619 0.806294642857143],...
    [0.452886904761905 0.396190476190476],'String',{arr2Text});
    if isSaveFigure
        set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch07'),'弯头式缓冲罐-长径比');
    end
    
    figure
    paperFigureSet('Small',6.5);
    plot(linkPipeLength,Y2./Y1);
    xlabel('r');
    ylabel('Pressure ratio');
    xlim([0,30]);
    if isSaveFigure
        set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch07'),'弯头式缓冲罐-长径比-P1比P2');
    end
end


%% 长径比和体积的综合影响
if 0
    if isEnglish
        fontName = 'Cambria';
        contourfXlabelText = 'r';
        contourfYlabelText = 'Surge Volume(m^3)';
        linePlotXlabelText = 'r';
        linePlotYlabelText = 'Peak-to-peak pressure pulsation(kPa)';
        volumeText = 'Volume(m^3)';
    else
        fontName = '黑体';
        contourfXlabelText = '长径比';
        contourfYlabelText = '缓冲罐体积(m^3)';
        linePlotXlabelText = '长径比';
        linePlotYlabelText = '测点12气流脉动峰峰值(kPa)';
        volumeText = '体积(m^3)';
    end
    setDefaultPlotFontName(fontName);
    [X,Y,Z] = doubleVesselBeElbowChangLengthDiameterRatioAndV('end','massflowdata',[freRaw;massFlowERaw],...
        'param',param);
    figure
    paperFigureSet_normal(7);
    [c,f] = contourf(X,Y,Z);
    xlabel(contourfXlabelText);
    ylabel(contourfYlabelText);   
    set(f,'levelList',1:500:14000);
    if isSaveFigure
        set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch07'),'弯头式缓冲罐-长径比和体积的综合影响');
    end
    
    figure
    paperFigureSet_normal(7);
    hold on;
    for i=1:size(Y,1)
        h = plot(X(1,:),Z(i,:)./1000);
        plotColor = get(h,'color');
        plot(X(1,1:5:end),Z(i,1:5:end)./1000,'color',plotColor,'Marker',getMarkStyle(i)...
            ,'MarkerFaceColor',plotColor...
            ,'LineStyle','none');
    end
    ylim([3,15]);
    axValue = axis();
    for i=1:size(Y,1)
        text(axValue(2),Z(i,end)./1000,sprintf('%.2g',Y(i,1)));
    end
    xlabel(linePlotXlabelText);
    ylabel(linePlotYlabelText);
    annotation('textbox',...
    [0.820445209251103 0.947862758310871 0.120267361111111 0.0604761904761906],...
    'String',volumeText,...
    'FitBoxToText','off',...
    'EdgeColor','none');
    set(gca,'Position',[0.13 0.165345907788607 0.718072916666667 0.755880509667427]);
    box on;
    resetDefaultPlotFontName();
    if isSaveFigure
        set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch07'),'弯头式缓冲罐-长径比和体积的综合影响2');
    end
end