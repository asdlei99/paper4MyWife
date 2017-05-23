function [ an ] = soundAbsorptionCoeff1Microperforate(f,d,t,D,porosityRate,varargin )
%一层孔板的吸声系数
%   f 频率
%   d 穿孔直径
%   t 穿孔厚度（长度）
%   D 距离[m]
%   porosityRate 开孔率
    substace = 'air.mix';
    tempt = 20;%温度 T   Temperature [℃]
    pressure = 101.325;%压力 P   Pressure [kPa]
    density = nan;%Density [kg/m^3]
    viscosity = nan;%Dynamic viscosity [Pa*s]kg/sm
    a = nan;%声速m/s
    pp=varargin;%
    while length(pp)>=2
	    prop = pp{1};
	    val = pp{2};
	    pp=pp(3:end);
	    switch lower(prop)
	        case 'substace' %介质
	            substace = val;
            case 't'
                tempt = val;
            case 'p'
                pressure = val;
            case 'a'
            	a = val;
            case 'd'
            	density = val;
            case 'v'
            	viscosity = val;
            otherwise
                error('unknow input property %s',prop); 
	    end
	end
    if isnan(density)
        density = refpropm('D','T',tempt+273.15,'P',pressure,substace);
    end
    if isnan(viscosity)
        viscosity = refpropm('V','T',tempt+273.15,'P',pressure,substace);
    end
    if isnan(a)
        a = refpropm('A','T',tempt+273.15,'P',pressure,substace);
    end
    w = 2*pi*f;
    an = calcAn(viscosity,density,porosityRate,w,t,a,d,D);
    
end

function k = microperforateConstK(w,d,density,viscosity)
%constK - 穿孔板常数
%
% Syntax: k = microperforateConstK(input)
%
% w 圆频率
% d 穿孔孔径
% density 空气层密度
% viscosity 空气层粘度
    k = d.* ( (w.*density)./(4.*viscosity) ).^0.5;
end

function km = microperforateConstKm(k,d,t)
% km 系数计算，需要先算出k，k可通过microperforateConstK计算
% k 穿孔板常数
% d 穿孔孔径
% t 孔厚度（长度）
	km = 1 + ( (9 + k.^2./2).^-(0.5) ) + (0.85.*(d./t));
end

function wm = microperforateConstWM(w,t,km,a,porosityRate)
% wm 系数计算，需要先算出km，km可通过microperforateConstKm计算
% w 圆频率
% t 孔厚度（长度）
% km 系数km
% a 声速
% porosityRate 开孔率
	wm = (w.*t.*km)./(porosityRate.*a);
end

function kr = microperforateConstKr(k,d,t)
% kr 系数计算，需要先算出k，k可通过microperforateConstK计算
% k 穿孔板常数
% d 穿孔孔径
% t 孔厚度（长度）	
	kr = ((1+(k.^2)./32).^0.5) + ((2^0.5/32).*k.*d./t);
end

function r = microperforateConstR(viscosity,t,kr,porosityRate,density,a,d)
% r 系数计算，需要先算出kr，kr可通过microperforateConstKr计算
% kr 
% viscosity 空气层粘度
% d 穿孔孔径
% t 孔厚度（长度）
% porosityRate 开孔率
% a 声速
r = (32.*viscosity.*t.*kr)./...
	(porosityRate.*density.*a.*d.^2);
end

function an = calcAn(viscosity,density,porosityRate,w,t,a,d,D)
% 吸声系数
% viscosity 空气层粘度[[Pa*s]kg/sm]
% density 空气层密度[kg/m3]
% porosityRate 开孔率
% w 圆频率
% t 孔厚度（长度）	[m]
% d 穿孔孔径[m]
% a 声速[m/s]
% D 距离[m]
	k  = microperforateConstK(w,d,density,viscosity);
	km = microperforateConstKm(k,d,t);
	wm = microperforateConstWM(w,t,km,a,porosityRate);
	kr = microperforateConstKr(k,d,t);
	r  = microperforateConstR(viscosity,t,kr,porosityRate,density,a,d);
	an = (4.*r)./...
		((1+r).^2+(wm-cot(w.*D./a)).^2);
end