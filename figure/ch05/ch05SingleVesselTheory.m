%% 第五章 绘图 - 单一缓冲罐理论扩展分析
clear all;
close all;
clc;

freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
Dpipe = 0.098;
Dv = 0.372;
%% 缓冲罐改变体积对气流脉动的影响
Vmin = pi* Dpipe^2 / 4 * 1.1 *1.5;
Vmid = pi* Dv^2 / 4 * 1.1;
Vmax = Vmid*3;
VApi618 = 0.1;
V = Vmin:0.02:Vmax;
theoryDataCellsChangVolume = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                    );
chartTypeChangVolume = 'surf';
resChangVolume = theoryDataCellsChangVolume(2:end,2);
XChangVolume = theoryDataCellsChangVolume(2:end,3);
sectionX = [2,7,10];
markSectionXLabel = {'b','c','d'};
fh = figureTheoryPressurePlus(resChangVolume,XChangVolume,'Y',V...
    ,'yLabelText','体积'...
    ,'chartType',chartTypeChangVolume...
    ,'edgeColor','none'...
    ,'sectionY',Vmid...
    ,'markSectionY','all'...
    ,'markSectionYLabel',{'a'}...
    ,'sectionX',sectionX ...
    ,'markSectionX','all'...
    ,'markSectionXLabel',markSectionXLabel...
    ,'fixAxis',1 ...
);
view(-161,37);
highLowColorbar();
%绘制sectionX对应截面的图形
if strcmp(chartTypeChangVolume,'surf')
    h = [];
    figure
    paperFigureSet_normal();
    for i = 1:length(fh.sectionXHandle.data)
        x = fh.sectionXHandle.data(i).x(1);
        labels{i} = sprintf('%s-%s(L=%g)',markSectionXLabel{i},markSectionXLabel{i},x);
        x = fh.sectionXHandle.data(i).y;
        y = fh.sectionXHandle.data(i).z;
        hold on;
        h(i) = plot(x,y,'color',getPlotColor(i),'marker',getMarkStyle(i));
    end
    box on;
    legend(h,labels,'FontName',paperFontName(),'FontSize',paperFontSize());
    hm = plotXMarkerLine(Vmid,':k');
    hm = plotXMarkerLine(VApi618,'--r');
    xlabel('缓冲罐体积(m^3)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel('脉动峰峰值(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
end
%% 单一缓冲罐变长径比对气流脉动的影响

Lv = 0.5:0.1:3;


theoryDataCellsChangLengthDiameterRatio = oneVesselChangLengthDiameterRatio('massflowdata',[freRaw;massFlowERaw]...
                                                    ,'Lv',Lv...
                                                    );
resChangLengthDiameterRatio = theoryDataCellsChangLengthDiameterRatio(2:end,2);
XChangLengthDiameterRatio = theoryDataCellsChangLengthDiameterRatio(2:end,3);
r = 1.1 / 0.372;
for i=2:size(theoryDataCellsChangLengthDiameterRatio,1)
   % labels{i-1} = sprintf('%g,(Lv:%g)',theoryDataCellsChangLengthDiameterRatio{i,6},theoryDataCellsChangLengthDiameterRatio{i,4});
    YChangLengthDiameterRatio(i-1) = theoryDataCellsChangLengthDiameterRatio{i,6};
end
fh = figureTheoryPressurePlus(resChangLengthDiameterRatio,XChangLengthDiameterRatio...
    ,'Y',YChangLengthDiameterRatio...
    ,'yLabelText','长径比'...
    ,'chartType','surf'...
    ,'edgeColor','none'...
    ,'sectionY',r...
    ,'markSectionY','all'...
    ,'markSectionYLabel',{'a'}...
);
view(-41,20);
highLowColorbar();

%% 缓冲罐改变接管位置对气流脉动的影响
theoryDataCellsChangL1 = oneVesselChangL1FixL('massflowdata',[freRaw;massFlowERaw]);
resChangL1 = theoryDataCellsChangL1(2:end,2);
XChangL1 = theoryDataCellsChangL1(2:end,3);
YChangL1 = cell2mat(theoryDataCellsChangL1(2:end,4));
fh = figureTheoryPressurePlus(resChangL1,XChangL1...
    ,'Y',YChangL1...
    ,'yLabelText','缓冲罐距压缩机出口距离(m)'...
    ,'chartType','contourf'...
    ,'edgeColor','none'...
);
plot([YChangL1(1),YChangL1(end)],[YChangL1(1),YChangL1(end)],'--r');
colorbar;