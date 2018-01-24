%% ������ ��ͼ - ���ÿ׹���ػ�ͼ
%�����»�ͼ�Ĳ�������
clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
isSaveFigure = 0;
dataPath = getDataPath();
theoryOnly = true;
%% ����·��
if ~theoryOnly
	perforateD0_5DataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ��\�ڲ��0.5D�м�420ת0.05mpa');
	perforateD0_75DataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ��\�ڲ��0.75D�м�420ת0.06mpa');
	perforateD1DataPath = fullfile(dataPath,'ʵ��ԭʼ����\�ڲ��\�ڲ��1D���м�420ת0.05mpa');
	vesselDataPath = fullfile(dataPath,'ʵ��ԭʼ����\���ڼ������\RPM420');
	[expPerforate0_5DataCells,expPerforate0_5CombineData,simPerforate0_5DataCell] ...
		= loadExpAndSimDataFromFolder(perforateD0_5DataPath);
	[expPerforate0_75DataCells,expPerforate0_75CombineData,simPerforate0_75DataCell] ...
		= loadExpAndSimDataFromFolder(perforateD0_75DataPath);
	[expPerforate01DataCells,expPerforate01CombineData,simPerforate01DataCell] ...
		= loadExpAndSimDataFromFolder(perforateD1DataPath);
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
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
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
param.lp1  = 0.16;%�ڲ����ڶηǿ׹ܿ��׳���
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

if 1
	paperPlotPerforatePipeTheory(param,isSaveFigure)
end







