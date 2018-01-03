%% ������ ��ͼ - �ڲ����ػ�ͼ
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
expVesselRang = [3.75,4.5];
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

%% ���ƶ���ѹ������
if 1
	paperPlotInnerPipeExpCmp(innerPipeDataCells,legendLabels,expVesselRang,isSaveFigure)
end

%% ��������ģ��ʵ��
if 0
	legendText = {'��һ�����','�ڲ�ܻ����'};
	paperPlotInnerPipeExpTheSim({expVesselCombineData,expOrificD0_5CombineData}...
								,{simVesselDataCell,simOrificD0_5DataCell}...
								,param...
								,legendText...
								,isSaveFigure);
end


%% ���ƶ���ѹ������������
if 1
    fh = figureExpSuppressionLevel(innerPipeDataCells,legendLabels,'errorType',errorType...
        ,'expVesselRang',expVesselRang...
    );
    set(fh.legend,...
        'Position',[0.140376159707257 0.618463546693475 0.200642358811262 0.190720481084297]);
    set(fh.textarrow,...
        'X',[0.303472222222222 0.314496527777778],'Y',[0.545104166666667 0.4525]);
end
%% ���ƶ���ѹ����
if 1
    fh = figureExpPressureDrop(innerPipeDataCells,legendLabels,[2,3],'chartType','bar');
    %'chartType'== 'bar' ʱ��������bar����ɫ
    set(fh.barHandle,'FaceColor',getPlotColor(1));
end
%�Բ��1����ʱƵ��������
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%����1��Ƶ�ĶԱ�
%% ���Ʊ�Ƶ
if 1
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,1,legendLabels);
    set(fh.legend,'Location','northwest');
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,2,legendLabels);
    set(fh.legend,...
    'Position',[0.546070604348832 0.612951407221974 0.207256941947465 0.280752307323877]);
    fh = figureExpNatureFrequencyBar(innerPipeDataCells,3,legendLabels);
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
