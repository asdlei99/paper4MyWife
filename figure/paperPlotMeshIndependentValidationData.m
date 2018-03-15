%�����޹�����֤����

clear;
dataPath = getDataPath();
detalTime = 0.0005;
startPresent = 0.3;
endPresent = 0.9;
lineWidth = 1.5;
if 0
    %�װ�������޹�ϵ��֤
    dataIndex = 18;
    simDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D0.5RPM420���м�\');
    simDataStruct = loadSimDataStructCellFromFolderPath(simDataPath);
    res = makeMeshIndependentValidation(simDataStruct,dataIndex);
    startIndex = floor(size(res,1)*startPresent);
    endIndex = floor(size(res,1)*endPresent);
    res = res(startIndex:endIndex,:);

    x = 0:1:(size(res,1)-1);
    x = x .* detalTime;
    legendText = {'326,582','724,456','1,421,002'};
    figure
    set(gcf,'color','w');
    set(gcf,'unit','centimeter','position',[8,4,8.5,6]);
    hold on;
    h(1) = plot(x,res(:,3),'-.','color',getPlotColor(3),'LineWidth',lineWidth);
    h(2) = plot(x,res(:,1),'-','color',getPlotColor(1),'LineWidth',lineWidth);
    h(3) = plot(x,res(:,2),'--','color',getPlotColor(2),'LineWidth',lineWidth);
    
    xlim([0 0.04]);
    legendHandle = legend(h,legendText,'Orientation','horizontal','color','none');
    set(legendHandle,'Position',[0.00440971899421878 0.880474539139761 0.989982624892662 0.0970138867861695]);
    set(gca,'Position',[0.1509375 0.179016148252809 0.780520833333333 0.649213018413858]);
    box on;
    xlabel('ʱ��(s)','FontSize',paperFontSize());
    ylabel('ѹ��(kPa)','FontSize',paperFontSize());
    x = constSimMeasurementPointDistance();
    fprintf('�������%gm��',x(end)-x(dataIndex));
    
    if 0
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch06'),'���ÿװ�-�����޹�����֤ͼ');
    end
end

if 0
    %�ڲ�ܵ������޹�ϵ��֤
    dataIndex = 12;
    simDataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ��\�ڲ��0.5D�м�420ת0.05mpa\');
    simDataStruct = loadSimDataStructCellFromFolderPath(simDataPath);
    res = makeMeshIndependentValidation(simDataStruct,dataIndex);
    startIndex = floor(size(res,1)*startPresent);
    endIndex = floor(size(res,1)*endPresent);
    res = res(startIndex:endIndex,:);

    x = 0:1:(size(res,1)-1);
    x = x .* detalTime;
    legendText = {'300,992','663,228','1,263,225'};
    figure
    set(gcf,'color','w');
    set(gcf,'unit','centimeter','position',[8,4,8.5,6]);
    hold on;
    h(1) = plot(x,res(:,3),'-.','color',getPlotColor(3),'LineWidth',lineWidth);
    h(2) = plot(x,res(:,1),'-','color',getPlotColor(1),'LineWidth',lineWidth);
    h(3) = plot(x,res(:,2),'--','color',getPlotColor(2),'LineWidth',lineWidth);
    
    xlim([0 0.04]);
    legendHandle = legend(h,legendText,'Orientation','horizontal','color','none');
    set(legendHandle,'Position',[0.00440971899421878 0.880474539139761 0.989982624892662 0.0970138867861695]);
    set(gca,'Position',[0.1509375 0.179016148252809 0.780520833333333 0.649213018413858]);
    box on;
    xlabel('ʱ��(s)','FontSize',paperFontSize());
    ylabel('ѹ��(kPa)','FontSize',paperFontSize());
    x = constSimMeasurementPointDistance();
    fprintf('�������%gm��',x(dataIndex));
    
    if 0
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch06'),'�����˲���-�����޹�����֤ͼ');
    end
end

if 1
    %�׹ܵ������޹�ϵ��֤
    dataIndex = 18;
    simDataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ�׹�\D0.5N68RPM420��ͷ��\');
    simDataStruct = loadSimDataStructCellFromFolderPath(simDataPath);
    res = makeMeshIndependentValidation(simDataStruct,dataIndex);
    startIndex = floor(size(res,1)*startPresent);
    endIndex = floor(size(res,1)*endPresent);
    res = res(startIndex:endIndex,:);

    x = 0:1:(size(res,1)-1);
    x = x .* detalTime;
    legendText = {'1,004,324','2,025,482','3,983,892'};
    figure
    set(gcf,'color','w');
    set(gcf,'unit','centimeter','position',[8,4,8.5,6]);
    hold on;
    h(1) = plot(x,res(:,3),'-.','color',getPlotColor(3),'LineWidth',lineWidth);
    h(2) = plot(x,res(:,1),'-','color',getPlotColor(1),'LineWidth',lineWidth);
    h(3) = plot(x,res(:,2),'--','color',getPlotColor(2),'LineWidth',lineWidth);
    
    xlim([0 0.04]);
    legendHandle = legend(h,legendText,'Orientation','horizontal','color','none');
    set(legendHandle,'Position',[0.00440971899421878 0.880474539139761 0.989982624892662 0.0970138867861695]);
    set(gca,'Position',[0.1509375 0.179016148252809 0.780520833333333 0.649213018413858]);
    box on;
    xlabel('ʱ��(s)','FontSize',paperFontSize());
    ylabel('ѹ��(kPa)','FontSize',paperFontSize());
    x = constSimMeasurementPointDistance();
    fprintf('�������%gm��',x(dataIndex));
    
    if 0
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch06'),'���ö�״��׹�-�����޹�����֤ͼ');
    end
end

