function [pressure1,pressure2] = innerPipeVesselInBiasPulsationCalc(massFlowE,Frequency,time ...
    ,L1,L2,Dpipe,Dv,Lin,Lout,Dinnerpipe,Lv1,Lv2,l,Lbias...
     ,sectionL1,sectionL2,varargin)
%计算管容管容的脉动

%                 L1
%                     |
%                     |
%           l   Lbias |          Lv              l    L2  
%              _______|_________________________        
%             |    dp1(n1)   |    dp2(n2)       |
%             |        ______|______ lc         |     
%             |        ______ ______ Dinnerpipe |----------
%             |              |                  |
%             |_________Lin__|__Lout____________|       
%                               
%    Dpipe                   Dv                     Dpipe 
%             |   Lv1     |         Lv2
% Lin 内插管入口段长度 
% Lout内插管出口段长度
pp=varargin;
k = nan;
oumiga = nan;
a = 345;%声速
isDamping = 1;
coeffDamping = nan;
coeffFriction = nan;
meanFlowVelocity = nan;
mach = nan;
notMach = 0;%强制不使用mach
isOpening = 1;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'sv' %h缓冲罐截面
            Sv = val;
        case 'dv' %h缓冲罐截面
             Dvessel = val;
        case 'a' %声速
            a = val; 
        case 'acousticvelocity' %声速
            a = val;
        case 'acoustic' %声速
            a = val;
        case 'isdamping' %是否包含阻尼
            isDamping = val;   
        case 'friction' %管道摩擦系数，计算阻尼系数时使用
            coeffFriction = val;
        case 'coefffriction' %管道摩擦系数，计算阻尼系数时使用
            coeffFriction = val;
        case 'meanflowvelocity' %平均流速，计算阻尼系数时使用
            meanFlowVelocity = val;
        case 'flowvelocity' %平均流速，计算阻尼系数时使用
            meanFlowVelocity = val;
        case 'mach' %马赫数，加入马赫数将会使用带马赫数的公式计算
            mach = val;
        case 'coeffdamping'
            coeffDamping = val;
        case 'm'
            mach = val;
        case 'notmach' %强制用马赫数计算设定
            notMach = val;
        case 'k' %波数
        	k = val;
        case 'oumiga' %圆频率
        	oumiga = val;
        case 'isopening' %管道末端是否为无反射端(开口)，如果为0，就是为闭口，无流量端
            isOpening = val;
        otherwise
            error('参数错误%s',prop);
    end
end
if isnan(a)
    error('声速必须定义');
end

% Lv2 = Lv - Lv1;
count = 1;
pressureE1 = [];
for i = 1:length(Frequency)
    f = Frequency(i);
    %最末端管道
    matrix_L2{count} = straightPipeTransferMatrix(L2,'f',f,'a',a,'D',Dpipe...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'m',mach,'notmach',notMach,'coeffDamping',coeffDamping,'k',k,'oumiga',oumiga);
    matrix_Mv{count} = vesselHaveInnerPipeInBiasTransferMatrix(Lv1,Lv2,l,Dv,Dpipe...
        ,Lin,Lout,Dinnerpipe,Lbias...
        ,'f',f,'a',a,'k',k,'oumiga',oumiga...
        ,'coeffDamping',coeffDamping,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'notmach',notMach...
        );
    matrix_L1{count} = straightPipeTransferMatrix(L1,'f',f,'a',a,'D',Dpipe...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'m',mach,'notmach',notMach,'coeffDamping',coeffDamping,'k',k,'oumiga',oumiga);
    matrix_total = matrix_L2{count} * matrix_Mv{count} * matrix_L1{count};
    A = matrix_total(1,1);
    B = matrix_total(1,2);
    C = matrix_total(2,1);
    D = matrix_total(2,2);
    if(isOpening)
        pressureE1(count) = ((-B/A)*massFlowE(count));
    else
        pressureE1(count) = ((-D/C)*massFlowE(count));
    end
    count = count + 1;
end

count = 1;
pressure1 = [];
if ~isempty(sectionL1)
    for len = sectionL1
        count2 = 1;
        pTemp = [];
        pressureEi = [];
        for i = 1:length(Frequency)
            f = Frequency(i);
            matrix_lx1 = straightPipeTransferMatrix(len,'f',f,'a',a,'D',Dpipe...
            ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
            ,'m',mach,'notmach',notMach);
            pressureEi(count2) = matrix_lx1(1,1)*pressureE1(count2) + matrix_lx1(1,2)*massFlowE(count2);
            count2 = count2 + 1;
        end       
        pressure1(:,count) = changToWave(pressureEi,Frequency,time);
        count = count + 1;
    end
end

count = 1;
pressure2 = [];
if ~isempty(sectionL2)
    for len = sectionL2
        count2 = 1;
        pressureEi = [];
        for i = 1:length(Frequency)
            f = Frequency(i);
            matrix_lx2 = straightPipeTransferMatrix(len,'f',f,'a',a,'D',Dpipe...
            ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
            ,'m',mach,'notmach',notMach);
            matrix_Xl2_total = matrix_lx2  * matrix_Mv{count2} * matrix_L1{count2};
        
            pressureEi(count2) = matrix_Xl2_total(1,1)*pressureE1(count2) + matrix_Xl2_total(1,2)*massFlowE(count2);
            count2 = count2 + 1;
        end
        pressure2(:,count) = changToWave(pressureEi,Frequency,time);
        count = count + 1;
    end
end

end