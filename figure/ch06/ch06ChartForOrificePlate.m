%% ������ ��ͼ - �װ���ػ�ͼ
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
expVesselRang = constExpVesselRangDistance;
theoryOnly = 0;
isSaveFigure = 1;
if ~theoryOnly
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
    
    expOrificD0_5CombineData.readPlus(:,3) = expOrificD0_5CombineData.readPlus(:,3) - 2;
    expOrificD01CombineData.readPlus(:,3) = expOrificD01CombineData.readPlus(:,3) - 2;
    
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
end
%���۽��
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 1024;
param.acousticVelocity = 345;%���٣�m/s��
param.isDamping = 1;
param.coeffFriction = 0.038;
param.meanFlowVelocity = 16;
param.LBias = 0.168+0.15;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv = 1.1;
param.Lv1 = 1.1/2;
param.Lv2 = 1.1/2;
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
param.baseFrequency = 14;

massFlowERaw(1,:) = [1:13,14,15,21,28,14*3];
massFlowERaw(2,:) = [ones(1,13).*0.02,0.22,0.04,0.03,0.003,0.007];


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
    paperPlotOrificeExpSimThe(expOrificD0_5CombineData,simOrificD0_5DataCell,param,massFlowERaw,isSaveFigure);
end
%% 1D�װ��[1,3,7,13]����ʱƵ��������
if 0
    dataNumIndex = 2;%��ȡ��ʵ��������<5
    measurePoint = [1,3,5,7,9,13];%ʱƵ�������εĲ��
    stftLabels = {};
    for i = 1:length(measurePoint)
        stftLabels{i} = sprintf('���%d',measurePoint(i));
    end
    fh = figureExpPressureSTFT(getExpDataStruct(expOrificD0_25DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    colormap jet;
    if isSaveFigure
        saveFigure(fullfile(getPlotOutputPath(),'ch06'),'����0.25D�װ�ṹʱƵ������ͼ');
    end
    
    fh = figureExpPressureSTFT(getExpDataStruct(expOrificD01DataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
    colormap jet;
    if isSaveFigure
        saveFigure(fullfile(getPlotOutputPath(),'ch06'),'����1D�װ�ṹʱƵ������ͼ');
    end
end

%% ���ƶ���ѹ������������
if 1
    paperPlotOrificeExpCmp(orificDataCells,legendLabels,isSaveFigure);
end
%% ���ƶ���ѹ����
if 0
    fh = figureExpPressureDrop(orificDataCells,legendLabels,[2,3],'chartType','bar');
    %'chartType'== 'bar' ʱ��������bar����ɫ
    set(fh.barHandle,'FaceColor',getPlotColor(1));
    if isSaveFigure
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch06'),'���ÿװ�-ʵ��ѹ����');
    end
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
%


if 0
    useModifyValue = 1;
    paperPlotOrificeTheChangeL1(useModifyValue,param,massFlowERaw,isSaveFigure);
end


if 0
    paperPlotOrificeTheChangeOrificeD(param,massFlowERaw,isSaveFigure);
end

if 0
	dataPath = fullfile(dataPath,'ģ������\ɨƵ����\���1kgs������������ѹ��\ʵ�鳤��\���޲����������ڲ�0.5D�װ�տ�-��M���н��ڱ߽�');
	figureSimFrequencyResponse(dataPath,[],'type','contourf');
    xlim([0,100]);
end


if 0
    paperPlotOrificePlateTheoryFrequencyResponse(param,isSaveFigure);
end