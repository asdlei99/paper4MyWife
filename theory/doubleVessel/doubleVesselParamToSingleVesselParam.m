function paramT = doubleVesselParamToSingleVesselParam(param,varargin)
% 双罐参数转为等体积单罐参数
%              __________         __________
%             |          |       |          |
%  -----------|          |-------|          |-------------
%             |__________|       |__________|  
%  直径 Dpipe       Dv1    Dpipe       Dv2          Dpipe
%   
    mode = 'd';
	Lv = param.LV1;
    Dv = param.DV1;
    pp = varargin;
    while length(pp)>=2
		prop =pp{1};
		val=pp{2};
		pp=pp(3:end);
		switch lower(prop)
			case 'lv'%指定缓冲罐的长度
                mode = 'Lv';
				Lv = val;
			case 'r'%指定缓冲罐为等长径比
                mode = 'r';
				r = val;
            case 'd'
                mode = 'd';
                Dv = val;
			otherwise
				error('错误属性%s',prop);
		end
    end
    V = calcV(param.DV1,param.LV1) + calcV(param.DV2,param.LV2);
    if strcmpi(mode,'Lv')
        paramT.Lv = Lv;
        paramT.Dv = (4 * V / pi).^0.5 / paramT.Lv;
    elseif strcmpi(mode,'r')
        [paramT.Dv,paramT.Lv] = calcDLFixR(r,V);
    elseif strcmpi(mode,'d')
        paramT.Dv = Dv;
        paramT.Lv = (4 * V) / (pi * Dv ^ 2);
    end
	
	paramT.isOpening = param.isOpening;%管道闭口%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密??
	paramT.rpm = param.rpm;
	paramT.outDensity = param.outDensity;
	paramT.Fs = param.Fs;
	paramT.acousticVelocity = param.acousticVelocity;%声速（m/s）
	paramT.isDamping = param.isDamping;
	paramT.L1 = param.L1;%(m)
	paramT.L2 = param.L3;
	paramT.L = paramT.L1+paramT.L2;
	paramT.l = 0.01;%(m)缓冲罐的连接管长
	paramT.sectionL1 = param.sectionL1;%linspace(0,param.L1,14);
	paramT.sectionL2 = param.sectionL3;%linspace(0,param.L2,14);
	paramT.Dpipe = param.Dpipe;%管道直径（m
	paramT.X = [paramT.sectionL1, paramT.sectionL1(end) + 2*paramT.l + paramT.Lv + paramT.sectionL2];
	paramT.lv1 = 0.318;
	paramT.lv2 = 0.318;
	paramT.coeffFriction = param.coeffFriction;
	paramT.meanFlowVelocity = param.meanFlowVelocity;
end

function v = calcV(D,L)
	v = (pi .* D.^2 / 4) .* L;
end

function [D,L] = calcDLFixR(r,v)
	L = ((4 .* v .* r .^ 2) ./ pi) .^ (1/3);
	D = L ./ r;
end