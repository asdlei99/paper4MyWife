%% �ڰ��� ��ͼ - Ӧ��-ԭ�ṹ˫��
%�ڰ��»�ͼ�Ĳ�������
clear all;
close all;
clc;
errorType = 'ci';
isSaveFigure = false;
theoryOnly = 0;
dataPath = getDataPath();



param.acousticVelocity = 345;%����
param.isDamping = 1;%�Ƿ��������
param.coeffFriction = 0.003;%�ܵ�Ħ��ϵ��
param.notMach = 0;
detalDis = 0.01;
param.L1 = 0.1;%L1(m)
param.L2 = 15;%1.5;%˫�޴������޼��
param.L3 = 0.2;%4%˫�޴����޶����ڹܳ�
param.Dpipe = 0.098;%�ܵ�ֱ����m��%Ӧ����0.106
param.l = 0.01;
param.DV1 = 0.1;%����޵�ֱ����m��
param.LV1 = 1.1;%������ܳ� ��1.1m��
param.DV2 = 0.3;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%����޵�ֱ����0.372m��
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
param.pressureBoundary2 = 0;



%% ���۷���
if 1
	resDoubleVessel = paperPlotFacTheDoubleVessel(param,isSaveFigure);
end


if 0
	dataPath = fullfile(dataPath,'ģ������\ɨƵ����\���0.2kgs������������ѹ��\ɨƵ-˫�ݹ޶���ͷ');
	figureSimFrequencyResponse(dataPath,[],'type','contourf');
    xlim([0,50]);
end









