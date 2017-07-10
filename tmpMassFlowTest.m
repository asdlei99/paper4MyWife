%% 用于压缩机多列共用一个缓冲罐的质量流量计算
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));
%% 压缩机基本参数
DCylinder=420/1000;%缸径m
dPipe=250/1000;%管内径m
crank=80/1000;%曲柄长
connectingRod=450/1000;%连杆长度
k=1.1591;%绝热指数 (丙烯混合)
rcv = 0.15;% 相对余隙容积
pressureRadio = 4.63;%压力比（排气压力/吸气压力）
outDensity = 9.0343;% 1.9167;%%环境25度绝热压缩到0.2的温度对应密度
rpm = 740;
%% 计算参数
fs = 1/0.00035;
totalSecond = 60/rpm*10;
totalPoints = fs*totalSecond+1;
time = linspace(0,totalSecond,totalPoints);%0:1/fs:totalSecond;
periodIndex = time < (1/5);
periodIndex = find(periodIndex ==1);

%% 生成1s的质量流量数据
%massFlowMaker只生成一个周期数据
[massFlow,~,meanMassFlow] = massFlowMaker(DCylinder,dPipe,rpm...
        ,crank,connectingRod,outDensity,'rcv',rcv,'k',k,'pr',pressureRadio,'fs',fs);
while length(massFlow)<totalPoints %生成1s的数据
    massFlow = [massFlow,massFlow];
end
massFlow = massFlow(1:totalPoints);

%% 由于两个曲轴相隔120度，因此叠加两次间隔的质量流量
%计算周期
T = 60/rpm;
%1/3周期
spaceTime = T/3;
%找到对应的索引
[~,index] = find(time>=spaceTime);
index = index(1);
%叠加两个波
massFlowCombine = massFlow(index:end) + massFlow(1:end-index+1);


%% 频谱分析
[Fre,Amp] = frequencySpectrum(massFlow,fs);
[FreCombine,AmpCombine] = frequencySpectrum(massFlowCombine,fs);
%% 绘图
figure
subplot(2,2,1)
plot(time,massFlow);
xlim([0,2*60/rpm]);
set(get(gca, 'Title'), 'String', '单一气缸下的质量流量');
xlabel('时间(s)');
xlabel('质量流量(kg/s)');

subplot(2,2,2)
plot(Fre,Amp);
xlim([0,450]);
set(get(gca, 'Title'), 'String', '单一气缸下的质量流量频谱');
xlabel('频率(Hz)');
xlabel('幅值(kg/s)');

subplot(2,2,3)
plot(time(1:length(massFlowCombine)),massFlowCombine);
set(get(gca, 'Title'), 'String', '双列(120)共用一个缓冲罐下的质量流量');
xlim([0,2*60/rpm]);
xlabel('时间(s)');
xlabel('质量流量(kg/s)');

subplot(2,2,4)
plot(FreCombine,AmpCombine);
xlim([0,450]);
set(get(gca, 'Title'), 'String', '双列(120)共用一个缓冲罐下的质量流量频谱');
xlabel('频率(Hz)');
xlabel('幅值(kg/s)');

set(gcf,'color','w');