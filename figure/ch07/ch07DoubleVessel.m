%% ������ ��ͼ - ˫�����۷���
%�����»�ͼ�Ĳ�������
clear all;
% close all;
clc;
isSaveFigure = false;
theoryOnly = 1;

if ~theoryOnly
	perforateN20DataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\˫���޼��0.099mpa');
	perforateN36DataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\D0.5N36RPM420��ͷ��');
	perforateN68DataPath = fullfile(dataPath,'ʵ��ԭʼ����\˫������о�\D0.5N68RPM420��ͷ��');
end



param.acousticVelocity = 345;%����
param.isDamping = 1;%�Ƿ��������
param.coeffFriction = 0.003;%�ܵ�Ħ��ϵ��
param.notMach = 0;
detalDis = 0.5;
param.L1 = 3.5;%L1(m)
param.L2 = 1.5;%1.5;%˫�޴������޼��
param.L3 = 4;%4%˫�޴����޶����ڹܳ�
param.Dpipe = 0.098;%�ܵ�ֱ����m��%Ӧ����0.106
param.l = 0.01;
param.DV1 = 0.372;%����޵�ֱ����m��
param.LV1 = 1.1;%������ܳ� ��1.1m��
param.DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%����޵�ֱ����0.372m��
param.LV2 = 1.1;%variant_r(i).*param.DV2;%������ܳ� ��1.1m��
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.sectionL1 = 0:detalDis:param.L1;
param.sectionL2 = 0:detalDis:param.L2;
param.sectionL3 = 0:detalDis:param.L3;
param.meanFlowVelocity = 16;
param.mach = param.meanFlowVelocity / param.acousticVelocity;
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;

%% ���۷���
if 1
	paperPlotTheDoubleVessel(param,isSaveFigure);
end










