close all;
%有一部分双容分析在BeElbowTL里

    a = 345;
    Dpipe = 0.106;
    l1=0.318;
    l2=0.2;
    l3=0.2;
    DV1 = 0.372;%缓冲罐的直径（m）
    LV1 = 1.1/2;%缓冲罐总长 （1.1m）
    DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
    LV2 = 1.1/2;%variant_r(i).*param.DV2;%缓冲罐总长 （1.1m）
    V2 = pi.*DV2^2./4*LV2;
    Sv1 = pi.*(DV1)^2./4;
    Sv2 = pi.*(DV2)^2./4;
    S1= pi.*(Dpipe)^2./4;
    S2= pi.*(Dpipe)^2./4;
    S= pi.*(Dpipe)^2./4;
    Din = 0.106;
    Sin = pi.*(Din)^2./4;
    
  for  f = 1:100
    oumiga(f) = 2.*pi.*f;
    k(f) = oumiga(f)./a;
% 双容串联
%     A10 = 1;
%     B10 = 0;
%     C10= 1i.*(Sv1./a).*tan(k(f).*l1);
%     D10 = 1;

%     A11 = cos(k(f).*(LV1-l1-l2));
%     B11 = 1i.*(a./Sv1).*sin(k(f).*(LV1-l1-l2));
%     C11 = 1i.*(Sv1./a).*sin(k(f).*(LV1-l1-l2));
%     D11 = cos(k(f).*(LV1-l1-l2));
 
    A11 = cos(k(f).*(LV1));
    B11 = 1i.*(a./Sv1).*sin(k(f).*(LV1));
    C11 = 1i.*(Sv1./a).*sin(k(f).*(LV1));
    D11 = cos(k(f).*(LV1));
%     A12 = 1;
%     B12 = 0;
%     C12= 1i.*((Sv1-Sin)./a).*tan(k(f).*l2);
%     D12 = 1;
    
    A13 = cos(k(f).*l2);
    B13 = 1i.*(a./Sin).*sin(k(f).*l2);
    C13 = 1i.*(Sin./a).*sin(k(f).*l2);
    D13 = cos(k(f).*l2);
    
    A14 = cos(k(f).*l3);
    B14 = 1i.*(a./Sin).*sin(k(f).*l3);
    C14 = 1i.*(Sin./a).*sin(k(f).*l3);
    D14 = cos(k(f).*l3);
    
%     A15 = 1;
%     B15 = 0;
%     C15= 1i.*((Sv2-Sin)./a).*tan(k(f).*l3);
%     D15 = 1;
     
%     A16 = cos(k(f).*(LV2-l3));
%     B16 = 1i.*(a./Sv2).*sin(k(f).*(LV2-l3));
%     C16 = 1i.*(Sv2./a).*sin(k(f).*(LV2-l3));
%     D16 = cos(k(f).*(LV2-l3));
     
    A16 = cos(k(f).*(LV2));
    B16 = 1i.*(a./Sv2).*sin(k(f).*(LV2));
    C16 = 1i.*(Sv2./a).*sin(k(f).*(LV2));
    D16 = cos(k(f).*(LV2));

    %M1{f} = [A10,B10;C10,D10] * [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A13,B13;C13,D13]* [A14,B14;C14,D14]* [A15,B15;C15,D15]* [A16,B16;C16,D16];
    M1{f} = [A11,B11;C11,D11] * [A13,B13;C13,D13]* [A14,B14;C14,D14]* [A16,B16;C16,D16];
    KESEI1(f) = 1./((((S1./S2)^(1/2).*0.5.*abs(M1{f}(1,1) + M1{f}(1,2).*(S2./a) + M1{f}(2,1).*(a./S1) + M1{f}(2,2).*(S2./S1)))^2));

  end   
f = 1:length(KESEI1);




figure
paperFigureSet('small',6);
hold on;
box on;
grid off;
plot(f,KESEI1,'linewidth',1,'linestyle',getLineStyle(4),'color',getPlotColor(4));
xlabel('频率(Hz)','FontSize',10);
ylabel( '透射系数','FontSize',10);
%ylabel( '20lg(t_I)','FontSize',10);

hold on;


a = 345;
Dpipe = 0.106;
l1=0.318;
l2=0.2;
l3=0.2;
DV1 = 0.372;%缓冲罐的直径（m）
LV1 = 1.1/2;%缓冲罐总长 （1.1m）
DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
LV2 = 1.1/2;%variant_r(i).*param.DV2;%缓冲罐总长 （1.1m）
V2 = pi.*DV2^2./4*LV2;
Sv1 = pi.*(DV1)^2./4;
Sv2 = pi.*(DV2)^2./4;
S1= pi.*(Dpipe)^2./4;
S2= pi.*(Dpipe)^2./4;
S= pi.*(Dpipe)^2./4;
Din = 0.106*0.75;
Sin = pi.*(Din)^2./4;
    
  for  f = 1:100
    oumiga(f) = 2.*pi.*f;
    k(f) = oumiga(f)./a;
% 双容串联
%     A10 = 1;
%     B10 = 0;
%     C10= 1i.*(Sv1./a).*tan(k(f).*l1);
%     D10 = 1;

%     A11 = cos(k(f).*(LV1-l1-l2));
%     B11 = 1i.*(a./Sv1).*sin(k(f).*(LV1-l1-l2));
%     C11 = 1i.*(Sv1./a).*sin(k(f).*(LV1-l1-l2));
%     D11 = cos(k(f).*(LV1-l1-l2));
 
    A11 = cos(k(f).*(LV1));
    B11 = 1i.*(a./Sv1).*sin(k(f).*(LV1));
    C11 = 1i.*(Sv1./a).*sin(k(f).*(LV1));
    D11 = cos(k(f).*(LV1));
%     A12 = 1;
%     B12 = 0;
%     C12= 1i.*((Sv1-Sin)./a).*tan(k(f).*l2);
%     D12 = 1;
    
    A13 = cos(k(f).*l2);
    B13 = 1i.*(a./Sin).*sin(k(f).*l2);
    C13 = 1i.*(Sin./a).*sin(k(f).*l2);
    D13 = cos(k(f).*l2);
    
    A14 = cos(k(f).*l3);
    B14 = 1i.*(a./Sin).*sin(k(f).*l3);
    C14 = 1i.*(Sin./a).*sin(k(f).*l3);
    D14 = cos(k(f).*l3);
    
%     A15 = 1;
%     B15 = 0;
%     C15= 1i.*((Sv2-Sin)./a).*tan(k(f).*l3);
%     D15 = 1;
     
%     A16 = cos(k(f).*(LV2-l3));
%     B16 = 1i.*(a./Sv2).*sin(k(f).*(LV2-l3));
%     C16 = 1i.*(Sv2./a).*sin(k(f).*(LV2-l3));
%     D16 = cos(k(f).*(LV2-l3));
     
    A16 = cos(k(f).*(LV2));
    B16 = 1i.*(a./Sv2).*sin(k(f).*(LV2));
    C16 = 1i.*(Sv2./a).*sin(k(f).*(LV2));
    D16 = cos(k(f).*(LV2));

    %M1{f} = [A10,B10;C10,D10] * [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A13,B13;C13,D13]* [A14,B14;C14,D14]* [A15,B15;C15,D15]* [A16,B16;C16,D16];
    M1{f} = [A11,B11;C11,D11] * [A13,B13;C13,D13]* [A14,B14;C14,D14]* [A16,B16;C16,D16];
    KESEI1(f) = 1./((((S1./S2)^(1/2).*0.5.*abs(M1{f}(1,1) + M1{f}(1,2).*(S2./a) + M1{f}(2,1).*(a./S1) + M1{f}(2,2).*(S2./S1)))^2));

  end   
f = 1:length(KESEI1);

plot(f,KESEI1,'linewidth',1,'linestyle',getLineStyle(1),'color',getPlotColor(3));
hold on;

Din = 0.106*0.5;
Sin = pi.*(Din)^2./4;
    
  for  f = 1:100
    oumiga(f) = 2.*pi.*f;
    k(f) = oumiga(f)./a;
% 双容串联
%     A10 = 1;
%     B10 = 0;
%     C10= 1i.*(Sv1./a).*tan(k(f).*l1);
%     D10 = 1;

%     A11 = cos(k(f).*(LV1-l1-l2));
%     B11 = 1i.*(a./Sv1).*sin(k(f).*(LV1-l1-l2));
%     C11 = 1i.*(Sv1./a).*sin(k(f).*(LV1-l1-l2));
%     D11 = cos(k(f).*(LV1-l1-l2));
 
    A11 = cos(k(f).*(LV1));
    B11 = 1i.*(a./Sv1).*sin(k(f).*(LV1));
    C11 = 1i.*(Sv1./a).*sin(k(f).*(LV1));
    D11 = cos(k(f).*(LV1));
%     A12 = 1;
%     B12 = 0;
%     C12= 1i.*((Sv1-Sin)./a).*tan(k(f).*l2);
%     D12 = 1;
    
    A13 = cos(k(f).*l2);
    B13 = 1i.*(a./Sin).*sin(k(f).*l2);
    C13 = 1i.*(Sin./a).*sin(k(f).*l2);
    D13 = cos(k(f).*l2);
    
    A14 = cos(k(f).*l3);
    B14 = 1i.*(a./Sin).*sin(k(f).*l3);
    C14 = 1i.*(Sin./a).*sin(k(f).*l3);
    D14 = cos(k(f).*l3);
    
%     A15 = 1;
%     B15 = 0;
%     C15= 1i.*((Sv2-Sin)./a).*tan(k(f).*l3);
%     D15 = 1;
     
%     A16 = cos(k(f).*(LV2-l3));
%     B16 = 1i.*(a./Sv2).*sin(k(f).*(LV2-l3));
%     C16 = 1i.*(Sv2./a).*sin(k(f).*(LV2-l3));
%     D16 = cos(k(f).*(LV2-l3));
     
    A16 = cos(k(f).*(LV2));
    B16 = 1i.*(a./Sv2).*sin(k(f).*(LV2));
    C16 = 1i.*(Sv2./a).*sin(k(f).*(LV2));
    D16 = cos(k(f).*(LV2));

    %M1{f} = [A10,B10;C10,D10] * [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A13,B13;C13,D13]* [A14,B14;C14,D14]* [A15,B15;C15,D15]* [A16,B16;C16,D16];
    M1{f} = [A11,B11;C11,D11] * [A13,B13;C13,D13]* [A14,B14;C14,D14]* [A16,B16;C16,D16];
    KESEI1(f) = 1./((((S1./S2)^(1/2).*0.5.*abs(M1{f}(1,1) + M1{f}(1,2).*(S2./a) + M1{f}(2,1).*(a./S1) + M1{f}(2,2).*(S2./S1)))^2));

  end   
f = 1:length(KESEI1);

plot(f,KESEI1,'linewidth',1,'linestyle',getLineStyle(2),'color',getPlotColor(2));
h=legend({'1D','0.75D','0.5D'},'Position',[0.491308161207583 0.748978812957968 0.524137921168888 0.189054721623511]);  
set(h,'box','off')



