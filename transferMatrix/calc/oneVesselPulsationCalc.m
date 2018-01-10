function [pressure1,pressure2] = oneVesselPulsationCalc( massFlowE,Frequency,time ...
    ,L1,L2,Lv,l,Dpipe,Dv...
    ,sectionL1,sectionL2,varargin)
%计算管容管容的脉动
% StraightInStraightOut：直进直出
%  长度 L1     l    Lv   l    L2  
%              __________        
%             |          |      
%  -----------|          |----------
%             |__________|       
% 直径 Dpipe       Dv       Dpipe  

%biasInBiasOut：侧进侧出 (侧前进侧后出)
%   Detailed explanation goes here
%           |  L2
%        l  |     Lv    outlet
%   bias2___|_______________
%       |                   |
%       |lv2  V          lv1|  Dv
%       |___________________|
%                    l  |   bias1  
%                       |
%              inlet:   | L1 Dpipe 

%EqualBiasInOut:侧前进侧前出
%   Detailed explanation goes here
%                 |  L1
%              l  |      inlet
%       _________ |__________
%       |                   |
%       |     Lv            |  Dv
%       |___________________|
%              l  |    
%                 |
%        outlet:  | L2 Dpipe (Dbias为插入管的管道直径，取0即可)

% BiasFontInStraightOut 侧前进直出
% Dbias 偏置管内插入缓冲罐的管径，如果偏置管没有内插如缓冲罐，Dbias为0
%   Detailed explanation goes here
%   inlet   |  L1
%        l  |     Lv    
%   bias2___|_______________
%       |                   |  Dpipe
%       |lv1  V          lv2|———— L2  
%       |___________________| outlet
%           Dv              l  

% straightinbiasout 侧前进直出
% Dbias 偏置管内插入缓冲罐的管径，如果偏置管没有内插如缓冲罐，Dbias为0
%   Detailed explanation goes here
%   inlet   |  L2
%        l  |     Lv    
%   bias2___|_______________
%       |                   |  Dpipe
%       |lv2  V          lv1|———— L1  
%       |___________________| outlet
%           Dv              l  


%BiasFrontInBiasFrontOut:侧前进侧前出
%   Detailed explanation goes here
%           |  L1
%      lv1  |      inlet
%       ___ |_______________
%       |                   |
%       |     Lv            |  Dv
%       |___________________|
%           |    
%           |
%  outlet:  | L2 Dpipe (Dbias为插入管的管道直径，取0即可)

% massFlowE经过傅里叶变换后的质量流量,仅仅是fft，不进行幅值修正
% Frequency 流量对应的频率，此长度是对应massFlowE的一半
% L 管长
% sectionL 管道脉动分段，最大值不能超过L
%  opt 附属设置，包括阻尼等
pp=varargin;
k = nan;
oumiga = nan;
a = 345;%声速
% S = nan;
% Sv = nan;

vtype = 'StraightInStraightOut';%默认直进直出
isDamping = 1;
coeffDamping = nan;
coeffFriction = nan;
meanFlowVelocity = nan;
isUseStaightPipe = 1;%使用直管理论代替缓冲罐，那么缓冲罐时相当于三个直管拼接
mach = nan;
notMach = 0;%强制不使用mach
isOpening = 0;

if 1 == size(pp,2)
%如果多态参数只有一个，说明是个结构体
    st = pp{1};
    if ~isstruct(st)
        error('参数varargin需要一个makeCommonTransferMatrixInputStruct产生的结构体');
    end
    k = st.k;
    oumiga = st.oumiga;
    a = st.a;
    isDamping = st.isDamping;
    coeffDamping = st.coeffDamping;
    coeffFriction = st.coeffFriction;
    meanFlowVelocity = st.meanFlowVelocity;
    notMach = st.notMach;
    isOpening = st.isOpening;
    mach = st.mach;
    vtype = st.vtype;
    if ~(strcmpi(vtype,'StraightInStraightOut') || strcmpi(vtype,'EqualBiasInOut'))
        lv1 = st.lv1;
        if strcmpi(vtype,'biasinbiasout')   
            lv2 = st.lv2;
        end
    end
else
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'vtype'
                vtype = val;
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
            case 'isusestaightpipe'
                isUseStaightPipe = val;%使用直管理论替代
            case 'usestaightpipe'
                isUseStaightPipe = val;
            case 'm'
                mach = val;
            case 'notmach' %强制用马赫数计算设定
                notMach = val;
            case 'isopening'%管道末端是否为无反射端(开口)，如果为0，就是为闭口，无流量端
                isOpening = val;
            case 'lv1'
                lv1 = val;
            case 'lv2'
                lv2 = val;
            otherwise
                error('参数错误%s',prop);
        end
    end
end
%如果用户没有定义k那么需要根据其他进行计算
% S = (pi.*Dpipe^2)./4;
% Sv1 = (pi.*Dv.^2)./4;
% Sv2 = (pi.*Dv2.^2)./4;
if isnan(a)
    error('声速必须定义');
end

count = 1;
pressureE1 = [];



for i = 1:length(Frequency)
    f = Frequency(i);

    matrix_2{count} = straightPipeTransferMatrix(L2,'f',f,'a',a,'D',Dpipe...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'m',mach,'notmach',notMach);

    switch lower(vtype)
    case 'straightinstraightout'
        matrix_Mv{count} = vesselTransferMatrix(Lv,l,'f',f,'a',a,'D',Dpipe,'Dv',Dv...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'isUseStaightPipe',isUseStaightPipe,'m',mach,'notmach',notMach);
    case 'biasinbiasout'
        matrix_Mv{count} = vesselBiasTransferMatrix(Lv,l,lv1,lv2,0 ...
        ,'a',a,'d',Dpipe,'dv',Dv,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity,'f',f ...
        ,'isUseStaightPipe',isUseStaightPipe,'m',mach,'notmach',notMach);
    case 'equalbiasinout'
        lv1 = Lv/2;
        lv2 = Lv/2;
        matrix_Mv{count} = vesselBiasTransferMatrix(Lv,l,lv1,lv2,0 ...
        ,'a',a,'d',Dpipe,'dv',Dv,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity,'f',f ...
        ,'isUseStaightPipe',isUseStaightPipe,'m',mach,'notmach',notMach);
    case 'biasfontinstraightout'
        matrix_Mv{count} = vesselBiasStraightTransferMatrix(Lv,l,lv1,0 ...
        ,'a',a,'d',Dpipe,'dv',Dv,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity,'f',f ...
        ,'isUseStaightPipe',isUseStaightPipe,'m',mach,'notmach',notMach);
    case 'straightinbiasout'
        matrix_Mv{count} = vesselStraightFrontBiasTransferMatrix(Lv,l,lv1,0 ...
        ,'a',a,'d',Dpipe,'dv',Dv,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity,'f',f ...
        ,'isUseStaightPipe',isUseStaightPipe,'m',mach,'notmach',notMach);
    case 'biasfrontinbiasfrontout'
        matrix_Mv{count} = vesselBiasFrontInBiasFrontOutTransferMatrix(Lv,l,lv1,0 ...
            ,'a',a,'d',Dpipe,'dv',Dv,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity,'f',f ...
        ,'isUseStaightPipe',isUseStaightPipe,'m',mach,'notmach',notMach);
    end
    
    matrix_1{count} = straightPipeTransferMatrix(L1,'f',f,'a',a,'D',Dpipe...
    ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
    ,'m',mach,'notmach',notMach);

    matrix_total = matrix_2{count}*matrix_Mv{count}*matrix_1{count};

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
%% 根据传递矩阵计算初始点脉动压力
%% 根据初始点脉动压力推演其余点脉动压力

count = 1;
pressure1 = [];
if ~isempty(sectionL1)
    for len = sectionL1
        count2 = 1;
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
            matrix_Xl2_total = matrix_lx2  * matrix_Mv{count2} * matrix_1{count2};
            pressureEi(count2) = matrix_Xl2_total(1,1)*pressureE1(count2) + matrix_Xl2_total(1,2)*massFlowE(count2);
            count2 = count2 + 1;
        end
        pressure2(:,count) = changToWave(pressureEi,Frequency,time);
        count = count + 1;
    end
end


end

