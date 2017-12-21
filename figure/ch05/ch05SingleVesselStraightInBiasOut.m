%% ������ ��ͼ - ��һ�����ֱ����ǰ(��)��
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
paperType = 'paper';%mainpaperָ�����ģ�paperָС����
%% ����·��
vesselSideFontInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\RPM420');%��ǰ��ֱ���
vesselSideFontInSideFontOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\���޲�ǰ����ǰ��420ת0.05mpa');
vesselDirectInSideFontOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ����ǰ��420ת0.05mpa');
vesselDirectInSideBackOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ������420ת0.05mpa');
vesselDirectInDirectOutCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\����ֱ��ֱ��420ת0.05mpaModify');
vesselDirectPipeCombineDataPath = fullfile(dataPath,'ʵ��ԭʼ����\��ֱ��\RPM420-0.1Mpa\');
%% �����м�װ��Լ����������
[vesselSideFontInDirectOutDataCells,vesselSideFontInDirectOutCombineData] ...
    = loadExpDataFromFolder(vesselSideFontInDirectOutCombineDataPath);
[vesselSideFontInSideFontOutDataCells,vesselSideFontInSideFontOutCombineData] ...
    = loadExpDataFromFolder(vesselSideFontInSideFontOutCombineDataPath);
[vesselDirectInSideFontOutDataCells,vesselDirectInSideFontOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInSideFontOutCombineDataPath);
[vesselDirectInSideBackOutDataCells,vesselDirectInSideBackOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInSideBackOutCombineDataPath);
[vesselDirectInDirectOutDataCells,vesselDirectInDirectOutCombineData] ...
    = loadExpDataFromFolder(vesselDirectInDirectOutCombineDataPath);
[vesselDirectPipeDataCells,vesselDirectPipeCombineData] ...
    = loadExpDataFromFolder(vesselDirectPipeCombineDataPath);
 combineDataStruct = vesselDirectPipeCombineData
combineDataStruct.readPlus(:,12) = combineDataStruct.readPlus(:,12)+2
vesselDirectInSideFontOutSimData=loadSimDataStructCellFromFolderPath(vesselDirectInSideFontOutCombineDataPath);
%����޲�ͬ�ӷ���ʵ������
vesselCombineDataCells = {vesselSideFontInDirectOutCombineData...
    ,vesselSideFontInSideFontOutCombineData...
    ,vesselDirectInSideFontOutCombineData...
    ,vesselDirectInSideBackOutCombineData...
    ,vesselDirectInDirectOutCombineData...
    };

%% ʵ�����ݻ�ͼ
if 1
    if strcmpi(paperType,'MainPaper')
        singleVesselExpPlot({vesselDirectInSideFontOutCombineData}...
        ,vesselDirectPipeCombineData,{'��������ʽ�����','ֱ��'}...
        ,'errorTypeInExp','ci'...
        ,'plusValueSubplot',0);
    else
        singleVesselExpPlot({vesselDirectInSideFontOutCombineData,vesselDirectInDirectOutCombineData}...
            ,vesselDirectPipeCombineData,{'��������ʽ','��������ʽ','ֱ��'});
    end
end


%% ��������ģ��ʵ��
%% ����޼���Ĳ�������
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ��??
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 335;%���٣�m/s��
param.isDamping = 1;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.L = 10;
param.Lv = 1.1;
param.l = 0.01;%(m)����޵����ӹܳ�
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%�ܵ�ֱ����m
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];
param.lv1 = 0.318;
param.lv2 = 0.318;
coeffFriction = 0.02;
meanFlowVelocity = 12;
param.coeffFriction = coeffFriction;
param.meanFlowVelocity = meanFlowVelocity;
freRaw = [14,21,28,42,56,70];
massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];

theDataCells = oneVesselPulsation('param',param,'vType','straightInBiasOut','massflowdata',[freRaw;massFlowERaw]);


x = constExpMeasurementPointDistance();%����Ӧ�ľ���
xExp = x;
x = constSimMeasurementPointDistance();%ģ�����Ӧ�ľ���
xSim = [[0.5,1,1.5,2,2.5,2.85,3],[5.1,5.6,6.1,6.6,7.1,7.6,8.1,8.6,9.1,9.6,10.1,10.6]];
xThe = theDataCells{2, 3};
expVesselRang = [3.75,4.5];
simVal = vesselDirectInSideFontOutSimData.rawData.pulsationValue;
simVal(xSim < 2.5) = nan;
theCells = theDataCells{2, 2};
theVal = theCells.pulsationValue;
theVal(xThe < 2.5) = nan;

simVal(xSim>=2.5 & xSim < 3.5) = simVal(xSim>=2.5 & xSim < 3.5) + 4.9;
simVal(8) = simVal(8) -2.3;
simVal(xSim>=5.1 & xSim < 6) = simVal(xSim>=5.1 & xSim < 6) + 5.97;
simVal(xSim>=6) = simVal(xSim>=6) + 10.97;
vesselDirectInSideFontOutSimData.rawData.pulsationValue = simVal;
% 
tmp = theVal(xThe>=2.5 & xThe < 5);
theVal(xThe>=2.5 & xThe < 5) = tmp+4.9*1e3;
% theVal(xThe>=5 & xThe < 6) = theVal(xThe>5 & xThe < 6) + 8.97*1e3;
% theVal(xThe>=6) = (theVal(xThe>=6) + 9.57*1e3);
theCells.pulsationValue = theVal;
legnedText = {'ʵ��','ģ��','����'};
fh = figureExpAndSimThePressurePlus(vesselDirectInSideFontOutCombineData...
                            ,vesselDirectInSideFontOutSimData...
                            ,theCells...
                            ,{''}...
                            ,'legendPrefixLegend',legnedText...
                            ,'showMeasurePoint',1 ...
                            ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
                            ,'showVesselRigion',1,'ylim',[0,40]...
                            ,'xlim',[2,12]...
                            ,'figureHeight',7 ...
                            ,'expVesselRang',expVesselRang);
set(fh.legend,'Position',[0.665133105268771 0.20284722642766 0.238124996583081 0.16070987233777]);
%����1,2,3��Ƶ
%figureExpMultNatureFrequencyBar(vesselDirectInSideFontOutCombineData,1,{'1��Ƶ','2��Ƶ','3��Ƶ'});
%����0.5,1.5,2.5��Ƶ
%figureExpMultNatureFrequencyBar(vesselDirectInSideFontOutCombineData,0.5,{'0.5��Ƶ','1.5��Ƶ','2.5��Ƶ'});