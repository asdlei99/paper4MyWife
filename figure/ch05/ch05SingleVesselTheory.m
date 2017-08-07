%% 第五章 绘图 - 单一缓冲罐理论扩展分析
clear all;
close all;
clc;
%% 单一缓冲罐变长径比对气流脉动的影响
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
Dv = 0.2:0.05:0.9;%缓冲罐直径变化
theoryDataCells = oneVesselChangLengthDiameterRatio('massflowdata',[freRaw;massFlowERaw]...
                                                    ,'Dv',Dv...
                                                    );
res = theoryDataCells(2:end,2);
X = theoryDataCells(2:end,7);
for i=2:size(theoryDataCells,1)
    labels{i-1} = sprintf('%g,(Dv:%g)',theoryDataCells{i,6},theoryDataCells{i,5});
end
figureTheoryPressurePlus(res,X,labels);