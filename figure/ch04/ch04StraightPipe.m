%% ������ ��ͼ - ֱ��

clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
theoryOnly = 1;
%% ����·��
if ~theoryOnly
	straightPipeDataPath = fullfile(dataPath,'ʵ��ԭʼ����\��ֱ��\RPM420-0.1MPa');%ֱ��

	%% ��������
	[straightPipeDataCells,straightPipeCombineData,straightPipeSimData] ...
		= loadExpAndSimDataFromFolder(straightPipeDataPath);
end

param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 350;%���٣�m/s��
param.isDamping = 1;
param.coeffFriction = 0.0005;
param.meanFlowVelocity = 16;
param.L = 10.5;
param.Dpipe = 0.098;%�ܵ�ֱ����m��
param.sectionL = 0:0.5:param.L;%linspace(0,param.L1,14);
param.outDensity = 1.5608;
param.notMach = 0;
%% ��ͼ 
% 
% 
isSavePlot = 0;

%% ʵ�����ݷ���
if 0
 	paperPlot04StraightPipeExpSimThe(straightPipeCombineData,straightPipeSimData,param,isSavePlot);
end
%% ����ѹ������Ƶ��
if 0
 	paperPlot04StraightPipePressureAndFrequency(straightPipeDataCells{1,2}.subSpectrumData,isSavePlot);
end

%% �������в���ʱƵ����
if 0
    paperPlot04StraightPipeSTFT(straightPipeDataCells{1,2}.rawData,isSavePlot);
end

%% ɨƵ���ݷ���
if 0
% 	sweepResult = loadExperimentPressureData(fullfile(dataPath,'��ֱ�ܿ���450��300ת0.05mpa.CSV'));
	sweepResult = loadExperimentPressureData(fullfile(dataPath,'ʵ��ԭʼ����\��ֱ��\RPM420-0.1MPa\��ֱ�ܿ���450��300ת0.05mpa.CSV'));
	paperPlot04StraightPipeSweepFrequency(sweepResult,isSavePlot);
end


if 0
    fh = figureExpPressurePlus(straightPipeCombineData...
        ,'errorType','ci'...
        ,'showPureVessel',0);
end

%����1��Ƶ�ĶԱ�
%% ���Ʊ�Ƶ
if 0
	paperPlot04StraightPipeNatureFrequency(straightPipeCombineData,isSavePlot);
end

%% ���� - ֱ�ܹܾ���������Ӱ��
if 0
	paperPlot04StraightPipeTheory(param,isSavePlot);
end

if 1
    paperPlot04StraightPipeTheoryFrequencyResponse(param,isSavePlot);
end

