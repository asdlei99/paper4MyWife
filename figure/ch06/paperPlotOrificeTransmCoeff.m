clear all;
v = 20.*10e-6;%空气的粘度
p = 1.569;%密度
u = v./p; %空气的动力学粘度
a = 366;%声速
f = 14;%频率
t = 0.003;%孔板厚度
d = [0.01:0.01:0.3];%孔板孔径
D = 0.372;%容器直径
S = pi.*D^2./4;
k = 2.*pi.*f./a;
u0= 15;
L = %孔板前缓冲罐长度
theita = 0;%(1+0.707./sqrt(1-(d.^2./D.^2))).^2 .* ((D.^2./d.^2)-1).^2;

for i=1:length(d)
 r(i) = d(i)./2;
 kesai(i) = (d(i)./D)^2;%穿孔面积占比
R(i) = (p.*a./kesai(i)).*(sqrt(8.*u.*k./(p.*a)).*(1+t./(2.*r(i)))+theita);%声阻
X(i) = (p.*a./kesai(i)).*k.*(t+0.5.*r(i));
ar(i) = (p.*a./(2.*S))^2./((p.*a./(2.*S)+R(i))^2+X(i)^2);%反射系数
at(i) = (R(i)^2+X(i)^2)./((p.*a./(2.*S)+R(i))^2+X(i)^2);%透射系数
end
figure
subplot(1,2,1)
plot(d,ar)
subplot(1,2,2)
plot(d,at)
%%
%%计算内插孔板传递阻抗
clear all;
close all;

v = 20.*10e-6;%空气的粘度
p = 1.569;%密度
u = v./p; %空气的动力学粘度
a = 366;%声速
f = 14;%频率
t = 0.003;%孔板厚度
d = 0.098;%孔板孔径
D = 0.372;%容器直径
S = pi.*D^2./4;
k = 2.*pi.*f./a;
u0= 15;
r = d./2;
theita = 0;
kesai = (d./D)^2;%穿孔面积占比
L=1.1;%罐体总长
L1 = [0.1:0.05:1];%孔板前缓冲罐长度
M1 = -a.^2.*p./(S.*kesai).*(sqrt(8.*u.*k./(p.*a)).*(1+t./(2.*r))+theita);%实数部分
M2 = a.^2.*p./(S.*kesai).*(t+0.5.*r);%虚数部分
%计算孔板入口处阻抗
for i=1:length(L1)
L2(i) = L-L1(i);  
%R = -((1+0.707./sqrt(1-(d.^2./D.^2))).^2 .* ((D.^2./d.^2)-1).^2).*u0./S;%声阻
R = -p.*M1;
X(i) = p.*a./S.*tan(k.*L2(i))-p.*M2;
ar(i) = (p.*a./(2.*S))^2./((p.*a./(2.*S)+R)^2+X(i)^2);%反射系数
at(i) = (R^2+X(i)^2)./((p.*a./(2.*S)+R)^2+X(i)^2);%透射系数
end
figure
subplot(1,2,1)
plot(L1,ar)
subplot(1,2,2)
plot(L1,at)

%计算缓冲罐入口处阻抗
for i=1:length(L1)
    L2(i) = L-L1(i);
    A(i) = M.*cos(k.*L1(i)).*cos(k.*L2(i));
    B(i) = -(a./S).*(sin(k.*L2(i))+cos(k.*L2(i)).*sin(k.*L1(i)));
    C(i) = M.*S./a.*sin(k.*L1(i)).*cos(k.*L2(i))-cos(k.*L2(i)).*cos(k.*L1(i));
    D(i) = sin(k.*L1(i)).*sin(k.*L2(i));
    R(i) = (A(i).*C(i)-B(i).*D(i))./(C(i).^2+D(i).^2);
    X(i) = (B(i).*C(i)+A(i).*D(i))./(C(i).^2+D(i).^2);
%     ar(i) = (p.*a./(2.*S))^2./((p.*a./(2.*S)+R(i))^2+X(i)^2);%反射系数
    at(i) = (R(i)^2+X(i)^2)./((p.*a./(2.*S)+R(i))^2+X(i)^2);%透射系数
    ar(i)
end
figure
subplot(1,2,1)
plot(L1,ar)
subplot(1,2,2)
plot(L1,at)

