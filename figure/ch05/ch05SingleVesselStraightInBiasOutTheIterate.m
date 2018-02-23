clear all;
close all;
%��һ��������۵�
%% ����޼���Ĳ�������
vType = 'BiasFontInStraightOut';
isSaveFigure = 1;

coeffFriction = 0.03;
if 0
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
else
    
    param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ��??
    param.rpm = 420;
    param.outDensity = 1.5608;
    param.Fs = 4096;
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

    param.acousticVelocity = 320;%���٣�m/s��
    param.coeffFriction = 0.03;
    param.meanFlowVelocity = 13;

    freRaw = [14,21,28,42,56,70];
    massFlowERaw = [0.23,0.00976,0.00515,0.00518,0.003351,0.00278];

end
massFlowData = [freRaw;massFlowERaw];
%% 1����������
if 0
    paperPlotSingleVesselTheIteChangLengthDiameterRatio(param,massFlowData,isSaveFigure);
end

%% ���������λ��
if 0
    paperPlotSingleVesselTheIteChangL1(param,massFlowData,isSaveFigure);
end

%% ����ƫ�þ���ͳ�����
if 0
    paperPlotSingleVesselTheIteBiasLengthAndAspectRatio(param,massFlowData,isSaveFigure);
end

%% ���������lv1��ƫ����ڹܳ�
if 0
    paperPlotSingleVesselTheIteChangLv1(param,massFlowData,isSaveFigure);
end

%% ������ͬ�������£���ͬ�����ͬƫ�þ����Ӱ��
if 0
    paperPlotSingleVesselTheIteChangeVAndBiasLengthFixAR(param,massFlowData,isSaveFigure);
end
%�ȷ�ֵɨƵ
% if 0
	% addtion = -10:1:70;
	
	% for i = 1:length(addtion)
		% fre = freRaw+addtion(i);
		% baseFrequency = 14 + addtion(i);
		% res{i} = oneVesselPulsation('massflowdata',[fre;massFlowERaw]...
							% , 'param', param ...
							% , 'vType', vType ...
							% , 'baseFrequency', baseFrequency...
							% , 'multFreTimes', 1 ...
							% , 'semiFreTimes', 1 ...
								% );
		% %���������ʣ�����ֱ��
	% end
	
	
% end

if 1
    vType = 'StraightInStraightOut';%biasInBiasOut,EqualBiasInOut,BiasFontInStraightOut,straightinbiasout,BiasFrontInBiasFrontOut,
	paperPlotSingleVesselTheoryFrequencyResponse(param,vType,isSaveFigure);
end