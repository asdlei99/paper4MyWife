%% ������ ��ͼ - ֱ��

clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% ����·��
if 1
straightPipeDataPath = fullfile(dataPath,'ʵ��ԭʼ����\��ֱ��\RPM420-0.1MPa');%ֱ��

%% ��������
[straightPipeDataCells,straightPipeCombineData] ...
    = loadExpDataFromFolder(straightPipeDataPath);
end


%% ��ͼ 
isSavePlot = 0;

%% ʵ�����ݷ���

%% ����ѹ������Ƶ��
if 0
 	paperPlot04StraightPipePressureAndFrequency(straightPipeDataCells{1,2}.subSpectrumData,isSavePlot);
end

%% �������в���ʱƵ����
if 1
    paperPlot04StraightPipeSTFT(straightPipeDataCells{1,2}.rawData,isSavePlot);
end

%% ɨƵ���ݷ���
if 0
	%sweepResult = loadExperimentPressureData(fullfile(dataPath,'��ֱ�ܿ���450��300ת0.05mpa.CSV'));
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
	paperPlot04StraightPipeNatureFrequency(straightPipeCombineData,{},isSavePlot);
end
