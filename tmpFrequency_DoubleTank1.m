%% ���ļ����ڲ�ͬ��ʽֱ������޵Ĺ���Ƶ�ʷ���
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

Dpipe = 0.098;%�ܵ�ֱ����m��%Ӧ����0.106
isOpening = 0;
% st = makeCommonTransferMatrixInputStruct();
% st.isDamping = 1;%�Ƿ��������
% st.coeffDamping = nan;%����ϵ��
% st.coeffFriction = 0.04;%�ܵ�Ħ��ϵ��
% st.meanFlowVelocity = 14.5;%����
% st.k = nan;%����
% st.oumiga = nan;%ԲƵ��
% st.a = 345;%����
% st.isOpening = 0;%�߽������Ƿ�Ϊ����
% st.notMach = 0;%�Ƿ����
% st.mach = st.meanFlowVelocity ./ st.a;
% st.D = Dpipe;

opt.acousticVelocity = 345;%����
opt.meanFlowVelocity = 25.51;
opt.isDamping = 1;%�Ƿ��������
opt.coeffDamping = nan;%����
opt.coeffFriction = 0.04;%�ܵ�Ħ��ϵ��
opt.isUseStaightPipe = 1;%�����������ݾ���ķ���
opt.mach = opt.meanFlowVelocity / opt.acousticVelocity;
opt.notMach = 0;

L1 = 3.5;%L1(m)
L2 = 6;%L2��m������
L3 = 1.5;%˫�޴����޶�����ͷ���޼��
L4 = 4.0;%˫�޴����޶�����ͷ���ڹܳ�
L5 = 4.5;%˫���޼������L2��m������

vhpicStruct.l = 0.01;
vhpicStruct.DV1 = 0.372;%����޵�ֱ����m��
vhpicStruct.LV1 = 1.1;%������ܳ� 
vhpicStruct.DV2 = 0.372;%����޵�ֱ����m��
vhpicStruct.LV2 = 1.1;%������ܳ� 
vhpicStruct.Lv1 = vhpicStruct.LV1./2;%�����ǻ1�ܳ�
vhpicStruct.Lv2 = vhpicStruct.LV1-vhpicStruct.Lv1;%�����ǻ2�ܳ�
vhpicStruct.lv1 = vhpicStruct.LV1./2-(0.150+0.168);
vhpicStruct.lv2 = 0;%���ڲ�ƫ��
vhpicStruct.lv3 = 0.150+0.168;%���׾�
vhpicStruct.Dbias = 0;%�ڲ����ڶηǿ׹ܿ��׳���
sectionL1 = 0:0.25:L1;%[2.5,3.5];%0:0.25:para(i).L1;
sectionL2 = 0:0.25:L2;
sectionL3 = 0:0.25:L3;
sectionL4 = 0:0.25:L4;
sectionL5 = 0:0.25:L5;
beforeIndexDBE = length(sectionL1);
beforeIndexDBS = beforeIndexDBE;
afterIndexDBE = length(sectionL1)+length(sectionL3)+1;
afterIndexDBS = length(sectionL1)+1;
%       ���� L1     l    Lv    l    L2   l    Lv
%                   __________            ___________ 
%                  |          |          |           |   
%       -----------|          |----------|           |
%                  |__________|          |__   ______|      
% ֱ��      Dpipe       Dv       Dpipe      | |
%                                           | | L3 
%                                           | |
    %����˫��-�޶�����ͷ ������ٵ��ڵ�40ʱ��ģ��Ͻӽ�
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

%       ���� L1     l    Lv   l l    Lv     l        L2
%                   __________   ___________ 
%                  |          | |           |   
%       -----------|          |-|           |-------------------
%                  |__________| |___________|      
% ֱ��      Dpipe       Dv           Dv          Dpipe     
%����˫�޴���
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


%����Ƶ�ʵķ�Χ
freRang = 1:100;
%��ѹ�����и���Ҷ�任
[freVesselDBE,magVesselDBE] = frequencySpectrum(pressureVesselDBE,fs,'scale','ampDB');
freVesselDBE = freVesselDBE(freRang,:);
magVesselDBE = magVesselDBE(freRang,:);

[freVesselDBS,magVesselDBS] = frequencySpectrum(pressureVesselDBS,fs,'scale','ampDB');
freVesselDBS = freVesselDBS(freRang,:);
magVesselDBS = magVesselDBS(freRang,:);

% [frePipe,magPipe] = frequencySpectrum(pressurePipe,fs,'scale','ampDB');
% frePipe = frePipe(freRang,:);
% magPipe = magPipe(freRang,:);

%% ȫ��ϵ������Ӧ��ͼ
rowCount = 1;
columnCount = 2;
subplotCount = 1;
figure('Name','��ϵ������Ӧ-ȫ��ϵ������Ӧ��ͼ')

maxVal = 0;
minVal = 10e10;
% %ֱ��
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
% title(sprintf('ֱ��'),'fontName',paperFontName(),'FontSize',paperFontSize());

%˫��-�޶�����ͷ
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
title('˫��-�޶�����ͷ','fontName',paperFontName(),'FontSize',paperFontSize());
%˫�޴���
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
title('˫�޴���','fontName',paperFontName(),'FontSize',paperFontSize());

for i = 1:length(fax)
    set(fax(i),'Clim',[minVal maxVal]);
end

set(gcf,'unit','centimeter','position',[8,4,14,5]);
set(gcf,'color','w');




%% ��ǰ��ϵϵ������Ӧ��ͼ
figure('Name','��ϵ������Ӧ-��ǰ��ϵϵ������Ӧ��ͼ')
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

%% �޺��ϵϵ������Ӧ��ͼ
figure('Name','��ϵ������Ӧ-�޺��ϵϵ������Ӧ��ͼ')
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