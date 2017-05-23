function [ an ] = soundAbsorptionCoeff1Microperforate(f,d,t,D,porosityRate,varargin )
%һ��װ������ϵ��
%   f Ƶ��
%   d ����ֱ��
%   t ���׺�ȣ����ȣ�
%   D ����[m]
%   porosityRate ������
    substace = 'air.mix';
    tempt = 20;%�¶� T   Temperature [��]
    pressure = 101.325;%ѹ�� P   Pressure [kPa]
    density = nan;%Density [kg/m^3]
    viscosity = nan;%Dynamic viscosity [Pa*s]kg/sm
    a = nan;%����m/s
    pp=varargin;%
    while length(pp)>=2
	    prop = pp{1};
	    val = pp{2};
	    pp=pp(3:end);
	    switch lower(prop)
	        case 'substace' %����
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
%constK - ���װ峣��
%
% Syntax: k = microperforateConstK(input)
%
% w ԲƵ��
% d ���׿׾�
% density �������ܶ�
% viscosity ������ճ��
    k = d.* ( (w.*density)./(4.*viscosity) ).^0.5;
end

function km = microperforateConstKm(k,d,t)
% km ϵ�����㣬��Ҫ�����k��k��ͨ��microperforateConstK����
% k ���װ峣��
% d ���׿׾�
% t �׺�ȣ����ȣ�
	km = 1 + ( (9 + k.^2./2).^-(0.5) ) + (0.85.*(d./t));
end

function wm = microperforateConstWM(w,t,km,a,porosityRate)
% wm ϵ�����㣬��Ҫ�����km��km��ͨ��microperforateConstKm����
% w ԲƵ��
% t �׺�ȣ����ȣ�
% km ϵ��km
% a ����
% porosityRate ������
	wm = (w.*t.*km)./(porosityRate.*a);
end

function kr = microperforateConstKr(k,d,t)
% kr ϵ�����㣬��Ҫ�����k��k��ͨ��microperforateConstK����
% k ���װ峣��
% d ���׿׾�
% t �׺�ȣ����ȣ�	
	kr = ((1+(k.^2)./32).^0.5) + ((2^0.5/32).*k.*d./t);
end

function r = microperforateConstR(viscosity,t,kr,porosityRate,density,a,d)
% r ϵ�����㣬��Ҫ�����kr��kr��ͨ��microperforateConstKr����
% kr 
% viscosity ������ճ��
% d ���׿׾�
% t �׺�ȣ����ȣ�
% porosityRate ������
% a ����
r = (32.*viscosity.*t.*kr)./...
	(porosityRate.*density.*a.*d.^2);
end

function an = calcAn(viscosity,density,porosityRate,w,t,a,d,D)
% ����ϵ��
% viscosity ������ճ��[[Pa*s]kg/sm]
% density �������ܶ�[kg/m3]
% porosityRate ������
% w ԲƵ��
% t �׺�ȣ����ȣ�	[m]
% d ���׿׾�[m]
% a ����[m/s]
% D ����[m]
	k  = microperforateConstK(w,d,density,viscosity);
	km = microperforateConstKm(k,d,t);
	wm = microperforateConstWM(w,t,km,a,porosityRate);
	kr = microperforateConstKr(k,d,t);
	r  = microperforateConstR(viscosity,t,kr,porosityRate,density,a,d);
	an = (4.*r)./...
		((1+r).^2+(wm-cot(w.*D./a)).^2);
end