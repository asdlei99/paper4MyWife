%计算传递损失和阻抗系数
%三维图阻抗系数随l1和f变化
clear all;
close all;
a = 345;
Lv = 1.1;
Sv = pi.*(0.372)^2./4;
l1 = 0.005:0.05:Lv;
f0 = 1:50;
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
        KESEI2(j,f) = ((S1./S2)^(1/2).*0.5.*abs(M2{j,f}(1,1) + M2{j,f}(1,2).*(S2./a) + M2{j,f}(2,1).*(a./S1) + M2{j,f}(2,2).*(S2./S1)))^2;

    end

end
[X,Y] = meshgrid(f0,l1);
Z=KESEI2;

figure
paperFigureSet_large(6.5);
subplot(1,2,1);
surf(X,Y,Z);
xlabel('频率(Hz)','FontSize',paperFontSize(),'fontName',paperFontName());
ylabel('l1(m)','FontSize',paperFontSize(),'fontName',paperFontName());
zlabel('阻抗系数','FontSize',paperFontSize(),'fontName',paperFontName());
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
    
    A21(count) = cos(k.*v);
    B21(count) = 1i.*(a./Sv).*sin(k.*v);
    C21(count) = 1i.*(Sv./a).*sin(k.*v);
    D21(count) = cos(k.*v);
    A22 = 1;
    B22 = 0;
    C22(count) = 1i.*(Sv./a).*tan(k.*(Lv-v));
    D22 = 1;
    M2{count} = [A21(count),B21(count);C21(count),D21(count)] * [A22,B22;C22(count),D22];
    % TL2(f) = 20.*log10((S1./S2)^(1/2).*0.5.*abs(M2(1,1) + M2(1,2).*(S2./a) + M2(2,1).*(a./S1) + M2(2,2).*(S2./S1)));
    KESEI21(count) = ((S1./S2)^(1/2).*0.5.*abs(M2{count}(1,1) + M2{count}(1,2).*(S2./a) + M2{count}(2,1).*(a./S1) + M2{count}(2,2).*(S2./S1)))^2;
    count = count+1;
end

subplot(1,2,2);
plot(l1,KESEI21,'-*b');
xlim([0,1.1]);
xlabel('l1(m)','FontSize',paperFontSize(),'fontName',paperFontName());
ylabel('阻抗系数','FontSize',paperFontSize(),'fontName',paperFontName());
set(gca,'Position',[0.632075471698113 0.223214285714286 0.340639398697521 0.663504464285714]);
annotation('textbox',...
    [0.540837398373984 0.88421052631579 0.0363983739837398 0.0631578947368421],...
    'String',{'(b)'},...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'EdgeColor','none');

