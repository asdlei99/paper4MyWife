%% ������ ��ͼ - �ڲ����ػ�ͼ
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% ����·��
innerPipeD0_5CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ��\�ڲ��0.5D�м�420ת0.05mpa');
innerPipeD0_75CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ��\�ڲ��0.75D�м�420ת0.06mpa');
innerPipeD1CombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ��\�ڲ��1D���м�420ת0.05mpa');
vesselCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\RPM420');
%% �����ڲ���Լ����������
%0.5D,0.75D,1D�װ��ʵ��ģ������

[expInnerPipe0_5DataCells,expInnerPipe0_5CombineData,simInnerPipe0_5DataCell] ...
    = loadExpAndSimDataFromFolder(innerPipeD0_5CombineDataPath);
[expInnerPipe0_75DataCells,expInnerPipe0_75CombineData] ...
    = loadExpDataFromFolder(innerPipeD0_75CombineDataPath);
[expInnerPipe01DataCells,expInnerPipe01CombineData] ...
    = loadExpDataFromFolder(innerPipeD1CombineDataPath);
% simFixData = [2,3,4,4,3.5,3,-1,2,3,4,5,6,7,8,9,10,10,10,10];
% simOrificD0_25DataCell.rawData.pulsationValue(:) = simOrificD0_25DataCell.rawData.pulsationValue(:) + simFixData'; 
% simOrificD0_5DataCell.rawData.pulsationValue(:) = simOrificD0_5DataCell.rawData.pulsationValue(:) + simFixData';
% simOrificD0_75DataCell.rawData.pulsationValue(:) = simOrificD0_75DataCell.rawData.pulsationValue(:) + simFixData';
% simOrificD01DataCell.rawData.pulsationValue(:) = simOrificD01DataCell.rawData.pulsationValue(:) + simFixData';
%��һ���������
[expVesselDataCells,expVesselCombineData,simVesselDataCell] ...
    = loadExpAndSimDataFromFolder(vesselCombineDataPath);
fixSimVessel = constSimVesselPlusValueFix();
simVesselDataCell.rawData.pulsationValue(:) = simVesselDataCell.rawData.pulsationValue(:)+fixSimVessel';
%�Աȵ���
innerPipeDataCells = {expInnerPipe0_5CombineData,expInnerPipe0_75CombineData,expInnerPipe01CombineData};
legendLabels = {'0.5D','0.75D','1D'};
%% ������������
%ʱƵ������������
Fs = 100;%ʵ�������
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
isSaveFigure = 0;
%%
param.acousticVelocity = 345;%���٣�m/s��
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv1 = 1.1/2;
param.Lv2 = 1.1/2;
param.l = 0.01;%(m)����޵����ӹܳ�
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%�ܵ�ֱ����m��
param.Lbias = 0.168+0.150;
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2];
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.Lin = 0.200;
param.Lout = 0.200;
param.Dinnerpipe = param.Dpipe*0.5;


%% ���ƶ���ѹ������
if 0
	paperPlotInnerPipeExpCmp(innerPipeDataCells,legendLabels,isSaveFigure)
end

%% ��������ģ��ʵ��
if 0
    param.Dinnerpipe = 0.5 * param.Dpipe;
	paperPlotInnerPipeExpTheSim({expInnerPipe0_5CombineData,expInnerPipe0_75CombineData,expInnerPipe01CombineData}...
								,{simInnerPipe0_5DataCell,simInnerPipe0_5DataCell,simInnerPipe0_5DataCell}...
								,param...
								,isSaveFigure);
end

%% ���ƶ���ѹ������
if 0
    paperPlotInnerPipeExpPressureDrop(innerPipeDataCells,legendLabels,isSaveFigure);
end

%�Բ��1����ʱƵ��������
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%����1��Ƶ�ĶԱ�
%% ���Ʊ�Ƶ
if 0
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,1,legendLabels);
    set(fh.legend,'Location','northwest');
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,2,legendLabels);
    set(fh.legend,...
    'Position',[0.546070604348832 0.612951407221974 0.207256941947465 0.280752307323877]);
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,3,legendLabels);
end

%% ������չ����
if 0
    paperPlotInnerPipeTheory(param,isSaveFigure);
end

if 1
    paperPlotInnerPipeTheoryFrequencyResponse(param,isSaveFigure);
end

if 0
	dataPath = fullfile(dataPath,'ģ������\ɨƵ����\���1kgs������������ѹ��\ʵ�鳤��\���޲����������ڲ�0.5D�ܱտ�-��M���н��ڱ߽�');
	figureSimFrequencyResponse(dataPath,[],'type','contourf');
    xlim([0,50]);
end