%% 第五章 绘图 - 单一缓冲罐理论扩展分析
clear all;
close all;
clc;

freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
Dpipe = 0.098;
Dv = 0.372;
%% 
Vmin = pi* Dpipe^2 / 4 * 1.1 *1.5;
Vmid = pi* Dv^2 / 4 * 1.1;
Vmax = Vmid*3;
V = Vmin:0.02:Vmax;
theoryDataCells = oneVesselChangVolume(V,'massflowdata',[freRaw;massFlowERaw]...
                                                    );
res = theoryDataCells(2:end,2);
X = theoryDataCells(2:end,3);
for i = 1:length(V)
    labels{i} = sprintf('V:%g',V(i));
end
fh = figureTheoryPressurePlus(res,X,'Y',V...
    ,'yLabelText','体积'...
    ,'chartType','surf'...
    ,'edgeColor','none'...
    ,'sectionY',Vmid...
    ,'markSectionY','all'...
);
view(-123,12);
highLowColorbar();                                        
%% 单一缓冲罐变长径比对气流脉动的影响

Lv = 0.5:0.1:3;


theoryDataCells = oneVesselChangLengthDiameterRatio('massflowdata',[freRaw;massFlowERaw]...
                                                    ,'Lv',Lv...
                                                    );
res = theoryDataCells(2:end,2);
X = theoryDataCells(2:end,3);
r = 1.1 / 0.372;
for i=2:size(theoryDataCells,1)
    labels{i-1} = sprintf('%g,(Lv:%g)',theoryDataCells{i,6},theoryDataCells{i,4});
    Y(i-1) = theoryDataCells{i,6};
end
fh = figureTheoryPressurePlus(res,X,'Y',Y...
    ,'yLabelText','长径比'...
    ,'chartType','surf'...
    ,'edgeColor','none'...
    ,'sectionY',r...
    ,'markSectionY','all'...
);
view(-41,20);
highLowColorbar();