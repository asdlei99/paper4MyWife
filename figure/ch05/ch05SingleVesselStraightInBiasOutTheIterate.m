clear all;
close all;
%��һ��������۵�
%% ����޼���Ĳ�������
vType = 'straightInBiasOut';
if 1
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
    coeffFriction = 0.02;
    meanFlowVelocity = 12;
    param.coeffFriction = coeffFriction;
    param.meanFlowVelocity = meanFlowVelocity;
    freRaw = [14,21,28,42,56,70];
    massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];
else
    
    param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ��??
    param.rpm = 420;
    param.outDensity = 1.5608;
    param.Fs = 4096;
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

    param.acousticVelocity = 320;%���٣�m/s��
    param.coeffFriction = 0.03;
    param.meanFlowVelocity = 13;

    freRaw = [14,21,28,42,56,70];
    massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];

end
%% 1����������
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
    set(get(ch,'Label'),'String','ѹ���������ֵ(kPa)');
    colormap jet;
end

%% ����ƫ�þ���ͳ�����
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
        xlabel('ƫ�þ���l1(m)','FontSize',paperFontSize());%l1����lv1
        ylabel('������','FontSize',paperFontSize());
        zlabel('ѹ���������ֵ(kPa)','FontSize',paperFontSize());
        ch = colorbar();
        set(get(ch,'Label'),'String','ѹ���������ֵ(kPa)','FontSize',paperFontSize(),'FontName',paperFontName());
        box on;
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('ֱ����������-�����Ⱥ�ƫ�þ��������ͼ(%g)',X(1,indexs(i))));
    end
    
    
end

%% ���������lv1��ƫ����ڹܳ�
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
    xlabel('ƫ�þ���(m)','FontSize',paperFontSize());
    ylabel('ѹ������(kPa)','FontSize',paperFontSize());
    title('(a)','FontSize',paperFontSize());
    set(gca,'color','none');
    subplot(1,2,2)
    h = plot(Lv1,y(2,:),'color',getPlotColor(2),'marker',getMarkStyle(2));
    set(gca,'XTick',0:0.2:1);
    xlabel('ƫ�þ���(m)','FontSize',paperFontSize());
    ylabel('ѹ������(kPa)','FontSize',paperFontSize());
    title('(b)','FontSize',paperFontSize());
    set(gca,'color','none');
    saveFigure(fullfile(getPlotOutputPath(),'ch05'),'ֱ����������ƫ�þ��������������Ӱ��');
end

%�ȷ�ֵɨƵ
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
		%���������ʣ�����ֱ��
	end
	
	
end

