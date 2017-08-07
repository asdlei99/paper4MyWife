%% 次文件用于不同形式直进缓冲罐的共振频率分析
clear all;
close all;
clc;

freTimes = 1;
fs = 1024*freTimes;
pulsSig = [2048,zeros(1,1024*freTimes-1)];
time = 0:1:(size(pulsSig,2)-1);
time = time .* (1/fs);
[frequency,~,~,magE] = frequencySpectrum(pulsSig,fs);
frequency(1) = [];
magE(1) = [];

Dpipe = 0.098;%管道直径（m）%应该是0.106
isOpening = 0;
% st = makeCommonTransferMatrixInputStruct();
% st.isDamping = 1;%是否计算阻尼
% st.coeffDamping = nan;%阻尼系数
% st.coeffFriction = 0.04;%管道摩擦系数
% st.meanFlowVelocity = 14.5;%流速
% st.k = nan;%波数
% st.oumiga = nan;%圆频率
% st.a = 345;%声速
% st.isOpening = 0;%边界条件是否为开口
% st.notMach = 0;%是否马赫
% st.mach = st.meanFlowVelocity ./ st.a;
% st.D = Dpipe;

opt.acousticVelocity = 345;%声速
opt.meanFlowVelocity = 25.51;
opt.isDamping = 1;%是否计算阻尼
opt.coeffDamping = nan;%阻尼
opt.coeffFriction = 0.04;%管道摩察系数
opt.isUseStaightPipe = 1;%计算容器传递矩阵的方法
opt.mach = opt.meanFlowVelocity / opt.acousticVelocity;
opt.notMach = 0;

L1 = 3.5;%L1(m)
L2 = 6;%L2（m）长度
L3 = 1.5;%双罐串联罐二作弯头两罐间距
L4 = 4.0;%双罐串联罐二作弯头出口管长
L5 = 4.5;%双罐无间隔串联L2（m）长度

vhpicStruct.l = 0.01;
vhpicStruct.DV1 = 0.372;%缓冲罐的直径（m）
vhpicStruct.LV1 = 1.1;%缓冲罐总长 
vhpicStruct.DV2 = 0.372;%缓冲罐的直径（m）
vhpicStruct.LV2 = 1.1;%缓冲罐总长 
vhpicStruct.Lv1 = vhpicStruct.LV1./2;%缓冲罐腔1总长
vhpicStruct.Lv2 = vhpicStruct.LV1-vhpicStruct.Lv1;%缓冲罐腔2总长
vhpicStruct.lv1 = vhpicStruct.LV1./2-(0.150+0.168);
vhpicStruct.lv2 = 0;%出口不偏置
vhpicStruct.lv3 = 0.150+0.168;%开孔径
vhpicStruct.Dbias = 0;%内插管入口段非孔管开孔长度
sectionL1 = 0:0.25:L1;%[2.5,3.5];%0:0.25:para(i).L1;
sectionL2 = 0:0.25:L2;
sectionL3 = 0:0.25:L3;
sectionL4 = 0:0.25:L4;
sectionL5 = 0:0.25:L5;
beforeIndexDBE = length(sectionL1);
beforeIndexDBS = beforeIndexDBE;
afterIndexDBE = length(sectionL1)+length(sectionL3)+1;
afterIndexDBS = length(sectionL1)+1;
%       长度 L1     l    Lv    l    L2   l    Lv
%                   __________            ___________ 
%                  |          |          |           |   
%       -----------|          |----------|           |
%                  |__________|          |__   ______|      
% 直径      Dpipe       Dv       Dpipe      | |
%                                           | | L3 
%                                           | |
    %计算双罐-罐二作弯头 入口流速调节到40时与模拟较接近
[pressure1DBE,pressure2DBE,pressure3DBE] = ...
    doubleVesselElbowPulsationCalc(magE,frequency,time,...
    L1,L3,L4,...
    vhpicStruct.LV1,vhpicStruct.LV2,vhpicStruct.l,Dpipe,vhpicStruct.DV1,vhpicStruct.DV2,...
    vhpicStruct.lv3,vhpicStruct.Dbias,...
    sectionL1,sectionL3,sectionL4,...
    'a',opt.acousticVelocity,'isDamping',opt.isDamping,'friction',opt.coeffFriction,...
    'meanFlowVelocity',45,'isUseStaightPipe',1,...
    'm',opt.mach,'notMach',opt.notMach...
    ,'isOpening',isOpening...
    );%,'coeffDamping',opt.coeffDamping

%       长度 L1     l    Lv   l l    Lv     l        L2
%                   __________   ___________ 
%                  |          | |           |   
%       -----------|          |-|           |-------------------
%                  |__________| |___________|      
% 直径      Dpipe       Dv           Dv          Dpipe     
%计算双罐串联
% if i==1
[pressure1DBS,pressure2DBS] = ...
    doubleVesselSeriesPulsationCalc(magE,frequency,time,...
    L1,L5,...
    vhpicStruct.LV1,vhpicStruct.LV2,vhpicStruct.l,Dpipe,vhpicStruct.DV1,vhpicStruct.DV2,...
    sectionL1,sectionL5,...
    'a',opt.acousticVelocity,'isDamping',opt.isDamping,'friction',opt.coeffFriction,...
    'meanFlowVelocity',20,'isUseStaightPipe',1,...
    'm',opt.mach,'notMach',opt.notMach...
    ,'isOpening',isOpening...
    );%,'coeffDamping',opt.coeffDamping



pressureVesselDBE = [pressure1DBE,pressure2DBE,pressure3DBE];
pressureVesselDBS = [pressure1DBS,pressure2DBS];


%定义频率的范围
freRang = 1:100;
%对压力进行傅里叶变换
[freVesselDBE,magVesselDBE] = frequencySpectrum(pressureVesselDBE,fs,'scale','ampDB');
freVesselDBE = freVesselDBE(freRang,:);
magVesselDBE = magVesselDBE(freRang,:);

[freVesselDBS,magVesselDBS] = frequencySpectrum(pressureVesselDBS,fs,'scale','ampDB');
freVesselDBS = freVesselDBS(freRang,:);
magVesselDBS = magVesselDBS(freRang,:);

% [frePipe,magPipe] = frequencySpectrum(pressurePipe,fs,'scale','ampDB');
% frePipe = frePipe(freRang,:);
% magPipe = magPipe(freRang,:);

%% 全管系脉冲响应云图
rowCount = 1;
columnCount = 2;
subplotCount = 1;
figure('Name','管系脉冲响应-全管系脉冲响应云图')

maxVal = 0;
minVal = 10e10;
% %直管
% subplot(rowCount,columnCount,subplotCount);subplotCount = subplotCount + 1;
% y = frePipe(:,1);
% x = sectionL;%1:size(mag1,2);
% Z = magPipe;
% [X,Y] = meshgrid(x,y);
% contourf(X,Y,Z);
% fax(1) = gca;
% maxVal=max([maxVal,max(Z)]);
% minVal = min([minVal,min(Z)]);
% set(gca,'XTick',0:2:10);
% xlabel('Distance(m)','fontName',paperFontName(),'FontSize',paperFontSize());
% ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
% title(sprintf('直管'),'fontName',paperFontName(),'FontSize',paperFontSize());

%双罐-罐二作弯头
subplot(rowCount,columnCount,subplotCount);subplotCount = subplotCount + 1;
y = freVesselDBE(:,1);
sectionLDBE = [sectionL1, L1 + 2*vhpicStruct.l+vhpicStruct.LV1+sectionL3,...
                               L1 + 2*vhpicStruct.l+vhpicStruct.LV1+L3+ 2*vhpicStruct.l+vhpicStruct.lv3+sectionL4];
x = sectionLDBE;
Z = magVesselDBE;
maxVal=max([maxVal,max(Z)]);
minVal = min([minVal,min(Z)]);
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
set(gca,'XTick',0:2:10);
hold on;
ax = axis;
fax(subplotCount-1) = gca;
plot([2.5,2.5],[ax(3),ax(4)],'--','color',[1,1,1]);
text(3,10,'a','color',[1,1,1],'fontName',paperFontName(),'FontSize',paperFontSize());
text(3,90,'a','color',[1,1,1],'fontName',paperFontName(),'FontSize',paperFontSize());
xlabel('Distance(m)','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title('双罐-罐二作弯头','fontName',paperFontName(),'FontSize',paperFontSize());
%双罐串联
subplot(rowCount,columnCount,subplotCount);subplotCount = subplotCount + 1;
y = freVesselDBS(:,1);
sectionLDBS = [sectionL1, ...
    L1 + 2*vhpicStruct.l+vhpicStruct.LV1+2*vhpicStruct.l+vhpicStruct.LV2+sectionL5];
x = sectionLDBS;
Z = magVesselDBS;
maxVal=max([maxVal,max(Z)]);
minVal = min([minVal,min(Z)]);
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
set(gca,'XTick',0:2:10);
hold on;
ax = axis;
fax(subplotCount-1) = gca;
plot([2.5,2.5],[ax(3),ax(4)],'--','color',[1,1,1]);
text(3,10,'a','color',[1,1,1],'fontName',paperFontName(),'FontSize',paperFontSize());
text(3,90,'a','color',[1,1,1],'fontName',paperFontName(),'FontSize',paperFontSize());
xlabel('Distance(m)','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title('双罐串联','fontName',paperFontName(),'FontSize',paperFontSize());

for i = 1:length(fax)
    set(fax(i),'Clim',[minVal maxVal]);
end

set(gcf,'unit','centimeter','position',[8,4,14,5]);
set(gcf,'color','w');




%% 罐前管系系脉冲响应云图
figure('Name','管系脉冲响应-罐前管系系脉冲响应云图')
subplot(1,2,1)
y = freVesselDBE(:,1);
x = sectionLDBE(1:beforeIndexDBE);
Z = magVesselDBE(:,1:beforeIndexDBE);
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
xlabel('Distances(m)','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title('surge tank','fontName',paperFontName(),'FontSize',paperFontSize());

subplot(1,2,2)
y = freVesselDBS(:,1);
x = sectionLDBS(1:beforeIndexDBS);
Z = magVesselDBS(:,1:beforeIndexDBS);
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
xlabel('Measurement point','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title(sprintf('volume-perforated \npipe-volume suppressor'),'fontName',paperFontName(),'FontSize',paperFontSize());

set(gcf,'unit','centimeter','position',[8,4,14,7]);
set(gcf,'color','w');

%% 罐后管系系脉冲响应云图
figure('Name','管系脉冲响应-罐后管系系脉冲响应云图')
subplot(1,2,1)
y = freVesselDBE(:,1);
x = sectionLDBE(afterIndexDBE:end);
Z = magVesselDBE(:,afterIndexDBE:end);
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
xlabel('Distances(m)','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title('surge tank','fontName',paperFontName(),'FontSize',paperFontSize());

subplot(1,2,2)
y = freVesselDBS(:,1);
x = sectionLDBS(afterIndexDBS:end);
Z = magVesselDBS(:,afterIndexDBS:end);
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
xlabel('Distances(m)','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title(sprintf('volume-perforated \npipe-volume suppressor'),'fontName',paperFontName(),'FontSize',paperFontSize());

set(gcf,'unit','centimeter','position',[8,4,14,7]);
set(gcf,'color','w');