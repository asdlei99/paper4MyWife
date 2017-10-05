%% ������ ��ͼ - ˫�޹޶�����ͷ���۷����Ա�
%�����»�ͼ�Ĳ�������clear all;
% close all;
clc;
freRaw = [7,14,21,28,14*3];
massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
%% ���������Ӧ
if 1
    theoryDataCells = doubleVesselBeElbowShockResponse();
    fh = plotSpectrumContourf(theoryDataCells{1, 2}.Mag',theoryDataCells{1, 2}.Fre',theoryDataCells{1,3});
    xlim([0,100]);
end
%% �ı�ڶ�������޵���һ������޾����������Ӱ��
if 1 % �ı�ڶ�������޵���һ������޾����������Ӱ��
    theoryDataCells = doubleVesselBeElbowChangDistanceToFirstVessel('massflowdata',[freRaw;massFlowERaw]...
        ,'meanFlowVelocity',14);
    plusValue = theoryDataCells(2:end,2);
    X = theoryDataCells(2:end,3);
    legendLabels = theoryDataCells(2:end,1);
    linkPipeLength = cell2mat(theoryDataCells(2:end,5));
    fh = figureTheoryPressurePlus(plusValue,X...
        ,'Y',linkPipeLength...
        ,'legendLabels',legendLabels...
        ,'yLabelText','�ӹܳ�'...
        ,'chartType','surf'...
        ,'edgeColor','none'...
    );
end
