%% 次文件用于不同形式直进缓冲罐的共振频率分析


freTimes = 1;
fs = 1024*freTimes;
pulsSig = [2048,zeros(1,1024*freTimes-1)];
time = 0:1:(size(pulsSig,2)-1);
time = time .* (1/fs);
[frequency,~,~,magE] = frequencySpectrum(pulsSig,fs);
frequency(1) = [];
magE(1) = [];

Dpipe = 0.106;%管道直径（m）%应该是0.106

st = makeCommonTransferMatrixInputStruct();
st.isDamping = 1;%是否计算阻尼
st.coeffDamping = nan;%阻尼系数
st.coeffFriction = 0.04;%管道摩擦系数
st.meanFlowVelocity = 14.5;%流速
st.k = nan;%波数
st.oumiga = nan;%圆频率
st.a = 345;%声速
st.isOpening = 0;%边界条件是否为开口
st.notMach = 1;%是否马赫
st.mach = st.meanFlowVelocity ./ st.a;
st.D = Dpipe;

L1 = 3.5;%L1(m)
L2 = 6;%L2（m）长度


vhpicStruct.l = 0.01;
vhpicStruct.Dv = 0.372;%缓冲罐的直径（m）
vhpicStruct.Lv = 1.1;%缓冲罐总长 
vhpicStruct.Lv1 = vhpicStruct.Lv./2;%缓冲罐腔1总长
vhpicStruct.Lv2 = vhpicStruct.Lv-vhpicStruct.Lv1;%缓冲罐腔2总长
vhpicStruct.lv1 = vhpicStruct.Lv./2-(0.150+0.168);
vhpicStruct.lv2 = 0;%出口不偏置
vhpicStruct.lv3 = 0.150+0.168;%开孔径
vhpicStruct.Dbias = 0;%内插管入口段非孔管开孔长度
sectionL1 = 0:0.25:L1;%[2.5,3.5];%0:0.25:L1;
sectionL2 = 0:0.25:L2;%[5.87,6.37,6.87，7.37,7.87,8.37,8.87,9.37,9.87,10.37]-L1-vhpicStruct.Lv1-vhpicStruct.Lv2;%0:0.25:L2;


%缓冲罐直进侧后出脉动计算
%   Detailed explanation goes here
%           |  L2
%        l  |     Lv    outlet
%   bias2___|_______________
%       |                   |  Dpipe
%       |lv2  V          lv1|———— L1  
%       |___________________| inlet
%           Dv              l  
[pressure1OSB,pressure2OSB] = vesselStraightBiasPulsationCalc(magE,frequency,time,L1,L2...
    ,vhpicStruct.Lv,vhpicStruct.l,Dpipe,vhpicStruct.Dv,vhpicStruct.lv3,vhpicStruct.Dbias...
    ,sectionL1,sectionL2...
    ,st);

%   Detailed explanation goes here
%                       |  L2
%              Lv    l  | outlet
%        _______________|___ bias2
%       |                   |  Dpipe
%       |lv2  V          lv1|———— L1  
%       |___________________| inlet
%           Dv              l      
    
%计算入口顺接出口前偏置
[pressure1OSFB,pressure2OSFB] = vesselStraightFrontBiasPulsationCalc(magE,frequency,time,...
            L1,L2,...
            vhpicStruct.Lv,vhpicStruct.l,Dpipe,vhpicStruct.Dv,...
            vhpicStruct.lv3,vhpicStruct.Dbias,...
           sectionL1,sectionL2,...
           st);

   %  长度 L1     l    Lv   l    L2  
%                   __________        
%                  |          |      
%       -----------|          |----------
%                  |__________|       
% 直径 Dpipe       Dv       Dpipe  
%计算单一缓冲罐
[pressure1OV,pressure2OV] = oneVesselPulsationCalc(magE,frequency,time,...
                L1,L2,...
                vhpicStruct.Lv,vhpicStruct.l,Dpipe,vhpicStruct.Dv,...
                sectionL1,sectionL2,...
                st);    
    
%计算直管的范围
pipeLength = L1+vhpicStruct.Lv+L2;
sectionL = [sectionL1,sectionL2+L1+vhpicStruct.Lv];
afterIndex = length(sectionL1);
%直管脉动计算
pressurePipe = straightPipePulsationCalc(magE,frequency,time,pipeLength,sectionL,st);

pressureVesselOSB = [pressure1OSB,pressure2OSB];
pressureVesselOSFB = [pressure1OSFB,pressure2OSFB];
pressureVesselOV = [pressure1OV,pressure2OV];

%定义频率的范围
freRang = 1:100;
%对压力进行傅里叶变换
[fre1,mag1] = frequencySpectrum(pressure,fs,'scale','ampDB');
fre1 = fre1(freRang,:);
mag1 = mag1(freRang,:);

[freVessel,magVessel] = frequencySpectrum(pressureVessel,fs,'scale','ampDB');
freVessel = freVessel(freRang,:);
magVessel = magVessel(freRang,:);

[frePipe,magPipe] = frequencySpectrum(pressurePipe,fs,'scale','ampDB');
frePipe = frePipe(freRang,:);
magPipe = magPipe(freRang,:);

%% 全管系脉冲响应云图
rowCount = 1;
columnCount = 3;
subplotCount = 1;
figure('Name','管系脉冲响应-全管系脉冲响应云图')

subplot(rowCount,columnCount,subplotCount);subplotCount = subplotCount + 1;
y = frePipe(:,1);
x = sectionL;%1:size(mag1,2);
Z = magPipe;
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
set(gca,'XTick',0:2:10);
xlabel('Distance(m)','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title(sprintf('straight pipe'),'fontName',paperFontName(),'FontSize',paperFontSize());


subplot(rowCount,columnCount,subplotCount);subplotCount = subplotCount + 1;
y = freVessel(:,1);
x = sectionL;
Z = magVessel;
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
set(gca,'XTick',0:2:10);
hold on;
ax = axis;
plot([2.5,2.5],[ax(3),ax(4)],'--','color',[1,1,1]);
text(3,10,'a','color',[1,1,1],'fontName',paperFontName(),'FontSize',paperFontSize());
text(3,90,'a','color',[1,1,1],'fontName',paperFontName(),'FontSize',paperFontSize());
xlabel('Distance(m)','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title('surge tank','fontName',paperFontName(),'FontSize',paperFontSize());

subplot(rowCount,columnCount,subplotCount);subplotCount = subplotCount + 1;
y = fre1(:,1);
x = sectionL;%1:size(mag1,2);
Z = mag1;
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
set(gca,'XTick',0:2:10);
hold on;
ax = axis;
plot([2.5,2.5],[ax(3),ax(4)],'--','color',[1,1,1]);
text(3,10,'a','color',[1,1,1],'fontName',paperFontName(),'FontSize',paperFontSize());
text(3,90,'a','color',[1,1,1],'fontName',paperFontName(),'FontSize',paperFontSize());
xlabel('Distance(m)','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title(sprintf('volume-perforated \npipe-volume suppressor'),'fontName',paperFontName(),'FontSize',paperFontSize());




set(gcf,'unit','centimeter','position',[8,4,14,5]);
set(gcf,'color','w');




%% 罐前管系系脉冲响应云图
figure('Name','管系脉冲响应-罐前管系系脉冲响应云图')
subplot(1,2,1)
y = freVessel(:,1);
x = sectionL(1:afterIndex);
Z = magVessel(:,1:afterIndex);
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
xlabel('Distances(m)','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title('surge tank','fontName',paperFontName(),'FontSize',paperFontSize());

subplot(1,2,2)
y = fre1(:,1);
x = sectionL(1:afterIndex);
Z = mag1(:,1:afterIndex);
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
y = freVessel(:,1);
x = sectionL(afterIndex+1:end);
Z = magVessel(:,afterIndex+1:end);
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
xlabel('Distances(m)','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title('surge tank','fontName',paperFontName(),'FontSize',paperFontSize());

subplot(1,2,2)
y = fre1(:,1);
x = sectionL(afterIndex+1:end);
Z = mag1(:,afterIndex+1:end);
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
xlabel('Distances(m)','fontName',paperFontName(),'FontSize',paperFontSize());
ylabel('Frequency(Hz)','fontName',paperFontName(),'FontSize',paperFontSize());
title(sprintf('volume-perforated \npipe-volume suppressor'),'fontName',paperFontName(),'FontSize',paperFontSize());

set(gcf,'unit','centimeter','position',[8,4,14,7]);
set(gcf,'color','w');


