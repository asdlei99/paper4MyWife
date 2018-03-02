%计算传递损失和阻抗系数
%三维图阻抗系数随连接管长和f变化
clear all;
close all;
if 1
    a = 345;
%     L2 = 1.5;
    Dpipe = 0.098;
    DV1 = 0.372;%缓冲罐的直径（m）
    LV1 = 1.1;%缓冲罐总长 （1.1m）
    DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
    LV2 = 1.1;%variant_r(i).*param.DV2;%缓冲罐总长 （1.1m）
    V2 = pi.*DV2^2./4*LV2;
%     Lv1 = LV1./2;%缓冲罐腔1总长
%     Lv2 = LV1-Lv1;%缓冲罐腔2总长
    lv3 = 0.150+0.168;%针对单一偏置缓冲罐入口偏置长度
    Dbias = 0;%偏置管伸入罐体部分为0，所以对应直径为0
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

            %直进侧出缓冲罐
            %
            % 进    |---------| 
            %-------|         |
            %       |---------|
            %         |
            %         | 出

           
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
    xlabel('频率(Hz)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('连接管长(m)','FontSize',paperFontSize(),'fontName',paperFontName());
    zlabel('阻抗系数','FontSize',paperFontSize(),'fontName',paperFontName());
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
        %直进侧出缓冲罐
        %
        % 进    |---------|
        %-------|         |
        %       |---------|
        %         |
        %         | 出

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
        KESEI21(count) = ((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)))^2;
        count = count+1;
    end

    subplot(1,2,2);
    plot(v,KESEI21,'-*b');
    xlim([0,4]);
    xlabel('连接管长(m)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('阻抗系数','FontSize',paperFontSize(),'fontName',paperFontName());
    set(gca,'Position',[0.632075471698113 0.223214285714286 0.340639398697521 0.663504464285714]);
    annotation('textbox',...
        [0.540837398373984 0.88421052631579 0.0363983739837398 0.0631578947368421],...
        'String',{'(b)'},...
        'FontName','Times New Roman',...
        'FitBoxToText','off',...
        'EdgeColor','none');
end
%%
%三维图阻抗系数随长径比和f变化
if 1
    a = 345;
    AR = 0:0.5:5;%长径比
    Dv2 = ((4.*V2)./(pi.*AR)).^(1/3);
    Sv2 = pi.*Dv2.^2./4;
    Lv2 = Dv2.*AR;
    f0 = 1:50;
   
    for f = 1:length(f0)
        for j = 1:length(AR)
            oumiga(f) = 2.*pi.*f;
            k(f) = oumiga(f)./a;

            %直进侧出缓冲罐
            %
            % 进    |---------| 
            %-------|         |
            %       |---------|
            %         |
            %         | 出
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
    paperFigureSet_large(6.5);
    subplot(1,2,1);
    surf(X,Y,Z);
%     contourf(X,Y,Z);
    xlabel('长径比','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('频率(Hz)','FontSize',paperFontSize(),'fontName',paperFontName());
    zlabel('阻抗系数','FontSize',paperFontSize(),'fontName',paperFontName());
    box on;
    grid on;
    rang=[0,5];
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
    l1 = 0.150+0.168;%固定偏置距离
    L0 = 1.1;
    S0 = pi.*(0.372)^2./4;
    V0 = L0.*S0;%固定缓冲罐体积为实验体积
    AR = 0:0.01:5;%长径比
    Dv = ((4.*V0)./(pi.*AR)).^(1/3);
    Sv = pi.*Dv.^2./4;
    Lv = Dv.*AR;
    A21 = [];
    B21 = [];C21 = [];
    D21 = [];C22 = [];
    M2 = {};
    for v = AR
        %直进侧出缓冲罐
        %
        % 进    |---------|
        %-------|         |
        %       |---------|
        %         |
        %         | 出

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
        KESEI21(count) = ((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)))^2;

        count = count+1;
    end

    subplot(1,2,2);
    plot(AR,KESEI21,'-b');
    xlim([0,5]);
    xlabel('长径比','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('阻抗系数','FontSize',paperFontSize(),'fontName',paperFontName());
    set(gca,'Position',[0.632075471698113 0.223214285714286 0.340639398697521 0.663504464285714]);
    annotation('textbox',...
        [0.540837398373984 0.88421052631579 0.0363983739837398 0.0631578947368421],...
        'String',{'(b)'},...
        'FontName','Times New Roman',...
        'FitBoxToText','off',...
        'EdgeColor','none');

end

%% 固定频率为14Hz
%三维图阻抗系数随体积和长径比变化
if 1
    a = 345;
    Dpipe = 0.098;
    DV1 = 0.372;%缓冲罐的直径（m）
    LV1 = 1.1;%缓冲罐总长 （1.1m）
    lv3 = 0.150+0.168;%针对单一偏置缓冲罐入口偏置长度
    Dbias = 0;%偏置管伸入罐体部分为0，所以对应直径为0
    Sv1 = pi.*(DV1)^2./4;
    S1= pi.*(Dpipe)^2./4;
    S2= pi.*(Dpipe)^2./4;
    S= pi.*(Dpipe)^2./4;
    f0=14;
    Dpipe = 0.098;
    L0 = 1.1;
    S0 = pi.*(0.372)^2./4;
    V0 = L0.*S0;%固定缓冲罐体积为实验体积
    AR = 0:0.5:12;%长径比
    Dv = ((4.*V0)./(pi.*AR)).^(1/3);
    Sv = pi.*Dv.^2./4;
    Lv = Dv.*AR;
    L2 = 1.5;
    V0 = 0.05:0.05:0.18;
    for j = 1:length(AR)
        for g = 1:length(V0)
            oumiga = 2.*pi.*f0;
            k = oumiga./a;

            %直进侧出缓冲罐
            %
            % 进    |---------| 
            %-------|         |
            %       |---------|
            %         |
            %         | 出
            A11 = cos(k(f).*LV1);
            B11 = 1i.*(a./Sv1).*sin(k(f).*LV1);
            C11 = 1i.*(Sv1./a).*sin(k(f).*LV1);
            D11 = cos(k(f).*LV1);
                        
            A12 = cos(k(f).*L2(j));
            B12 = 1i.*(a./S).*sin(k(f).*L2(j));
            C12 = 1i.*(S./a).*sin(k(f).*L2(j));
            D12 = cos(k(f).*L2(j));

            A21 = cos(k.*lv3);
            B21 = 1i.*(a./Sv(j)).*sin(k.*lv3);
            C21 = 1i.*(Sv(j)./a).*sin(k.*lv3);
            D21 = cos(k.*lv3);
            A22 = 1;
            B22 = 0;
            C22 = 1i.*(Sv(j)./a).*tan(k.*(Lv(j)-lv3));
            D22 = 1;
            M2 = [A11,B11;C11,D11] * [A12,B12;C12,D12] * [A21,B21;C21,D21] * [A22,B22;C22,D22];
            % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));

            KESEI22(j,g) = ((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)))^2;
            maxLv1 = Lv - Dpipe;
            if lv3 > maxLv1
                KESEI22 = nan;
                continue;
            end

        end

    end
    [X,Y] = meshgrid(l1,AR);
    Z=KESEI22;

    figure
    paperFigureSet_large(6.5);
    subplot(1,2,1);
    surf(X,Y,Z);
    xlabel('偏置距离l1(m)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('长径比','FontSize',paperFontSize(),'fontName',paperFontName());
    zlabel('阻抗系数','FontSize',paperFontSize(),'fontName',paperFontName());
    box on;
    grid on;
    rang=[0,12];
    ylim(rang);
    rang=[0,1.2];
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
    paperFigureSet_large(6.5);
    subplot(1,2,2);
    contourf(X,Y,Z)
    xlabel('偏置距离l1(m)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('长径比','FontSize',paperFontSize(),'fontName',paperFontName());
    zlabel('阻抗系数','FontSize',paperFontSize(),'fontName',paperFontName());
    box on;
end