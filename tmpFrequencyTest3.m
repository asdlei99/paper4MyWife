
fs = 1024*50;
pulsSig = [2048,zeros(1,1024*50)];
time = 0:1:(size(pulsSig,2)-1);
time = time .* (1/fs);
[frequency,~,~,magE] = frequencySpectrum(pulsSig,fs);
frequency(1) = [];
magE(1) = [];


st = makeCommonTransferMatrixInputStruct();
st.isDamping = 1;%是否计算阻尼
st.coeffDamping = nan;%阻尼系数
st.coeffFriction = 0.04;%管道摩擦系数
st.meanFlowVelocity = 14.5;%流速
st.k = nan;%波数
st.oumiga = nan;%圆频率
st.a = 345;%声速
st.isOpening = 1;%边界条件是否为开口
st.notMach = 1;%是否马赫
st.mach = st.meanFlowVelocity ./ st.a;


L1 = 3.5;%L1(m)
L2 = 6;%L2（m）长度
Dpipe = 0.106;%管道直径（m）%应该是0.106

vhpicStruct.l = 0.01;
vhpicStruct.Dv = 0.372;%缓冲罐的直径（m）
vhpicStruct.Lv = 1.1;%缓冲罐总长 
vhpicStruct.Lv1 =vhpicStruct.Lv./2;%缓冲罐腔1总长
vhpicStruct.Lv2 = vhpicStruct.Lv-vhpicStruct.Lv1;%缓冲罐腔2总长
vhpicStruct.lc = 0.005;%内插管壁厚
vhpicStruct.dp1 = 0.013;%开孔径
vhpicStruct.dp2 = 0.013;%开孔径
vhpicStruct.lp1 = 0.16;%内插管入口段非孔管开孔长度
vhpicStruct.lp2 = 0.16;%内插管出口段孔管开孔长度
vhpicStruct.n1 = 72;%入口段孔数
vhpicStruct.n2 = 72;%出口段孔数
vhpicStruct.Lin = 0.25;%内插管入口段长度
vhpicStruct.Lout = 0.25;
%         vhpicStruct.la1 = 0.03;%孔管入口段靠近入口长度
vhpicStruct.la2 = 0.06;%孔管
vhpicStruct.lb1 = 0.06;
%         vhpicStruct.lb2 = 0.03;
vhpicStruct.Din = 0.106/2;
vhpicStruct.la1 = vhpicStruct.Lin - vhpicStruct.lp1-vhpicStruct.la2;%0.25;%内插管入口段长度
vhpicStruct.lb2 = vhpicStruct.Lout - vhpicStruct.lp2-vhpicStruct.lb1;%0.25;
vhpicStruct.bp1 = vhpicStruct.n1.*(vhpicStruct.dp1)^2./(4.*vhpicStruct.Din.*vhpicStruct.lp1);%开孔率
vhpicStruct.bp2 = vhpicStruct.n2.*(vhpicStruct.dp2)^2./(4.*vhpicStruct.Din.*vhpicStruct.lp2);%开孔率
vhpicStruct.nc1 = 8;%假设一圈有8个孔
vhpicStruct.nc2 = 8;%假设一圈有8个孔
vhpicStruct.Cloum1 = vhpicStruct.n1./vhpicStruct.nc1;%计算一端固定开孔长度的孔管上能开多少圈孔
vhpicStruct.Cloum2 = vhpicStruct.n2./vhpicStruct.nc2;
vhpicStruct.s1 = ((vhpicStruct.lp1./vhpicStruct.Cloum1)-vhpicStruct.dp1)./2;%相邻两开孔之间间隔，默认等间隔
vhpicStruct.s2 = ((vhpicStruct.lp2./vhpicStruct.Cloum2)-vhpicStruct.dp2)./2;
vhpicStruct.sc1 = (pi.*vhpicStruct.Din - vhpicStruct.nc1.*vhpicStruct.dp1)./vhpicStruct.nc1;%一周开孔，相邻孔间距
vhpicStruct.sc2 = (pi.*vhpicStruct.Din - vhpicStruct.nc2.*vhpicStruct.dp2)./vhpicStruct.nc2;
l = vhpicStruct.lp1;
vhpicStruct.xSection1 = [0,ones(1,1).*(l/(1))];
l = vhpicStruct.lp2;
vhpicStruct.xSection2 = [0,ones(1,1).*(l/(1))];
sectionL1 = 0:0.25:L1;%[2.5,3.5];%0:0.25:L1;
sectionL2 = 0:0.25:L2;%[5.87,6.37,6.87，7.37,7.87,8.37,8.87,9.37,9.87,10.37]-L1-vhpicStruct.Lv1-vhpicStruct.Lv2;%0:0.25:L2;
vhpicStruct.lv1 = vhpicStruct.Lv./2-(0.150+0.168);%vhpicStruct.Lv./2-0.232;%内插管长于偏置管，偏置管la=罐体总长-罐封头边缘到偏置管中心距
vhpicStruct.lv2 = 0;%出口不偏置
vhpicStruct.lv3 = 0.150+0.168;%针对单一偏置缓冲罐入口偏置长度
vhpicStruct.lv4 = vhpicStruct.Lv./2-vhpicStruct.Lin;
vhpicStruct.Dbias = 0;%偏置管伸入罐体部分为0，所以对应直径为0
vhpicStruct.Dex = vhpicStruct.Din;

holepipeLength1 = vhpicStruct.Lin - vhpicStruct.la1 - vhpicStruct.la2;

[pressure1,pressure2] = vesselInBiasHaveInnerPerfBothClosedCompCalc(magE,frequency,time,L1,L2,Dpipe,vhpicStruct...
    ,sectionL1,sectionL2...
    ,st);
[pureVesselPressure1,pureVesselPressure2] = vesselStraightBiasPulsationCalc(magE,frequency,time,L1,L2...
    ,vhpicStruct.Lv,vhpicStruct.l,Dpipe,vhpicStruct.Dv,vhpicStruct.Lv2,vhpicStruct.Dbias...
    ,sectionL1,sectionL2...
    ,st);
 
pressure = [pressure1,pressure2];
pressureVessel = [pureVesselPressure1,pureVesselPressure2];

figure

[fre1,mag1] = frequencySpectrum(pressure,fs,'scale','amp');
[freVessel,magVessel] = frequencySpectrum(pressureVessel,fs,'scale','amp');

subplot(2,2,1)
y = fre1(:,1);
x = 1:size(mag1,2);
Z = mag1;
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
xlabel('mea point');
ylabel('fre (Hz)');
title('BiasHaveInnerPerfBothClosed');

subplot(2,2,2)
plotSpectrum(fre1(:,1),mag1(:,end-1));
title('pipe line output');
xlabel('fre (Hz)');
ylabel('amp');
ylim([0 300000]);

subplot(2,2,3)
y = freVessel(:,1);
x = 1:size(magVessel,2);
Z = magVessel;
[X,Y] = meshgrid(x,y);
contourf(X,Y,Z);
title('vesselStraightBias');

subplot(2,2,4)
plotSpectrum(freVessel(:,1),magVessel(:,end-1));
title('pipe line output');
xlabel('fre (Hz)');
ylabel('amp');
ylim([0 300000]);

set(gcf,'color','w');


