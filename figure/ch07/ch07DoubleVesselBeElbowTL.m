%���㴫����ʧ���迹ϵ��
%�Ƚϵ��ݻ����ݺ�˫�ݴ����ṹ
clear;
close all;
if 1
    a = 345;
    Dpipe = 0.098;
    L1=3.5;
    DV1 = 0.372;%����޵�ֱ����m��
    LV1 = 1.1;%������ܳ� ��1.1m��
    DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%����޵�ֱ����0.372m��
    LV2 = 1.1;%variant_r(i).*param.DV2;%������ܳ� ��1.1m��
%     Dpipe = 0.157;
%     L1=13;
%     DV1 = 0.5;%����޵�ֱ����m��
%     LV1 = 1;%������ܳ� ��1.1m��
%     DV2 = 0.5;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%����޵�ֱ����0.372m��
%     LV2 = 1;%variant_r(i).*param.DV2;%������ܳ� ��1.1m��
    V2 = pi.*DV2^2./4*LV2;
%     Lv1 = LV1./2;%�����ǻ1�ܳ�
%     Lv2 = LV1-Lv1;%�����ǻ2�ܳ�
    Sv1 = pi.*(DV1)^2./4;
    Sv2 = pi.*(DV2)^2./4;
    S1= pi.*(Dpipe)^2./4;
    S2= pi.*(Dpipe)^2./4;
    S= pi.*(Dpipe)^2./4;
  for  f = 1:100
    oumiga(f) = 2.*pi.*f;
    k(f) = oumiga(f)./a;
% ˫�ݴ���
     A10 = cos(k(f).*L1);
     B10 = 1i.*(a./Sv1).*sin(k(f).*L1);
     C10 = 1i.*(Sv1./a).*sin(k(f).*L1);
     D10 = cos(k(f).*L1);

     A11 = cos(k(f).*LV1);
     B11 = 1i.*(a./Sv1).*sin(k(f).*LV1);
     C11 = 1i.*(Sv1./a).*sin(k(f).*LV1);
     D11 = cos(k(f).*LV1);
     
     L2 = 0.1;%͸��ϵ��ͼ�õ���0.1��͸��ȡlog��0.05
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
%���ݻ����ݽṹ
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
     
     %ԭ���ݻ����ݽṹ
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
     
%��ͷʽ˫�ݽṹ
     L21 = 4;
     lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
     Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
     A10 = cos(k(f).*L1);
     B10 = 1i.*(a./Sv1).*sin(k(f).*L1);
     C10 = 1i.*(Sv1./a).*sin(k(f).*L1);
     D10 = cos(k(f).*L1);
     
     A11 = cos(k(f).*LV1);
     B11 = 1i.*(a./Sv1).*sin(k(f).*LV1);
     C11 = 1i.*(Sv1./a).*sin(k(f).*LV1);
     D11 = cos(k(f).*LV1);
     
     A12 = cos(k(f).*L21);
     B12 = 1i.*(a./S).*sin(k(f).*L21);
     C12 = 1i.*(S./a).*sin(k(f).*L21);
     D12 = cos(k(f).*L21);
     
     A21 = cos(k(f).*lv3);
     B21 = 1i.*(a./Sv2).*sin(k(f).*lv3);
     C21 = 1i.*(Sv2./a).*sin(k(f).*lv3);
     D21 = cos(k(f).*lv3);
     
     A22 = 1;
     B22 = 0;
     C22 = 1i.*(Sv2./a).*tan(k(f).*(LV2-lv3));
     D22 = 1;
     
     L2=4;
     A20 = 1;
     B20 = 0;
     C20 = 1i.*(Sv2./a).*tan(k(f).*L2);
     D20 = 1;
     
     M3{f} = [A10,B10;C10,D10] * [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A21,B21;C21,D21] * [A22,B22;C22,D22] * [A20,B20;C20,D20];
     M31{f} = [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A21,B21;C21,D21] * [A22,B22;C22,D22];
     KESEI3(f) = 1./((((S1./S2)^(1/2).*0.5.*abs(M3{f}(1,1) + M3{f}(1,2).*(S2./a) + M3{f}(2,1).*(a./S1) + M3{f}(2,2).*(S2./S1)))^2));
     KESEI31(f) = 1./((((S1./S2)^(1/2).*0.5.*abs(M31{f}(1,1) + M31{f}(1,2).*(S2./a) + M31{f}(2,1).*(a./S1) + M31{f}(2,2).*(S2./S1)))^2));
  end   
f = 1:length(KESEI1);

if 1
figure
paperFigureSet('small',6);
hold on;
box on;
grid off;
rang=[0,40];
xlim(rang);
plot(f,KESEI11,'linewidth',1,'linestyle',getLineStyle(4),'color',getPlotColor(2));
plot(f,KESEI20,'linewidth',1,'linestyle',getLineStyle(2),'color',getPlotColor(1));
plot(f,KESEI31,'linewidth',1,'linestyle',getLineStyle(1),'color',getPlotColor(3));
xlabel('Ƶ��(Hz)','FontSize',10);
ylabel( '͸��ϵ��','FontSize',10);
legend({'˫��','ԭ�е���','��ͷʽ˫��'},'Position',[0.175982818741828 0.6960621462913 0.524137921168887 0.189054721623511]);
end
if 0
figure
paperFigureSet('small',6);
hold on;
box on;
grid off;
plot(f,KESEI11,'linewidth',1,'linestyle',getLineStyle(4),'color',getPlotColor(3));
plot(f,KESEI21,'linewidth',1,'linestyle',getLineStyle(2),'color',getPlotColor(1));
xlabel('Ƶ��(Hz)','FontSize',10);
%ylabel( '͸��ϵ��','FontSize',10);
ylabel( '20lg(t_I)','FontSize',10);
h=legend({'˫��','���������'},'Position',[0.175982818741828 0.6960621462913 0.524137921168887 0.189054721623511]);  
set(h,'box','off')
end
if 0
figure
paperFigureSet('small',6);
hold on;
box on;
grid off;
plot(f,KESEI11,'linewidth',1,'linestyle',getLineStyle(4),'color',getPlotColor(4));
plot(f,KESEI20,'linewidth',1,'linestyle',getLineStyle(2),'color',getPlotColor(1));
xlabel('Ƶ��(Hz)','FontSize',10);
ylabel( '͸��ϵ��','FontSize',10);
%ylabel( '20lg(t_I)','FontSize',10);
h=legend({'˫��','ԭ�е���'},'Position',[0.175982818741828 0.6960621462913 0.524137921168887 0.189054721623511]);  
set(h,'box','off')
end
if 0
figure
paperFigureSet('small',6);
hold on;
box on;
grid off;
plot(f,KESEI11,'linestyle',getLineStyle(1),'color',getPlotColor(1));
xlabel('Ƶ��(Hz)','FontSize',10);
ylabel( '͸��ϵ��','FontSize',10);
h=legend({'˫��'},'Position',[0.175982818741828 0.6960621462913 0.524137921168887 0.189054721623511]);  
set(h,'box','off')
end

if 0
figure
paperFigureSet('small',6);
hold on;
box on;
grid off;
plot(f,KESEI31,'linestyle',getLineStyle(1),'color',getPlotColor(1));
xlabel('Ƶ��(Hz)','FontSize',10);
ylabel( '͸��ϵ��','FontSize',10);
h=legend({'��ͷʽ˫��'},'Position',[0.175982818741828 0.6960621462913 0.524137921168887 0.189054721623511]);  
set(h,'box','off')
end

if 0
figure
paperFigureSet('small',6);
hold on;
box on;
grid off;
plot(f,KESEI11,'linewidth',1,'linestyle',getLineStyle(2),'color',getPlotColor(2));
plot(f,KESEI31,'linewidth',1,'linestyle',getLineStyle(1),'color',getPlotColor(1));
xlabel('Ƶ��(Hz)','FontSize',10);
ylabel( '͸��ϵ��','FontSize',10);
%ylabel( '20lg(t_I)','FontSize',10);
h=legend({'˫��','��ͷʽ˫��'},'Position',[0.175982818741828 0.6960621462913 0.524137921168887 0.189054721623511]);  
set(h,'box','off')
end
end



%���㴫����ʧ���迹ϵ��
%��άͼ�迹ϵ�������ӹܳ���f�仯
% clear all;
% close all;
if 0
    a = 345;
%     L2 = 1.5;
    Dpipe = 0.098;
    DV1 = 0.372;%����޵�ֱ����m��
    LV1 = 1.1;%������ܳ� ��1.1m��
    DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%����޵�ֱ����0.372m��
    LV2 = 1.1;%variant_r(i).*param.DV2;%������ܳ� ��1.1m��
    V2 = pi.*DV2^2./4*LV2;
%     Lv1 = LV1./2;%�����ǻ1�ܳ�
%     Lv2 = LV1-Lv1;%�����ǻ2�ܳ�
    lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
    Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
    Sv1 = pi.*(DV1)^2./4;
    Sv2 = pi.*(DV2)^2./4;
    S1= pi.*(Dpipe)^2./4;
    S2= pi.*(Dpipe)^2./4;
    S= pi.*(Dpipe)^2./4;
    L2 = 0.05:0.05:4;
    f0 = 1:50;
    for j = 1:length(L2)
        for f = 1:length(f0)
            oumiga(f) = 2.*pi.*f;
            k(f) = oumiga(f)./a;

            %ֱ����������
            %
            % ��    |---------| 
            %-------|         |
            %       |---------|
            %         |
            %         | ��

           
            A11 = cos(k(f).*LV1);
            B11 = 1i.*(a./Sv1).*sin(k(f).*LV1);
            C11 = 1i.*(Sv1./a).*sin(k(f).*LV1);
            D11 = cos(k(f).*LV1);
                        
            A12 = cos(k(f).*L2(j));
            B12 = 1i.*(a./S).*sin(k(f).*L2(j));
            C12 = 1i.*(S./a).*sin(k(f).*L2(j));
            D12 = cos(k(f).*L2(j));
                       
            A21 = cos(k(f).*lv3);
            B21 = 1i.*(a./Sv2).*sin(k(f).*lv3);
            C21 = 1i.*(Sv2./a).*sin(k(f).*lv3);
            D21 = cos(k(f).*lv3);
            A22 = 1;
            B22 = 0;
            C22 = 1i.*(Sv2./a).*tan(k(f).*(LV2-lv3));
            D22 = 1;
            M2 = [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A21,B21;C21,D21] * [A22,B22;C22,D22];
            % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));
            KESEI2(j,f) = ((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)))^2;

        end

    end
    [X,Y] = meshgrid(f0,L2);
    Z=KESEI2;

    figure
    paperFigureSet_large(6.5);
    subplot(1,2,1);
    surf(X,Y,Z);
    xlabel('Ƶ��(Hz)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('���ӹܳ�(m)','FontSize',paperFontSize(),'fontName',paperFontName());
    zlabel('�迹ϵ��','FontSize',paperFontSize(),'fontName',paperFontName());
    box on;
    grid on;
    rang=[0,4];
    ylim(rang);
    hold on;
    ax=axis();
    x = [14,14,14,14,14];
    y = [ax(3),ax(3),ax(4),ax(4),ax(3)];
    z = [ax(3),ax(6),ax(6),ax(5),ax(5)];
    h = fill3(x,y,z,'r');
    set(h,'facealpha',0.2);
    text(x(2),y(2),z(2)+5,'a');
    text(x(4),y(4),z(4)-5,'a');
    view(-147,24);
    g = get(gca,'xlabel');
    set(g,'rotation',-9);
    p = get(gca,'ylabel');
    set(p,'rotation',32);
    set(gca,'Position',[0.104079126875853 0.173616071428571 0.358930832605346 0.751383928571428]);
    annotation('textbox',...
        [0.00966470673635309 0.875160256410257 0.0519166666666666 0.073269230769232],...
        'String',{'(a)'},...
        'FontName','Times New Roman',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    hold on;


    f0 =14;
    oumiga = 2.*pi.*f0;
    k = oumiga./a;
    count = 1;
    v = 0.05:0.05:4;
    for L2 = v
        %ֱ����������
        %
        % ��    |---------|
        %-------|         |
        %       |---------|
        %         |
        %         | ��

        S1= pi.*(0.106)^2./4;
        S2= pi.*(0.106)^2./4;

        A11 = cos(k.*LV1);
        B11 = 1i.*(a./Sv1).*sin(k.*LV1);
        C11 = 1i.*(Sv1./a).*sin(k.*LV1);
        D11 = cos(k.*LV1);
        
        A12 = cos(k.*L2);
        B12 = 1i.*(a./S).*sin(k.*L2);
        C12 = 1i.*(S./a).*sin(k.*L2);
        D12 = cos(k.*L2);
        
        A21 = cos(k.*lv3);
        B21 = 1i.*(a./Sv2).*sin(k.*lv3);
        C21 = 1i.*(Sv2./a).*sin(k.*lv3);
        D21 = cos(k.*lv3);
        A22 = 1;
        B22 = 0;
        C22 = 1i.*(Sv2./a).*tan(k.*(LV2-lv3));
        D22 = 1;
        M2 = [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A21,B21;C21,D21] * [A22,B22;C22,D22];
        % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));
%         KESEI21(count) = ((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)))^2;
        KESEI21(count) = 1/(((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)))^2);
        count = count+1;
    end

%     subplot(1,2,2);
    figure
    paperFigureSet_small(6.5)
%     paperFigureSet('moreSmall',5.5);
    plot(v,KESEI21,'-*b');
    xlim([0,4]);
    if 0
    xlabel('���ӹܳ�(m)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('�迹ϵ��','FontSize',paperFontSize(),'fontName',paperFontName());
    end
    if 1
    xlabel('Lc(m)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('Transmission coefficient','FontSize',paperFontSize(),'fontName',paperFontName());
    end
%     set(gca,'Position',[0.632075471698113 0.223214285714286 0.340639398697521 0.663504464285714]);
%     annotation('textbox',...
%         [0.540837398373984 0.88421052631579 0.0363983739837398 0.0631578947368421],...
%         'String',{'(b)'},...
%         'FontName','Times New Roman',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');
    annotation('textbox',...
        [0.540837398373984 0.88421052631579 0.0363983739837398 0.0631578947368421],...
        'FontName','Times New Roman',...
        'FitBoxToText','off',...
        'EdgeColor','none');
end
%%
%��άͼ�迹ϵ���泤���Ⱥ�f�仯
if 0
    a = 345;
    L2 = 1.5;
    Dpipe = 0.098;
    DV1 = 0.372;%����޵�ֱ����m��
    LV1 = 1.1;%������ܳ� ��1.1m��
    V2 = pi.*DV1^2./4*LV1;
%     Lv1 = LV1./2;%�����ǻ1�ܳ�
%     Lv2 = LV1-Lv1;%�����ǻ2�ܳ�
    lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
    Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
    Sv1 = pi.*(DV1)^2./4;
    S= pi.*(Dpipe)^2./4;
    AR = 0:0.5:24;%������
    Dv2 = ((4.*V2)./(pi.*AR)).^(1/3);
    Sv2 = pi.*Dv2.^2./4;
    LV2 = Dv2.*AR;
    f0 = 1:50;
   
    for f = 1:length(f0)
        for j = 1:length(AR)
            oumiga(f) = 2.*pi.*f;
            k(f) = oumiga(f)./a;

            %ֱ����������
            %
            % ��    |---------| 
            %-------|         |
            %       |---------|
            %         |
            %         | ��
        S1= pi.*(0.106)^2./4;
        S2= pi.*(0.106)^2./4;

        A11 = cos(k(f).*LV1);
        B11 = 1i.*(a./Sv1).*sin(k(f).*LV1);
        C11 = 1i.*(Sv1./a).*sin(k(f).*LV1);
        D11 = cos(k(f).*LV1);
        
        A12 = cos(k(f).*L2);
        B12 = 1i.*(a./S).*sin(k(f).*L2);
        C12 = 1i.*(S./a).*sin(k(f).*L2);
        D12 = cos(k(f).*L2);
        
        A21 = cos(k(f).*lv3);
        B21 = 1i.*(a./Sv2(j)).*sin(k(f).*lv3);
        C21 = 1i.*(Sv2(j)./a).*sin(k(f).*lv3);
        D21 = cos(k(f).*lv3);
        A22 = 1;
        B22 = 0;
        C22 = 1i.*(Sv2(j)./a).*tan(k(f).*(LV2(j)-lv3));
        D22 = 1;
        M2 = [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A21,B21;C21,D21] * [A22,B22;C22,D22];
        % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));
        KESEI2(f,j) = ((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)))^2;

        end

    end
    [X,Y] = meshgrid(AR,f0);
    Z=KESEI2;

    figure
%     paperFigureSet_large(6.5);
%     subplot(1,2,1);
    surf(X,Y,Z);
%     contourf(X,Y,Z);
    xlabel('������','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('Ƶ��(Hz)','FontSize',paperFontSize(),'fontName',paperFontName());
    zlabel('�迹ϵ��','FontSize',paperFontSize(),'fontName',paperFontName());
    box on;
    grid on;
    rang=[0,25];
    xlim(rang);
    hold on;
    ax=axis();
    x = [ax(3),ax(3),ax(4),ax(4),ax(3)];
    y = [14,14,14,14,14];
    z = [ax(3),ax(6),ax(6),ax(5),ax(5)];
    h = fill3(x,y,z,'r');
    set(h,'facealpha',0.2);
    text(x(2),y(2),z(2)+5,'a');
    text(x(4),y(4),z(4)-5,'a');
    view(-147,24);
    g = get(gca,'xlabel');
    set(g,'rotation',-9);
    p = get(gca,'ylabel');
    set(p,'rotation',32);
    set(gca,'Position',[0.104079126875853 0.173616071428571 0.358930832605346 0.751383928571428]);
    annotation('textbox',...
        [0.00966470673635309 0.875160256410257 0.0519166666666666 0.073269230769232],...
        'String',{'(a)'},...
        'FontName','Times New Roman',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    hold on;


    f0 =14;
    oumiga = 2.*pi.*f0;
    k = oumiga./a;
    count = 1;
    l1 = 0.150+0.168;%�̶�ƫ�þ���
    L0 = 1.1;
    S0 = pi.*(0.372)^2./4;
    V0 = L0.*S0;%�̶���������Ϊʵ�����
    AR = 0:0.1:30;%������
    Dv = ((4.*V0)./(pi.*AR)).^(1/3);
    Sv = pi.*Dv.^2./4;
    LV = Dv.*AR;
    A21 = [];
    B21 = [];C21 = [];
    D21 = [];C22 = [];
    M2 = {};
    for v = AR
        %ֱ����������
        %
        % ��    |---------|
        %-------|         |
        %       |---------|
        %         |
        %         | ��

        S1= pi.*(0.106)^2./4;
        S2= pi.*(0.106)^2./4;

        A11 = cos(k.*LV1);
        B11 = 1i.*(a./Sv1).*sin(k.*LV1);
        C11 = 1i.*(Sv1./a).*sin(k.*LV1);
        D11 = cos(k.*LV1);
        
        A12 = cos(k.*L2);
        B12 = 1i.*(a./S).*sin(k.*L2);
        C12 = 1i.*(S./a).*sin(k.*L2);
        D12 = cos(k.*L2);
        
        A21 = cos(k.*lv3);
        B21 = 1i.*(a./Sv(count)).*sin(k.*lv3);
        C21 = 1i.*(Sv(count)./a).*sin(k.*lv3);
        D21 = cos(k.*lv3);
        A22 = 1;
        B22 = 0;
        C22 = 1i.*(Sv(count)./a).*tan(k.*(LV(count)-lv3));
        D22 = 1;
        M2 = [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A21,B21;C21,D21] * [A22,B22;C22,D22];
        % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));
%          KESEI21(count) = ((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)))^2;
         KESEI21(count) = 1/(((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)))^2);

        count = count+1;
    end

    figure
    paperFigureSet('Small',6.5);
%     subplot(1,2,2);
    plot(AR,KESEI21,'-b');
    xlim([0,30]);
    if 0
    xlabel('������','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('�迹ϵ��','FontSize',paperFontSize(),'fontName',paperFontName());
    end
    if 1
    xlabel('r','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('Transmission coefficient','FontSize',paperFontSize(),'fontName',paperFontName());
    end
    
    
%     set(gca,'Position',[0.632075471698113 0.223214285714286 0.340639398697521 0.663504464285714]);
%     annotation('textbox',...
%         [0.540837398373984 0.88421052631579 0.0363983739837398 0.0631578947368421],...
%         'String',{'(b)'},...
%         'FontName','Times New Roman',...
%         'FitBoxToText','off',...
%         'EdgeColor','none');

end

%% �̶�Ƶ��Ϊ14Hz
%��άͼ�迹ϵ��������ͳ����ȱ仯
if 0
    a = 345;
    Dpipe = 0.098;
    DV1 = 0.372;%����޵�ֱ����m��
    LV1 = 1.1;%������ܳ� ��1.1m��
    lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
    Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
    Sv1 = pi.*(DV1)^2./4;
    S1= pi.*(Dpipe)^2./4;
    S2= pi.*(Dpipe)^2./4;
    S= pi.*(Dpipe)^2./4;
    f0=14;
    Dpipe = 0.098;
    L0 = 1.1;
    S0 = pi.*(0.372)^2./4;
    AR = 0.0005:0.5:30;%������
    L2 = 1.5;
    V0 = 0.05:0.01:0.18;
    for j = 1:length(AR)
        for g = 1:length(V0)
            Dv = ((4.*V0(g))./(pi.*AR(j))).^(1/3);
            Sv = pi.*Dv.^2./4;
            Lv = Dv.*AR(j);
            oumiga = 2.*pi.*f0;
            k = oumiga./a;

            %ֱ����������
            %
            % ��    |---------| 
            %-------|         |
            %       |---------|
            %         |
            %         | ��
            A11 = cos(k.*LV1);
            B11 = 1i.*(a./Sv1).*sin(k.*LV1);
            C11 = 1i.*(Sv1./a).*sin(k.*LV1);
            D11 = cos(k.*LV1);
                        
            A12 = cos(k.*L2);
            B12 = 1i.*(a./S).*sin(k.*L2);
            C12 = 1i.*(S./a).*sin(k.*L2);
            D12 = cos(k.*L2);

            A21 = cos(k.*lv3);
            B21 = 1i.*(a./Sv).*sin(k.*lv3);
            C21 = 1i.*(Sv./a).*sin(k.*lv3);
            D21 = cos(k.*lv3);
            A22 = 1;
            B22 = 0;
            C22 = 1i.*(Sv./a).*tan(k.*(Lv-lv3));
            D22 = 1;
            M2 = [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A21,B21;C21,D21] * [A22,B22;C22,D22];
            % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));

            KESEI22(j,g) = ((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)))^2;
            maxLv1 = Lv - Dpipe;
            if lv3 > maxLv1
                KESEI22(j,g) = nan;
                continue;
            end

        end

    end
    [X,Y] = meshgrid(V0,AR);
    Z=KESEI22;

    figure
    paperFigureSet_large(6.5);
%     subplot(1,2,1);
    surf(X,Y,Z);
    xlabel('���(m3)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('������','FontSize',paperFontSize(),'fontName',paperFontName());
    zlabel('�迹ϵ��','FontSize',paperFontSize(),'fontName',paperFontName());
    box on;
    grid on;
    hold on;
    ax=axis();
    x = [ax(3),ax(3),ax(4),ax(4),ax(3)];
    y = [2.957,2.957,2.957,2.957,2.957];
    z = [ax(3),ax(6),ax(6),ax(5),ax(5)];
    h = fill3(x,y,z,'r');
    set(h,'facealpha',0.2);
    text(x(2),y(2),z(2)+5,'a');
    text(x(4),y(4),z(4)-5,'a');
    view(-147,24);
    g = get(gca,'xlabel');
    set(g,'rotation',-9);
    p = get(gca,'ylabel');
    set(p,'rotation',32);
    set(gca,'Position',[0.104079126875853 0.173616071428571 0.358930832605346 0.751383928571428]);
    annotation('textbox',...
        [0.00966470673635309 0.875160256410257 0.0519166666666666 0.073269230769232],...
        'String',{'(a)'},...
        'FontName','Times New Roman',...
        'FitBoxToText','off',...
        'EdgeColor','none');
%     hold on;
%     paperFigureSet_large(6.5);
%     subplot(1,2,2);
%     contourf(X,Y,Z)
%     xlabel('�����m3��','FontSize',paperFontSize(),'fontName',paperFontName());
%     ylabel('������','FontSize',paperFontSize(),'fontName',paperFontName());
%     zlabel('�迹ϵ��','FontSize',paperFontSize(),'fontName',paperFontName());
%     box on;
end