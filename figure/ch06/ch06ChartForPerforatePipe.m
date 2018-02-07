%% ������ ��ͼ - ���ÿ׹���ػ�ͼ
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
isSaveFigure = 0;
dataPath = getDataPath();
theoryOnly = 1;
%% ����·��
if ~theoryOnly
	perforateN20DataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ�׹�\D0.5N20RPM420��ͷ��');
	perforateN36DataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ�׹�\D0.5N36RPM420��ͷ��');
	perforateN68DataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ�׹�\D0.5N68RPM420��ͷ��');
	vesselDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\RPM420');
	[expPerforateN20DataCells,expPerforateN20CombineData,simPerforateN20DataCell] ...
		= loadExpAndSimDataFromFolder(perforateN20DataPath);
	[expPerforateN36DataCells,expPerforateN36CombineData,simPerforateN36DataCell] ...
		= loadExpAndSimDataFromFolder(perforateN36DataPath);
	[expPerforateN68DataCells,expPerforateN68CombineData,simPerforateN68DataCell] ...
		= loadExpAndSimDataFromFolder(perforateN68DataPath);
    %��һ���������
    [expVesselDataCells,expVesselCombineData,simVesselDataCell] ...
        = loadExpAndSimDataFromFolder(vesselDataPath);
	perforatePipeCombineDataCells = {expPerforateN20CombineData,expPerforateN36CombineData,expPerforateN68CombineData};
	legendLabels = {'N24','N40','N72'};
	expRawDataCells = {expPerforateN20DataCells{2,2}.rawData,expPerforateN36DataCells{2,2}.rawData,expPerforateN68DataCells{2,2}.rawData};
    expCombineDataCells = {expPerforateN20CombineData,expPerforateN36CombineData,expPerforateN68CombineData};
    %ģ�����ݵ�����
    xSim = constSimMeasurementPointDistance();
    index = find(xSim < 2.5);
    simPerforateN20DataCell.rawData.pulsationValue(index) = nan;
    simPerforateN36DataCell.rawData.pulsationValue(index) = nan;
    simPerforateN68DataCell.rawData.pulsationValue(index) = nan;
    
    n20SimY = [nan,nan,nan,nan,8.7357,8.56085,7.89048,2.65308,3.5774,4.80772,5.28376,6.98776,8.21878,9.38138,10.3945,11.2395,11.892,12.3366,12.5647];
    simPerforateN20DataCell.rawData.pulsationValue=n20SimY;
    simDataCells = {simPerforateN20DataCell,simPerforateN36DataCell,simPerforateN68DataCell};
end
%% ���ƶ���ѹ������
if 0 && ~theoryOnly
	paperPlotPerforatePipeExpCmp(perforatePipeCombineDataCells,legendLabels,isSaveFigure)
end

%% ����Ƶ�ʷֲ�ͼ
if 0 && ~theoryOnly
	paperPlotPerforateSpectrum3D(expRawDataCells,legendLabels,isSaveFigure);
end



%% ����·��
%������м����׹�,���˶��������׸��������Ե�ЧΪ��ķ���ȹ�����,��������ƫ��
%                 L1
%                     |
%                     |
%           l   LBias |                                    L2  
%              _______|_________________________________        
%             |    dp(n1)            |    dp(n2)        |
%             |           ___ _ _ ___|___ _ _ ___ lc    |     
%             |          |___ _ _ ___ ___ _ _ ___|Din   |----------
%             |           la1 lp1 la2|lb1 lp2 lb2       |
%             |______________________|__________________|       
%                             Lin         Lout          l
%                       Lv1                  Lv2
%    Dpipe                       Dv                     Dpipe  
%              
%           
%
% Lin �ڲ�׹���ڶγ��� 
% Lout�ڲ�׹ܳ��ڶγ���
% lc  �׹ܱں�
% dp  �׹�ÿһ���׿׾�
% n1  �׹���ڶο��׸�����    n2  �׹ܳ��ڶο��׸���
% la1 �׹���ڶξ���ڳ��� 
% la2 �׹���ڶξ���峤��
% lb1 �׹ܳ��ڶξ���峤��
% lb2 �׹ܳ��ڶξ࿪�׳���
% lp1 �׹���ڶο��׳���
% lp2 �׹ܳ��ڶο��׳���
% Din �׹ܹܾ���
% xSection1��xSection2 �׹�ÿȦ�׵ļ�࣬��0��ʼ�㣬x�ĳ���Ϊ�׹ܿ׵�Ȧ��+1��x��ֵ�ǵ�ǰһȦ�׺���һȦ�׵ľ��룬������һ������ôx���ֵ��һ��
param.acousticVelocity = 345;%���٣�m/s��
param.isDamping = 1;
param.coeffFriction = 0.01;
param.meanFlowVelocity = 10;
param.L1 = 3.5;%(m)
param.L2 = 6;
param.l  =  0.01;%(m)����޵����ӹܳ�
param.Dv = 0.372;%����޵�ֱ����m��
param.Lv1 = 1.1/2;%�����ǻ1�ܳ�
param.Lv2 =  1.1/2;

param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%�ܵ�ֱ����m��
param.Lbias = 0.168+0.150;
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv1 + param.Lv2 + param.sectionL2];
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
%
param.lc   = 0.005;%�ڲ�ܱں�
param.dp1  = 0.013;%���׾�
param.dp2  = 0.013;%���׾�
param.lp1  = 0.16;%�ڲ����ڶο׹ܿ��׳���
param.lp2  = 0.16;%�ڲ�ܳ��ڶο׹ܿ��׳���
param.n1   = 24;%��ڶο���
param.n2   = 24;%���ڶο���
param.la1  = 0.03;%�׹���ڶο�����ڳ���
param.la2  = 0.06;
param.lb1  = 0.06;
param.lb2  = 0.03;
param.Din  = 0.049;
param.Lout = param.lb1 + param.lp2+ param.lb2;%�ڲ����ڶγ���
param.bp1 = calcPerforatingRatios(param.n1,param.dp1,param.Din,param.lp1);
param.bp2 = calcPerforatingRatios(param.n2,param.dp2,param.Din,param.lp2);
param.Lin  = param.la1 + param.lp1+ param.la2;%�ڲ����ڶγ���
param.LBias = (0.150+0.168);%�����ƫ�þ���
param.Dbias = 0;%���ڲ��
param.sectionNum1 = [1];%��Ӧ��1������
param.sectionNum2 = [1];%��Ӧ��2������
param.xSection1 = [0,ones(1,param.sectionNum1).*(param.lp1/(param.sectionNum1))];
param.xSection2 = [0,ones(1,param.sectionNum2).*(param.lp2/(param.sectionNum2))];


if 0 && ~theoryOnly
	paperPlotPerforatePipeExpSimThe(param,expCombineDataCells,simDataCells,isSaveFigure);
end

if 0
	paperPlotPerforatePipeTheory(param,isSaveFigure)
end

if 1
	paperPlotPerforateTheoryFrequencyResponse(param,isSaveFigure);
end





