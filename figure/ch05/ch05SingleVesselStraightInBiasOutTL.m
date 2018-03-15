%计算传递损失和阻抗系数
%三维图阻抗系数随l1和f变化
clear all;
close all;
if 1
    a = 345;
    Lv = 1.1;
    Sv = pi.*(0.372)^2./4;
    l1 = 0.005:0.05:Lv;
    f0 = 1:100;
    for j = 1:length(l1)
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

            S1= pi.*(0.106)^2./4;
            S2= pi.*(0.106)^2./4;

            A21(j,f) = cos(k(f).*l1(j));
            B21(j,f) = 1i.*(a./Sv).*sin(k(f).*l1(j));
            C21(j,f) = 1i.*(Sv./a).*sin(k(f).*l1(j));
            D21(j,f) = cos(k(f).*l1(j));
            A22 = 1;
            B22 = 0;
            C22(j,f) = 1i.*(Sv./a).*tan(k(f).*(Lv-l1(j)));
            D22 = 1;
            M2{j,f} = [A21(j,f),B21(j,f);C21(j,f),D21(j,f)] * [A22,B22;C22(j,f),D22];
            % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));
            KESEI2(j,f) = 1./(((S1./S2)^(1/2).*0.5.*abs(M2{j,f}(1,1) + M2{j,f}(1,2).*(S2./a) + M2{j,f}(2,1).*(a./S1) + M2{j,f}(2,2).*(S2./S1)))^2);
            

            %侧进直出缓冲罐
            % 进 |
            % |--|---------|  出
            % |            ---------
            % |------------|
            
            S1= pi.*(0.106)^2./4;
            S2= pi.*(0.106)^2./4;
     
            A31 = 1;
            B31 = 0;
            C31(j,f) = 1i.*(Sv./a).*tan(k(f).*(Lv-l1(j)));
            D31 = 1;
            A32(j,f) = cos(k(f).*l1(j));
            B32(j,f) = 1i.*(a./Sv).*sin(k(f).*l1(j));
            C32(j,f) = 1i.*(Sv./a).*sin(k(f).*l1(j));
            D32(j,f) = cos(k(f).*l1(j));
            M3{j,f} = [A31,B31;C31(j,f),D31] * [A32(j,f),B32(j,f);C32(j,f),D32(j,f)];
            % TL3 = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M3(1,1) + M3(1,2).*(S2./a) + M3(2,1).*(a./S1) + M3(2,2).*(S2./S1)));
            KESEI3(j,f) = 1-1./(((S1./S2)^(1/2).*0.5.*abs(M3{j,f}(1,1) + M3{j,f}(1,2).*(S2./a) + M3{j,f}(2,1).*(a./S1) + M3{j,f}(2,2).*(S2./S1)))^2);
        end

    end
    [X,Y] = meshgrid(f0,l1);
    Z1=KESEI2;

    figure
    paperFigureSet_large(6.5);
    subplot(1,2,1);
    surf(X,Y,Z1);
    xlabel('频率(Hz)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('偏置距离l1(m)','FontSize',paperFontSize(),'fontName',paperFontName());
    zlabel('正向透射系数','FontSize',paperFontSize(),'fontName',paperFontName());
    box on;
    grid on;
    rang=[0,1.1];
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
    
    subplot(1,2,2);
    Z2=KESEI3;
    surf(X,Y,Z2);
    xlabel('频率(Hz)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('偏置距离l1(m)','FontSize',paperFontSize(),'fontName',paperFontName());
    zlabel('反向阻抗系数','FontSize',paperFontSize(),'fontName',paperFontName());
    box on;
    grid on;
    rang=[0,1.1];
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
    set(gca,'Position',[0.632075471698113 0.223214285714286 0.340639398697521 0.663504464285714]);
    annotation('textbox',...
        [0.540837398373984 0.88421052631579 0.0363983739837398 0.0631578947368421],...
        'String',{'(b)'},...
        'FontName','Times New Roman',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    
    


    f0 =14;
    oumiga = 2.*pi.*f0;
    k = oumiga./a;
    count = 1;
    l1 = 0.005:0.05:Lv;
    for v = l1
        %直进侧出缓冲罐
        %
        % 进    |---------|
        %-------|         |
        %       |---------|
        %         |
        %         | 出

        S1= pi.*(0.106)^2./4;
        S2= pi.*(0.106)^2./4;
        
%         L1=3.5;
%         A20(count) = cos(k.*L1);
%         B20(count) = 1i.*(a./Sv).*sin(k.*L1);
%         C20(count) = 1i.*(Sv./a).*sin(k.*L1);
%         D20(count) = cos(k.*L1);
        A21(count) = cos(k.*v);
        B21(count) = 1i.*(a./Sv).*sin(k.*v);
        C21(count) = 1i.*(Sv./a).*sin(k.*v);
        D21(count) = cos(k.*v);
        A22 = 1;
        B22 = 0;
        C22(count) = 1i.*(Sv./a).*tan(k.*(Lv-v));
        D22 = 1;
        L2 = 6;
%         A23 = 1;
%         B23 = 0;
%         C23(count) = 1i.*(Sv./a).*tan(k.*L2);
%         D23 = 1;
        M2{count} = [A21(count),B21(count);C21(count),D21(count)] * [A22,B22;C22(count),D22];
        % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));
        KESEI21(count) = 1-1./(((S1./S2)^(1/2).*0.5.*abs(M2{count}(1,1) + M2{count}(1,2).*(S2./a) + M2{count}(2,1).*(a./S1) + M2{count}(2,2).*(S2./S1)))^2);
       
        %侧进直出缓冲罐
        % 进 |
        % |--|---------|  出
        % |            ---------
        % |------------|
        
        S1= pi.*(0.106)^2./4;
        S2= pi.*(0.106)^2./4;
        
        A31 = 1;
        B31 = 0;
        C31(count) = 1i.*(Sv./a).*tan(k.*(Lv-v));
        D31 = 1;
        A32(count) = cos(k.*v);
        B32(count) = 1i.*(a./Sv).*sin(k.*v);
        C32(count)= 1i.*(Sv./a).*sin(k.*v);
        D32(count) = cos(k.*v);
        M3{count} = [A31,B31;C31(count),D31] * [A32(count),B32(count);C32(count),D32(count)];
        % TL3 = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M3(1,1) + M3(1,2).*(S2./a) + M3(2,1).*(a./S1) + M3(2,2).*(S2./S1)));
        KESEI31(count) = 1./(((S1./S2)^(1/2).*0.5.*abs(M3{count}(1,1) + M3{count}(1,2).*(S2./a) + M3{count}(2,1).*(a./S1) + M3{count}(2,2).*(S2./S1)))^2);
        count = count+1;
    end

    figure
    subplot(1,2,1);
    plot(l1,KESEI21,'-*b');
    xlim([0,1.1]);
    xlabel('偏置距离l1(m)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('正向透射系数','FontSize',paperFontSize(),'fontName',paperFontName());
    set(gca,'Position',[0.104079126875853 0.173616071428571 0.358930832605346 0.751383928571428]);
    annotation('textbox',...
        [0.00966470673635309 0.875160256410257 0.0519166666666666 0.073269230769232],...
        'String',{'(a)'},...
        'FontName','Times New Roman',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    
    subplot(1,2,2);
    plot(l1,KESEI31,'-*b');
    xlim([0,1.1]);
    xlabel('偏置距离l1(m)','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('反向阻抗系数','FontSize',paperFontSize(),'fontName',paperFontName());
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
if 0
    a = 345;
    l1 = 0.150+0.168;%固定偏置距离
    L0 = 1.1;
    S0 = pi.*(0.372)^2./4;
    V0 = L0.*S0;%固定缓冲罐体积为实验体积
    AR = 0:0.5:12;%长径比
    Dv = ((4.*V0)./(pi.*AR)).^(1/3);
    Sv = pi.*Dv.^2./4;
    Lv = Dv.*AR;
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

            A21(f) = cos(k(f).*l1);
            B21(f,j) = 1i.*(a./Sv(j)).*sin(k(f).*l1);
            C21(f,j) = 1i.*(Sv(j)./a).*sin(k(f).*l1);
            D21(f) = cos(k(f).*l1);
            A22 = 1;
            B22 = 0;
            C22(f,j) = 1i.*(Sv(j)./a).*tan(k(f).*(Lv(j)-l1));
            D22 = 1;
            M2{f,j} = [A21(f),B21(f,j);C21(f,j),D21(f)] * [A22,B22;C22(f,j),D22];
            % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));
            KESEI2(f,j) = 1./(((S1./S2)^(1/2).*0.5.*abs(M2{f,j}(1,1) + M2{f,j}(1,2).*(S2./a) + M2{f,j}(2,1).*(a./S1) + M2{f,j}(2,2).*(S2./S1)))^2);

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
    zlabel('透射系数','FontSize',paperFontSize(),'fontName',paperFontName());
    box on;
    grid on;
    rang=[0,12];
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
    AR = 0:0.01:12;%长径比
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

        A21 = cos(k.*l1);
        B21(count) = 1i.*(a./Sv(count)).*sin(k.*l1);
        C21(count) = 1i.*(Sv(count)./a).*sin(k.*l1);
        D21 = cos(k.*l1);
        A22 = 1;
        B22 = 0;
        C22(count) = 1i.*(Sv(count)./a).*tan(k.*(Lv(count)-l1));
        D22 = 1;
        M2{count} = [A21,B21(count);C21(count),D21] * [A22,B22;C22(count),D22];
        % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));
        KESEI21(count) = 1./(((S1./S2)^(1/2).*0.5.*abs(M2{count}(1,1) + M2{count}(1,2).*(S2./a) + M2{count}(2,1).*(a./S1) + M2{count}(2,2).*(S2./S1)))^2);
        count = count+1;
    end

    subplot(1,2,2);
    plot(AR,KESEI21,'-b');
    xlim([0,12]);
    xlabel('长径比','FontSize',paperFontSize(),'fontName',paperFontName());
    ylabel('透射系数','FontSize',paperFontSize(),'fontName',paperFontName());
    set(gca,'Position',[0.632075471698113 0.223214285714286 0.340639398697521 0.663504464285714]);
    annotation('textbox',...
        [0.540837398373984 0.88421052631579 0.0363983739837398 0.0631578947368421],...
        'String',{'(b)'},...
        'FontName','Times New Roman',...
        'FitBoxToText','off',...
        'EdgeColor','none');

end

%% 固定频率为14Hz
%三维图阻抗系数随长径比和偏执距离变化
if 1
    a = 345;
    f0=14;
    Dpipe = 0.098;
    L0 = 1.1;
    S0 = pi.*(0.372)^2./4;
    V0 = L0.*S0;%固定缓冲罐体积为实验体积
    AR = 0:0.5:12;%长径比
    Dv = ((4.*V0)./(pi.*AR)).^(1/3);
    Sv = pi.*Dv.^2./4;
    Lv = Dv.*AR;
    l1 = 0.005:0.05:L0;
    for j = 1:length(AR)
        for g = 1:length(l1)
            oumiga = 2.*pi.*f0;
            k = oumiga./a;

            %直进侧出缓冲罐
            %
            % 进    |---------| 
            %-------|         |
            %       |---------|
            %         |
            %         | 出

            S1= pi.*(0.106)^2./4;
            S2= pi.*(0.106)^2./4;

            A21(g) = cos(k.*l1(g));
            B21(j,g) = 1i.*(a./Sv(j)).*sin(k.*l1(g));
            C21(j,g) = 1i.*(Sv(j)./a).*sin(k.*l1(g));
            D21(g) = cos(k.*l1(g));
            A22 = 1;
            B22 = 0;
            C22(j,g) = 1i.*(Sv(j)./a).*tan(k.*(Lv(j)-l1(g)));
            D22 = 1;
            M2{j,g} = [A21(g),B21(j,g);C21(j,g),D21(g)] * [A22,B22;C22(j,g),D22];
            % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));

            KESEI22(j,g) = 1./(((S1./S2)^(1/2).*0.5.*abs(M2{j,g}(1,1) + M2{j,g}(1,2).*(S2./a) + M2{j,g}(2,1).*(a./S1) + M2{j,g}(2,2).*(S2./S1)))^2);
            maxLv1 = Lv(j) - Dpipe;
            if l1(g) > maxLv1
                KESEI22(j,g) = nan;
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
    zlabel('透射系数','FontSize',paperFontSize(),'fontName',paperFontName());
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
    zlabel('透射系数','FontSize',paperFontSize(),'fontName',paperFontName());
    box on;
end