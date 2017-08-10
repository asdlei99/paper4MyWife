%% ������ ��ͼ - ��һ�����������չ����
clear all;
close all;
clc;

freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];

%% ��һ����ޱ䳤���ȶ�����������Ӱ��

Lv = 0.5:0.1:3;


theoryDataCells = oneVesselChangLengthDiameterRatio('massflowdata',[freRaw;massFlowERaw]...
                                                    ,'Lv',Lv...
                                                    );
res = theoryDataCells(2:end,2);
X = theoryDataCells(2:end,7);
r = 1.1 / 0.372;
for i=2:size(theoryDataCells,1)
    labels{i-1} = sprintf('%g,(Lv:%g)',theoryDataCells{i,6},theoryDataCells{i,4});
    Y(i-1) = theoryDataCells{i,6};
end
fh = figureTheoryPressurePlus(res,X,'Y',Y...
    ,'yLabelText','������'...
    ,'chartType','surf'...
    ,'edgeColor','none'...
    ,'sectionY',r...
    ,'markSectionY','all'...
);
colorbar;