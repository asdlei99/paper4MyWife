%% ������ ��ͼ - ��һ�����������չ����
clear all;
close all;
clc;

freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];

%% ��һ����ޱ䳤���ȶ�����������Ӱ��
Dv = 0.2:0.05:0.9;%�����ֱ���仯
theoryDataCells = oneVesselChangLengthDiameterRatio('massflowdata',[freRaw;massFlowERaw]...
                                                    ,'Dv',Dv...
                                                    );
res = theoryDataCells(2:end,2);
X = theoryDataCells(2:end,7);
for i=2:size(theoryDataCells,1)
    labels{i-1} = sprintf('%g,(Dv:%g)',theoryDataCells{i,6},theoryDataCells{i,5});
    Y(i-1) = theoryDataCells{i,6};
end
figureTheoryPressurePlus(res,X,'Y',Y,'yLabelText','������');
