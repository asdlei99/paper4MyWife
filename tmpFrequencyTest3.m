%% ���ļ�����С���� - �׹����ĵ��������ظ����Կ׹�װ�ý��й���Ƶ�ʷ�����
% ���ļ��������׹ܺͲ����׹ܶ�������Ӧ�����

freTimes = 1;
fs = 1024*freTimes;
pulsSig = [2048,zeros(1,1024*freTimes-1)];
time = 0:1:(size(pulsSig,2)-1);
time = time .* (1/fs);
[frequency,~,~,magE] = frequencySpectrum(pulsSig,fs);
frequency(1) = [];
magE(1) = [];

Dpipe = 0.106;%�ܵ�ֱ����m��%Ӧ����0.106

st = makeCommonTransferMatrixInputStruct();
st.isDamping = 1;%�Ƿ��������
st.coeffDamping = nan;%����ϵ��
st.coeffFriction = 0.04;%�ܵ�Ħ��ϵ��
st.meanFlowVelocity = 14.5;%����
st.k = nan;%����
st.oumiga = nan;%ԲƵ��
st.a = 345;%����
st.isOpening = 0;%�߽������Ƿ�Ϊ����
st.notMach = 1;%�Ƿ����
st.mach = st.meanFlowVelocity ./ st.a;
st.D = Dpipe;

L1 = 3.5;%L1(m)
L2 = 6;%L2��m������


vhpicStruct.l = 0.01;
vhpicStruct.Dv = 0.372;%����޵�ֱ����m��
vhpicStruct.Lv = 1.1;%������ܳ� 
vhpicStruct.Lv1 =vhpicStruct.Lv./2;%�����ǻ1�ܳ�
vhpicStruct.Lv2 = vhpicStruct.Lv-vhpicStruct.Lv1;%�����ǻ2�ܳ�
vhpicStruct.lc = 0.005;%�ڲ�ܱں�
vhpicStruct.dp1 = 0.013;%���׾�
vhpicStruct.dp2 = 0.013;%���׾�
vhpicStruct.lp1 = 0.16;%�ڲ����ڶηǿ׹ܿ��׳���
vhpicStruct.lp2 = 0.16;%�ڲ�ܳ��ڶο׹ܿ��׳���
vhpicStruct.n1 = 72;%��ڶο���
vhpicStruct.n2 = 72;%���ڶο���
vhpicStruct.Lin = 0.25;%�ڲ����ڶγ���
vhpicStruct.Lout = 0.25;
%         vhpicStruct.la1 = 0.03;%�׹���ڶο�����ڳ���
vhpicStruct.la2 = 0.06;%�׹�
vhpicStruct.lb1 = 0.06;
%         vhpicStruct.lb2 = 0.03;
vhpicStruct.Din = 0.106/2;
vhpicStruct.la1 = vhpicStruct.Lin - vhpicStruct.lp1-vhpicStruct.la2;%0.25;%�ڲ����ڶγ���
vhpicStruct.lb2 = vhpicStruct.Lout - vhpicStruct.lp2-vhpicStruct.lb1;%0.25;
vhpicStruct.bp1 = vhpicStruct.n1.*(vhpicStruct.dp1)^2./(4.*vhpicStruct.Din.*vhpicStruct.lp1);%������
vhpicStruct.bp2 = vhpicStruct.n2.*(vhpicStruct.dp2)^2./(4.*vhpicStruct.Din.*vhpicStruct.lp2);%������
vhpicStruct.nc1 = 8;%����һȦ��8����
vhpicStruct.nc2 = 8;%����һȦ��8����
vhpicStruct.Cloum1 = vhpicStruct.n1./vhpicStruct.nc1;%����һ�˹̶����׳��ȵĿ׹����ܿ�����Ȧ��
vhpicStruct.Cloum2 = vhpicStruct.n2./vhpicStruct.nc2;
vhpicStruct.s1 = ((vhpicStruct.lp1./vhpicStruct.Cloum1)-vhpicStruct.dp1)./2;%����������֮������Ĭ�ϵȼ��
vhpicStruct.s2 = ((vhpicStruct.lp2./vhpicStruct.Cloum2)-vhpicStruct.dp2)./2;
vhpicStruct.sc1 = (pi.*vhpicStruct.Din - vhpicStruct.nc1.*vhpicStruct.dp1)./vhpicStruct.nc1;%һ�ܿ��ף����ڿ׼��
vhpicStruct.sc2 = (pi.*vhpicStruct.Din - vhpicStruct.nc2.*vhpicStruct.dp2)./vhpicStruct.nc2;
l = vhpicStruct.lp1;
vhpicStruct.xSection1 = [0,ones(1,1).*(l/(1))];
l = vhpicStruct.lp2;
vhpicStruct.xSection2 = [0,ones(1,1).*(l/(1))];
sectionL1 = 0:0.25:L1;%[2.5,3.5];%0:0.25:L1;
sectionL2 = 0:0.25:L2;%[5.87,6.37,6.87��7.37,7.87,8.37,8.87,9.37,9.87,10.37]-L1-vhpicStruct.Lv1-vhpicStruct.Lv2;%0:0.25:L2;
vhpicStruct.lv1 = vhpicStruct.Lv./2-(0.150+0.168);%vhpicStruct.Lv./2-0.232;%�ڲ�ܳ���ƫ�ùܣ�ƫ�ù�la=�����ܳ�-�޷�ͷ��Ե��ƫ�ù����ľ�
vhpicStruct.lv2 = 0;%���ڲ�ƫ��
vhpicStruct.lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
vhpicStruct.lv4 = vhpicStruct.Lv./2-vhpicStruct.Lin;
vhpicStruct.Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
vhpicStruct.Dex = vhpicStruct.Din;

holepipeLength1 = vhpicStruct.Lin - vhpicStruct.la1 - vhpicStruct.la2;
%�ڲ�׹����˱տ���������
[pressure1,pressure2] = vesselInBiasHaveInnerPerfBothClosedCompCalc(magE,frequency,time,L1,L2,Dpipe,vhpicStruct...
    ,sectionL1,sectionL2...
    ,st);
%�����ƫ����������
[pureVesselPressure1,pureVesselPressure2] = vesselStraightBiasPulsationCalc(magE,frequency,time,L1,L2...
    ,vhpicStruct.Lv,vhpicStruct.l,Dpipe,vhpicStruct.Dv,vhpicStruct.Lv2,vhpicStruct.Dbias...
    ,sectionL1,sectionL2...
    ,st);
%����ֱ�ܵķ�Χ
pipeLength = L1+vhpicStruct.Lv+L2;
sectionL = [sectionL1,sectionL2+L1+vhpicStruct.Lv];
afterIndex = length(sectionL1);
%ֱ����������
pressurePipe = straightPipePulsationCalc(magE,frequency,time,pipeLength,sectionL,st);

pressure = [pressure1,pressure2];
pressureVessel = [pureVesselPressure1,pureVesselPressure2];

%����Ƶ�ʵķ�Χ
freRang = 1:100;
%��ѹ�����и���Ҷ�任
[fre1,mag1] = frequencySpectrum(pressure,fs,'scale','ampDB');
fre1 = fre1(freRang,:);
mag1 = mag1(freRang,:);

[freVessel,magVessel] = frequencySpectrum(pressureVessel,fs,'scale','ampDB');
freVessel = freVessel(freRang,:);
magVessel = magVessel(freRang,:);

[frePipe,magPipe] = frequencySpectrum(pressurePipe,fs,'scale','ampDB');
frePipe = frePipe(freRang,:);
magPipe = magPipe(freRang,:);

%% ȫ��ϵ������Ӧ��ͼ
rowCount = 1;
columnCount = 3;
subplotCount = 1;
figure('Name','��ϵ������Ӧ-ȫ��ϵ������Ӧ��ͼ')

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




%% ��ǰ��ϵϵ������Ӧ��ͼ
figure('Name','��ϵ������Ӧ-��ǰ��ϵϵ������Ӧ��ͼ')
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

%% �޺��ϵϵ������Ӧ��ͼ
figure('Name','��ϵ������Ӧ-�޺��ϵϵ������Ӧ��ͼ')
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


