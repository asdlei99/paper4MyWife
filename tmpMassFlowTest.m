%% ����ѹ�������й���һ������޵�������������
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%% ѹ������������
DCylinder=420/1000;%�׾�m
dPipe=250/1000;%���ھ�m
crank=80/1000;%������
connectingRod=450/1000;%���˳���
k=1.1591;%����ָ�� (��ϩ���)
rcv = 0.15;% �����϶�ݻ�
pressureRadio = 4.63;%ѹ���ȣ�����ѹ��/����ѹ����
outDensity = 9.0343;% 1.9167;%%����25�Ⱦ���ѹ����0.2���¶ȶ�Ӧ�ܶ�
rpm = 740;
%% �������
fs = 1/0.00035;
totalSecond = 60/rpm*10;
totalPoints = fs*totalSecond+1;
time = linspace(0,totalSecond,totalPoints);%0:1/fs:totalSecond;
periodIndex = time < (1/5);
periodIndex = find(periodIndex ==1);

%% ����1s��������������
%massFlowMakerֻ����һ����������
[massFlow,~,meanMassFlow] = massFlowMaker(DCylinder,dPipe,rpm...
        ,crank,connectingRod,outDensity,'rcv',rcv,'k',k,'pr',pressureRadio,'fs',fs);
while length(massFlow)<totalPoints %����1s������
    massFlow = [massFlow,massFlow];
end
massFlow = massFlow(1:totalPoints);

%% ���������������120�ȣ���˵������μ������������
%��������
T = 60/rpm;
%1/3����
spaceTime = T/3;
%�ҵ���Ӧ������
[~,index] = find(time>=spaceTime);
index = index(1);
%����������
massFlowCombine = massFlow(index:end) + massFlow(1:end-index+1);


%% Ƶ�׷���
[Fre,Amp] = frequencySpectrum(massFlow,fs);
[FreCombine,AmpCombine] = frequencySpectrum(massFlowCombine,fs);
%% ��ͼ
figure
subplot(2,2,1)
plot(time,massFlow);
xlim([0,2*60/rpm]);
set(get(gca, 'Title'), 'String', '��һ�����µ���������');
xlabel('ʱ��(s)');
xlabel('��������(kg/s)');

subplot(2,2,2)
plot(Fre,Amp);
xlim([0,450]);
set(get(gca, 'Title'), 'String', '��һ�����µ���������Ƶ��');
xlabel('Ƶ��(Hz)');
xlabel('��ֵ(kg/s)');

subplot(2,2,3)
plot(time(1:length(massFlowCombine)),massFlowCombine);
set(get(gca, 'Title'), 'String', '˫��(120)����һ��������µ���������');
xlim([0,2*60/rpm]);
xlabel('ʱ��(s)');
xlabel('��������(kg/s)');

subplot(2,2,4)
plot(FreCombine,AmpCombine);
xlim([0,450]);
set(get(gca, 'Title'), 'String', '˫��(120)����һ��������µ���������Ƶ��');
xlabel('Ƶ��(Hz)');
xlabel('��ֵ(kg/s)');

set(gcf,'color','w');