clear all;
close all;
%单一缓冲罐理论迭
%% 缓冲罐计算的参数设置
vType = 'straightInBiasOut';
if 1
    param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密??
    param.rpm = 420;
    param.outDensity = 1.5608;
    param.Fs = 4096;
    param.acousticVelocity = 335;%声速（m/s）
    param.isDamping = 1;
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
    coeffFriction = 0.02;
    meanFlowVelocity = 12;
    param.coeffFriction = coeffFriction;
    param.meanFlowVelocity = meanFlowVelocity;
    freRaw = [14,21,28,42,56,70];
    massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
else
    
    param.isOpening = 0;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密??
    param.rpm = 420;
    param.outDensity = 1.5608;
    param.Fs = 4096;
    param.isDamping = 1;
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

    param.acousticVelocity = 320;%声速（m/s）
    param.coeffFriction = 0.03;
    param.meanFlowVelocity = 13;

    freRaw = [14,21,28,42,56,70];
    massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];

end
%% 1迭代长径比
if 0
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
    %chartType = 'surf';
    chartType = 'contourf';
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
    ch = colorbar();
    set(get(ch,'Label'),'String','压力脉动峰峰值(kPa)');
    colormap jet;
end

%% 迭代偏置距离和长径比
if 0
     %chartType = 'surf';
     chartType = 'contourf';
     
    endIndex = length(param.sectionL1) + length(param.sectionL2);
    indexs = 1:7:endIndex;
    if indexs(end) ~= endIndex
        indexs = [indexs,endIndex];
    end
    Lv = linspace(0.3,3,42);
    lv1 = linspace(0,param.Lv-param.Dpipe,32);
    
    [X,Y,Zc] = oneVesselChangBiasLengthAndAspectRatio(lv1,Lv,indexs...
        ,'vType','straightInBiasOut'...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param);
    for i = 1:length(Zc)
        Z = Zc{i}./1000;
        figure
        paperFigureSet_normal(9);
        if strcmpi(chartType,'surf')
            surf(X,Y,Z);
            view(131,29);
        else
            [C,h] = contourf(X,Y,Z,'ShowText','on','LevelStep',0.2);
        end
        colorbar();
        colormap jet;
        xlabel('偏置距离l1(m)','FontSize',paperFontSize());%l1就是lv1
        ylabel('长径比','FontSize',paperFontSize());
        zlabel('压力脉动峰峰值(kPa)','FontSize',paperFontSize());
        ch = colorbar();
        set(get(ch,'Label'),'String','压力脉动峰峰值(kPa)','FontSize',paperFontSize(),'FontName',paperFontName());
        box on;
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('直进侧出缓冲罐-长径比和偏置距离迭代云图(%g)',X(1,indexs(i))));
    end
    
    
end

%% 迭代缓冲罐lv1的偏置入口管长
if 0
    chartType = 'contourf';
    Lv1 = 0:0.05:1;
    
    theoryDataCellsChangLv1 = oneVesselChangLv1(Lv1...
        ,'vType','straightInBiasOut'...
        ,'massflowdata',[freRaw;massFlowERaw]...
        ,'param',param);
    %x
    xCells = theoryDataCellsChangLv1(2:end,3);
    %y
    zCells = theoryDataCellsChangLv1(2:end,2);
%     fh = figureTheoryPressurePlus(zCells,xCells,'Y',Lv1...
%         ,'yLabelText','Lv1'...
%         ,'chartType',chartType...
%         ,'fixAxis',1 ...
%         ,'edgeColor','none'...
%         ,'sectionY',param.lv1...
%         ,'markSectionY','all'...
%         ,'markSectionYLabel',{'a'}...
%         );
    index = find(xCells{1} > 2);
    index = index(1);
    meaPoint = [index,length(zCells{1, 1}.pulsationValue)];
    y = zeros(length(meaPoint),length(Lv1));
    for i=1:length(Lv1)
        y(:,i) = zCells{i}.pulsationValue(meaPoint)';
    end
    y = y ./ 1000;
    figure
    paperFigureSet('full',6);
    subplot(1,2,1)
    h = plot(Lv1,y(1,:),'color',getPlotColor(1),'marker',getMarkStyle(1));
    set(gca,'XTick',0:0.2:1);
    xlabel('偏置距离(m)','FontSize',paperFontSize());
    ylabel('压力脉动(kPa)','FontSize',paperFontSize());
    title('(a)','FontSize',paperFontSize());
    set(gca,'color','none');
    subplot(1,2,2)
    h = plot(Lv1,y(2,:),'color',getPlotColor(2),'marker',getMarkStyle(2));
    set(gca,'XTick',0:0.2:1);
    xlabel('偏置距离(m)','FontSize',paperFontSize());
    ylabel('压力脉动(kPa)','FontSize',paperFontSize());
    title('(b)','FontSize',paperFontSize());
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'直进侧出缓冲罐偏置距离对气流脉动的影响');
end

%等幅值扫频
if 0
	addtion = -10:1:70;
	
	for i = 1:length(addtion)
		fre = freRaw+addtion(i);
		baseFrequency = 14 + addtion(i);
		res{i} = oneVesselPulsation('massflowdata',[fre;massFlowERaw]...
							, 'param', param ...
							, 'vType', vType ...
							, 'baseFrequency', baseFrequency...
							, 'multFreTimes', 1 ...
							, 'semiFreTimes', 1 ...
								);
		%脉动抑制率，还需直管
	end
	
	
end

