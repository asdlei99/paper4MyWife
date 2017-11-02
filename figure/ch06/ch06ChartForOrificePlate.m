%% ������ ��ͼ - �װ���ػ�ͼ
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
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
[expVesselDataCells,expVesselCombineData,simVesselDataCell] ...
    = loadExpAndSimDataFromFolder(vesselCombineDataPath);%��һ���������
[expOrific28MultHoleD01DataCells,expOrific28MultHoleD01CombineData] = loadExpDataFromFolder(orific28MultHoleD1CombineDataPath);
%�Աȵ���
orificDataCells = {expOrificD0_25CombineData,expOrificD0_5CombineData,expOrificD0_75CombineData,expOrificD01CombineData};
%���۽��
theDataCells = innerOrificTankChangD();
legendLabels = {'0.25D','0.5D','0.75D','1D'};
%% ������������
%ʱƵ������������
Fs = 100;%ʵ�������
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
%% ��ͼ 
%% ��������ģ��ʵ��
fh = figureExpAndSimThePressurePlus({expStraightLinkCombineData,expElbowLinkCombineData}...
                        ,{simStraightLinkDataCells,simElbowLinkDataCells}...
                        ,thePlusValue...
                        ,legendText...
                        ,'showMeasurePoint',0 ...
                        ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                        ,'expRang',expRang,'simRang',simRang...
                        ,'showVesselRigion',0,'ylim',[0,40]...
                        ,'xlim',[2,12]);
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
fh = figureExpPressurePlus(orificDataCells,legendLabels,'errorType',errorType...
    ,'showPureVessel',1,'purevessellegend','��һ�����');
set(fh.vesselHandle,'color','r');
%����0.25D��ѹ������������
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% ���ƶ���ѹ������������
fh = figureExpSuppressionLevel(orificDataCells,legendLabels,'errorType',errorType...
    ,'yfilterfunptr',@fixInnerOrificY ...
);
%% ���ƶ���ѹ����
fh = figureExpPressureDrop(orificDataCells,legendLabels,[2,3],'chartType','bar');
%'chartType'== 'bar' ʱ��������bar����ɫ
set(fh.barHandle,'FaceColor',getPlotColor(1));
%�Բ��1����ʱƵ��������
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%����1��Ƶ�ĶԱ�
%% ���Ʊ�Ƶ
fh = figureExpNatureFrequencyBar(orificDataCells,1,legendLabels);
fh = figureExpNatureFrequencyBar(orificDataCells,2,legendLabels);
fh = figureExpNatureFrequencyBar(orificDataCells,3,legendLabels);