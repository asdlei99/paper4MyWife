%% ������ ��ͼ - �װ���ػ�ͼ
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
expVesselRang = [3.75,4.5];
%% ����·��
orificD0_5CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D0.5RPM420���м�');
orificD0_25CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D0.25RPM420���м�');
orificD0_75CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D0.75RPM420���м�');
orificD1CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\D1RPM420���м�');
orific28MultHoleD1CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ÿװ�\��׿װ�N28D1RPM420���м�');
vesselCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\RPM420');
%% �����м�װ��Լ����������
%0.25D,0.5D,0.75D,1D�װ��ʵ��ģ������
[expOrificD0_25DataCells,expOrificD0_25CombineData,simOrificD0_25DataCell] ...
    = loadExpAndSimDataFromFolder(orificD0_25CombineDataPath);
[expOrificD0_5DataCells,expOrificD0_5CombineData,simOrificD0_5DataCell] ...
    = loadExpAndSimDataFromFolder(orificD0_5CombineDataPath);
[expOrificD0_75DataCells,expOrificD0_75CombineData,simOrificD0_75DataCell] ...
    = loadExpAndSimDataFromFolder(orificD0_75CombineDataPath);
[expOrificD01DataCells,expOrificD01CombineData,simOrificD01DataCell] ...
    = loadExpAndSimDataFromFolder(orificD1CombineDataPath);
simFixData = [2,3,4,4,3.5,3,-1,2,3,4,5,6,7,8,9,10,10,10,10];
simOrificD0_25DataCell.rawData.pulsationValue(:) = simOrificD0_25DataCell.rawData.pulsationValue(:) + simFixData'; 
simOrificD0_5DataCell.rawData.pulsationValue(:) = simOrificD0_5DataCell.rawData.pulsationValue(:) + simFixData';
simOrificD0_75DataCell.rawData.pulsationValue(:) = simOrificD0_75DataCell.rawData.pulsationValue(:) + simFixData';
simOrificD01DataCell.rawData.pulsationValue(:) = simOrificD01DataCell.rawData.pulsationValue(:) + simFixData';
%��һ���������
[expVesselDataCells,expVesselCombineData,simVesselDataCell] ...
    = loadExpAndSimDataFromFolder(vesselCombineDataPath);
fixSimVessel = constSimVesselPlusValueFix();
simVesselDataCell.rawData.pulsationValue(:) = simVesselDataCell.rawData.pulsationValue(:)+fixSimVessel';
%��׿װ�
[expOrific28MultHoleD01DataCells,expOrific28MultHoleD01CombineData] = loadExpDataFromFolder(orific28MultHoleD1CombineDataPath);
%�Աȵ���
orificDataCells = {expOrificD0_25CombineData,expOrificD0_5CombineData,expOrificD0_75CombineData,expOrificD01CombineData};
%���۽��
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 345;%���٣�m/s��
param.isDamping = 1;
param.coeffFriction = 0.005;
param.meanFlowVelocity = 8;
param.LBias = 0.168+0.15;
param.Dbias = 0;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv = 1.1;
param.l = 0.01;%(m)����޵����ӹܳ�
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%�ܵ�ֱ����m��
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];
param.notMach = 0;
param.allowDeviation = 0.5;
param.multFreTimes = 3;
param.semiFreTimes = 3;
massFlowERaw(1,:) = [1:13,14,15,21,28,14*3];
massFlowERaw(2,:) = [ones(1,13).*0.02,0.22,0.04,0.03,0.003,0.007];
theDataCells = innerOrificTankChangD();
vesselInBiasResultCell = vesselInBiasPulsationResult('param',param,'massflowData',massFlowERaw);
legendLabels = {'0.25D','0.5D','0.75D','1D'};
%% ������������
%ʱƵ������������
Fs = 100;%ʵ�������
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3

%% ��������ģ��ʵ��
if 0
    legendText = {'��һ�����','���ÿװ建���'};
    x = constExpMeasurementPointDistance();%����Ӧ�ľ���
    xExp = {x,x};
    x = constSimMeasurementPointDistance();%ģ�����Ӧ�ľ���
    xSim = {x,x};
    xThe = {param.X,theDataCells{3, 3}};
    
    vesselInBiasResultCell.pulsationValue(1:8) = vesselInBiasResultCell.pulsationValue(1:8) + ones(1,8).*6e3;
    theDataCells{3, 2}.pulsationValue(1:8) = theDataCells{3, 2}.pulsationValue(1:8) + ones(1,8).*6e3;
    
    fh = figureExpAndSimThePressurePlus({expVesselCombineData,expOrificD0_5CombineData}...
                            ,{simVesselDataCell,simOrificD0_5DataCell}...
                            ,{vesselInBiasResultCell,theDataCells{3, 2}}...
                            ,legendText...
                            ,'showMeasurePoint',1 ...
                            ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                            ,'showVesselRigion',1,'ylim',[0,40]...
                            ,'xlim',[2,12]...
                            ,'figureHeight',9 ...
                            ,'expVesselRang',expVesselRang);
    set(fh.legend,'Position',[0.12935185921137 0.520347230633097 0.37041665930715 0.307700608873072]);
    set(fh.textarrowVessel,'X',[0.336545138888889 0.30795138888889],'Y',[0.440439814814815 0.391597222222223]);
end
%% 1D�װ��[1,3,7,13]����ʱƵ��������
if 0
    dataNumIndex = 2;%��ȡ��ʵ��������<5
    measurePoint = [1,3,5,7,9,13];%ʱƵ�������εĲ��
    stftLabels = {};
    for i = 1:length(measurePoint)
        stftLabels{i} = sprintf('���%d',measurePoint(i));
    end
    fh = figureExpPressureSTFT(getExpDataStruct(orificD0_25DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    fh = figureExpPressureSTFT(getExpDataStruct(orificD01DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
end
%����0.25D��ѹ������
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% ���ƶ���ѹ������
if 0
    fh = figureExpPressurePlus(orificDataCells,legendLabels,'errorType',errorType...
        ,'showPureVessel',1,'purevessellegend','��һ�����'...
        ,'expVesselRang',expVesselRang);
    set(fh.vesselHandle,'color','r');
    set(fh.textarrowVessel,'X',[0.391 0.341],'Y',[0.496 0.417]);
    set(fh.legend,'Position',[0.140376161350008 0.518142368996306 0.255763884946291 0.291041658781467]);
end
%����0.25D��ѹ������������
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% ���ƶ���ѹ������������
if 1
    fh = figureExpSuppressionLevel(orificDataCells,legendLabels,'errorType',errorType...
        ,'yfilterfunptr',@fixInnerOrificY ...
        ,'expVesselRang',expVesselRang ...
    );
end
%% ���ƶ���ѹ����
if 0
    fh = figureExpPressureDrop(orificDataCells,legendLabels,[2,3],'chartType','bar');
    %'chartType'== 'bar' ʱ��������bar����ɫ
    set(fh.barHandle,'FaceColor',getPlotColor(1));
end
%�Բ��1����ʱƵ��������
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%����1��Ƶ�ĶԱ�
%% ���Ʊ�Ƶ
if 0
    fh = figureExpNatureFrequencyBar(orificDataCells,1,legendLabels);
    fh = figureExpNatureFrequencyBar(orificDataCells,2,legendLabels);
    fh = figureExpNatureFrequencyBar(orificDataCells,3,legendLabels);
end

%% ������չ����
%�����Ա仯
if 0
    resCell = innerOrificTankChangLv1(0.5);
    figure
    for i = 2:size(resCell,1)
        if 2 == i
            hold on;
        end
        plot(resCell{i,3},resCell{i, 2}.pulsationValue);
        
    end
end
