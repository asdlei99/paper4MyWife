clear all;
close all;
%有一部分双容分析在BeElbowTL里
if 1
    a = 345;
%     Dpipe = 0.098;
%     L1=3.5;
%     DV1 = 0.372;%缓冲罐的直径（m）
%     LV1 = 1.1;%缓冲罐总长 （1.1m）
%     DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
%     LV2 = 1.1;%variant_r(i).*param.DV2;%缓冲罐总长 （1.1m）
    Dpipe = 0.157;
    L1=13;
    DV1 = 0.5;%缓冲罐的直径（m）
    LV1 = 1;%缓冲罐总长 （1.1m）
    DV2 = 0.5;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
    LV2 = 1;%variant_r(i).*param.DV2;%缓冲罐总长 （1.1m）
    V2 = pi.*DV2^2./4*LV2;
%     Lv1 = LV1./2;%缓冲罐腔1总长
%     Lv2 = LV1-Lv1;%缓冲罐腔2总长
    Sv1 = pi.*(DV1)^2./4;
    Sv2 = pi.*(DV2)^2./4;
    S1= pi.*(Dpipe)^2./4;
    S2= pi.*(Dpipe)^2./4;
    S= pi.*(Dpipe)^2./4;
    f = 10;
    
  for  v = 1:100
    oumiga(f) = 2.*pi.*f;
    k(f) = oumiga(f)./a;
% 双容串联
     A10 = cos(k(f).*L1);
     B10 = 1i.*(a./Sv1).*sin(k(f).*L1);
     C10 = 1i.*(Sv1./a).*sin(k(f).*L1);
     D10 = cos(k(f).*L1);

     A11 = cos(k(f).*LV1);
     B11 = 1i.*(a./Sv1).*sin(k(f).*LV1);
     C11 = 1i.*(Sv1./a).*sin(k(f).*LV1);
     D11 = cos(k(f).*LV1);
     
     L2 = 0.1;%透射系数图用的是0.1，透射取log用0.05
     A12 = cos(k(f).*L2);
     B12 = 1i.*(a./S).*sin(k(f).*L2);
     C12 = 1i.*(S./a).*sin(k(f).*L2);
     D12 = cos(k(f).*L2);
     
     A21 = cos(k(f).*LV2);
     B21 = 1i.*(a./Sv2).*sin(k(f).*LV2);
     C21 = 1i.*(Sv2./a).*sin(k(f).*LV2);
     D21 = cos(k(f).*LV2);
     
     L2=6;
     A20 = 1;
     B20 = 0;
     C20 = 1i.*(Sv2./a).*tan(k(f).*L2);
     D20 = 1;
     
%      TL = a./(2.*pi).*sqrt(Ac./(Lc+0.6.*d).*(1./V1+1./V2));
     M1{f} = [A10,B10;C10,D10] * [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A21,B21;C21,D21]* [A20,B20;C20,D20];
     M11{f} = [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A21,B21;C21,D21];
     KESEI1(f) = 1./((((S1./S2)^(1/2).*0.5.*abs(M1{f}(1,1) + M1{f}(1,2).*(S2./a) + M1{f}(2,1).*(a./S1) + M1{f}(2,2).*(S2./S1)))^2));
     KESEI11(f) = 1./((((S1./S2)^(1/2).*0.5.*abs(M11{f}(1,1) + M11{f}(1,2).*(S2./a) + M11{f}(2,1).*(a./S1) + M11{f}(2,2).*(S2./S1)))^2));
      %KESEI11(f) = 20*log10(1./((((S1./S2)^(1/2).*0.5.*abs(M11{f}(1,1) + M11{f}(1,2).*(S2./a) + M11{f}(2,1).*(a./S1) + M11{f}(2,2).*(S2./S1)))^2)));  
%等容积单容结构
     A10 = cos(k(f).*L1);
     B10 = 1i.*(a./Sv1).*sin(k(f).*L1);
     C10 = 1i.*(Sv1./a).*sin(k(f).*L1);
     D10 = cos(k(f).*L1);
     A2 = cos(k(f).*(LV1+LV2));
     B2 = 1i.*(a./Sv1).*sin(k(f).*(LV1+LV2));
     C2 = 1i.*(Sv1./a).*sin(k(f).*(LV1+LV2));
     D2 = cos(k(f).*(LV1+LV2));
     
     L2=6;
     A20 = 1;
     B20 = 0;
     C20 = 1i.*(Sv2./a).*tan(k(f).*L2);
     D20 = 1;
     M2{f} = [A10,B10;C10,D10] * [A2,B2;C2,D2] * [A20,B20;C20,D20];
     M21{f} = [A2,B2;C2,D2];
     KESEI2(f) = 1./((((S1./S2)^(1/2).*0.5.*abs(M2{f}(1,1) + M2{f}(1,2).*(S2./a) + M2{f}(2,1).*(a./S1) + M2{f}(2,2).*(S2./S1)))^2));
     KESEI21(f) = 1./((((S1./S2)^(1/2).*0.5.*abs(M21{f}(1,1) + M21{f}(1,2).*(S2./a) + M21{f}(2,1).*(a./S1) + M21{f}(2,2).*(S2./S1)))^2));
     %KESEI21(f) = 20*log10(1./((((S1./S2)^(1/2).*0.5.*abs(M21{f}(1,1) + M21{f}(1,2).*(S2./a) + M21{f}(2,1).*(a./S1) + M21{f}(2,2).*(S2./S1)))^2)));
     
     %原有容积单容结构
     A10 = cos(k(f).*L1);
     B10 = 1i.*(a./Sv1).*sin(k(f).*L1);
     C10 = 1i.*(Sv1./a).*sin(k(f).*L1);
     D10 = cos(k(f).*L1);
     A2 = cos(k(f).*(LV1));
     B2 = 1i.*(a./Sv1).*sin(k(f).*(LV1));
     C2 = 1i.*(Sv1./a).*sin(k(f).*(LV1));
     D2 = cos(k(f).*(LV1));
     
     L2=6;
     A20 = 1;
     B20 = 0;
     C20 = 1i.*(Sv2./a).*tan(k(f).*L2);
     D20 = 1;
     %M2{f} = [A10,B10;C10,D10] * [A2,B2;C2,D2] * [A20,B20;C20,D20];
     M20{f} = [A2,B2;C2,D2];
     %KESEI2(f) = 1./((((S1./S2)^(1/2).*0.5.*abs(M2{f}(1,1) + M2{f}(1,2).*(S2./a) + M2{f}(2,1).*(a./S1) + M2{f}(2,2).*(S2./S1)))^2));
     KESEI20(f) = 1./((((S1./S2)^(1/2).*0.5.*abs(M20{f}(1,1) + M20{f}(1,2).*(S2./a) + M20{f}(2,1).*(a./S1) + M20{f}(2,2).*(S2./S1)))^2));
     %KESEI21(f) = 20*log10(1./((((S1./S2)^(1/2).*0.5.*abs(M21{f}(1,1) + M21{f}(1,2).*(S2./a) + M21{f}(2,1).*(a./S1) + M21{f}(2,2).*(S2./S1)))^2)));
     
  end   
f = 1:length(KESEI1);

if 0
figure
paperFigureSet('small',6);
hold on;
box on;
grid on;
plot(f,KESEI1,'-+r');
plot(f,KESEI2,'-ob');
plot(f,KESEI3,'-*g');
xlabel('频率(Hz)','FontSize',10);
ylabel( '透射系数','FontSize',10);
legend({'双容串联','等体积单容','弯头式双容'},'Position',[0.175982818741828 0.6960621462913 0.524137921168887 0.189054721623511]);
end

if 0
figure
paperFigureSet('small',6);
hold on;
box on;
grid off;
plot(f,KESEI11,'linewidth',1,'linestyle',getLineStyle(4),'color',getPlotColor(3));
plot(f,KESEI21,'linewidth',1,'linestyle',getLineStyle(2),'color',getPlotColor(1));
xlabel('频率(Hz)','FontSize',10);
%ylabel( '透射系数','FontSize',10);
ylabel( '20lg(t_I)','FontSize',10);
h=legend({'双容','等体积单容'},'Position',[0.175982818741828 0.6960621462913 0.524137921168887 0.189054721623511]);  
set(h,'box','off')
end

if 1
figure
paperFigureSet('small',6);
hold on;
box on;
grid off;
plot(f,KESEI11,'linewidth',1,'linestyle',getLineStyle(4),'color',getPlotColor(4));
plot(f,KESEI20,'linewidth',1,'linestyle',getLineStyle(2),'color',getPlotColor(1));
xlabel('频率(Hz)','FontSize',10);
ylabel( '透射系数','FontSize',10);
%ylabel( '20lg(t_I)','FontSize',10);
h=legend({'双容','原有单容'},'Position',[0.175982818741828 0.6960621462913 0.524137921168887 0.189054721623511]);  
set(h,'box','off')
end

if 0
figure
paperFigureSet('small',6);
hold on;
box on;
grid off;
plot(f,KESEI11,'linestyle',getLineStyle(1),'color',getPlotColor(1));
xlabel('频率(Hz)','FontSize',10);
ylabel( '透射系数','FontSize',10);
h=legend({'双容'},'Position',[0.175982818741828 0.6960621462913 0.524137921168887 0.189054721623511]);  
set(h,'box','off')
end
end