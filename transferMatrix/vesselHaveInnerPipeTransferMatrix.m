function M = vesselHaveInnerPipeTransferMatrix(Lv1,Lv2,l,Dv,Dpipe ...
    ,Lin,Lout,Din,varargin)

%计算管容管容的脉动
%  长度 L1     l    Lv      l    L2  
%              ______________        
%             |     _|_  lout|      
%  -----------| lin _ _Din   |----------
%             |______|_______|       
% 直径 Dpipe       Dv       Dpipe 
%             |Linner| 
pp=varargin;
k = nan;
oumiga = nan;
f = nan;
a = nan;%声速
isDamping = 1;%默认使用阻尼
coeffDamping = nan;
coeffFriction = nan;
meanFlowVelocity = nan;
mach = nan;
notMach = 0;%强制不使用mach
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);

    switch lower(prop)
        case 'k'
        	k = val;
        case 'oumiga'
        	oumiga = val;
        case 'f'
        	f = val;
        case 'a'
        	a = val;
        case 'acousticvelocity'
        	a = val;
        case 'acoustic'
        	a = val;
        case 'isdamping' %是否包含阻尼
            isDamping = val;   
        case 'coeffdamping' %阻尼系数，是一个长度为2的向量，第一个代表直管的，第二个代表缓冲罐的
            coeffDamping = val;
        case 'damping' %阻尼系数，是一个长度为2的向量，第一个代表直管的，第二个代表缓冲罐的
            coeffDamping = val;
        case 'friction' %管道摩擦系数，计算阻尼系数时使用，如果输入是一个长度为2的向量，第一个代表直管的，第二个代表缓冲罐的
            coeffFriction = val;
        case 'coefffriction' %管道摩擦系数，计算阻尼系数时使用，如果输入是一个长度为2的向量，第一个代表直管的，第二个代表缓冲罐的
            coeffFriction = val;
        case 'meanflowvelocity' %平均流速，计算阻尼系数时使用，如果输入是一个长度为2的向量，第一个代表直管的，第二个代表缓冲罐的
            meanFlowVelocity = val;
        case 'flowvelocity' %平均流速，计算阻尼系数时使用,注意如果输入流速只有一个数值时，此流速代表缓冲罐的管道的流速，而不是缓冲罐里的流速
            meanFlowVelocity = val;
        case 'mach' %马赫数，加入马赫数将会使用带马赫数的公式计算
            mach = val;
        case 'm'
            mach = val;
        case 'notmach'
            notMach = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
%如果用户没有定义k那么需要根据其他进行计算
if isnan(a)
    error('声速必须定义');
end
if isnan(k)
	if isnan(oumiga)
		if isnan(f)
			error('在没有输入k时，至少需要定义oumiga,f,acoustic中的两个');
		else
			oumiga = 2.*f.*pi;
		end
	end
	k = oumiga./a;
end
%流速修正
S = pi .* Dpipe.^2 ./ 4;
Sv = pi .* Dv.^2 ./ 4;%缓冲罐截面积
Sp = pi*Din.^2./4;%孔管管径截面积
Sv_p = Sv-Sp;%去除孔管的缓冲罐截面积
Dv_inner = (4*Sv_p/pi).^0.5;%计算名义直径
mfvStraight = nan;
mfvVessel = nan;
mfvInnerPipe = nan;
mfvVessel_Inner = nan;
if ~isnan(meanFlowVelocity)
    if 1 == length(meanFlowVelocity)
        mfvStraight = meanFlowVelocity;
        mfvVessel = meanFlowVelocity*S/Sv;
        mfvVessel_Inner = meanFlowVelocity*S/Sv_p;
        mfvInnerPipe = meanFlowVelocity*S/Sp;
        meanFlowVelocity = [meanFlowVelocity,mfvVessel,mfvVessel_Inner,mfvInnerPipe];
    elseif 2 == length(meanFlowVelocity)
        mfvStraight = meanFlowVelocity(1);
        mfvVessel = meanFlowVelocity(2);
        mfvVessel_Inner = meanFlowVelocity*S/Sv_p;
        mfvInnerPipe = meanFlowVelocity*S/Sp;
        meanFlowVelocity = [meanFlowVelocity,mfvVessel_Inner,mfvInnerPipe];
    elseif 3 == length(meanFlowVelocity)
        mfvStraight = meanFlowVelocity(1);
        mfvVessel = meanFlowVelocity(2);
        mfvVessel_Inner = meanFlowVelocity(3);
        mfvInnerPipe = meanFlowVelocity*S/Sp;
        mfvInnerPipe = [meanFlowVelocity,mfvInnerPipe];
    elseif 4 == length(meanFlowVelocity)
        mfvStraight = meanFlowVelocity(1);
        mfvVessel = meanFlowVelocity(2);
        mfvVessel_Inner = meanFlowVelocity(3);
        mfvInnerPipe = meanFlowVelocity(4);
    end
else 
    error(['需指定流速，流速是管道进入缓冲罐时的流速，',...
    '若需要指定缓冲罐流速，可以使用一个含有4个元素的向量[pipe，vessel,vessel_Inner,InnerPipe]']);
end

if isDamping
    if isnan(coeffDamping)
        if isnan(coeffFriction)
            error('若需要计算阻尼，且没有定义阻尼系数，需定义“coeffFriction”管道摩擦系数');
        end
        if isnan(meanFlowVelocity)
            error('若需要计算阻尼，且没有定义阻尼系数，需定义“meanFlowVelocity”平均流速');
        end
        if length(meanFlowVelocity) < 4
            error('“meanFlowVelocity”平均流速的长度过小，必须为4');
        end
        Dtemp = [Dpipe,Dv,Dv_inner,Din];
        coeffDamping = (4.*coeffFriction.*meanFlowVelocity./Dtemp)./(2.*a);       
    end
    if length(coeffDamping)<4
        %必须考虑4个
        coeffDamping(2) = (4.*coeffFriction.*mfvVessel./Dv)./(2.*a);
        coeffDamping(3) = (4.*coeffFriction.*mfvVessel./Dv_inner)./(2.*a);
        coeffDamping(4) = (4.*coeffFriction.*mfvVessel./Din)./(2.*a);
    end
end
if ~isnan(mach)
    if length(mach) ~= 4 
        mach = meanFlowVelocity./a;%马赫,mach(1)直管mach，mach(2)缓冲罐mach:mach(3)带内插管的缓冲罐的mach:mach(4)内插管的mach
    end
else
    mach = meanFlowVelocity./a;%马赫,mach(1)直管mach，mach(2)缓冲罐mach:mach(3)带内插管的缓冲罐的mach:mach(4)内插管的mach
end

optMach.notMach = notMach;
optMach.machStraight = mach(1);
optMach.machVessel = mach(2);
optMach.machVesselWithInnerPipe = mach(3);
optMach.machInnerPipe = mach(4);

optDamping.isDamping = isDamping;
if isDamping
    optDamping.coeffDampStraight = coeffDamping(1);
    optDamping.coeffDampVessel = coeffDamping(2);%缓冲罐的阻尼系数
    optDamping.coeffDampVesselWithInnerPipe = coeffDamping(3);%缓冲罐的阻尼系数
    optDamping.coeffDampInnerPipe = coeffDamping(4);%缓冲罐的阻尼系数
    
    optDamping.mfvStraight = meanFlowVelocity(1);
    optDamping.mfvVessel = meanFlowVelocity(2);
    optDamping.mfvVesselWithInnerPipe = meanFlowVelocity(3);
    optDamping.mfvInnerPipe = meanFlowVelocity(4);
else
    optDamping.coeffDampStraight = nan;
    optDamping.coeffDampVessel = nan;%缓冲罐的阻尼系数
    optDamping.coeffDampVesselWithInnerPipe = nan;%缓冲罐的阻尼系数
    optDamping.coeffDampInnerPipe = nan;%缓冲罐的阻尼系数
    
    optDamping.mfvStraight = mfvStraight;
    optDamping.mfvVessel = mfvVessel;
    optDamping.mfvVesselWithInnerPipe = mfvVessel_Inner;
    optDamping.mfvInnerPipe = mfvInnerPipe;
end




M1 = straightPipeTransferMatrix(l,'k',k,'d',Dpipe,'a',a...
      ,'isDamping',isDamping,'coeffDamping',coeffDamping(1) ...
        ,'mach',optMach.machStraight,'notmach',optMach.notMach);
M2 = straightPipeTransferMatrix(l,'k',k,'d',Dpipe,'a',a...
      ,'isDamping',isDamping,'coeffDamping',coeffDamping(1) ...
        ,'mach',optMach.machStraight,'notmach',optMach.notMach);
Mv = haveInnerPipeTransferMatrix(a,k,Lv1,Lv2,Dv,Dpipe ...
    ,Lin,Lout,Din,optDamping,optMach);
M = M2 * Mv * M1;
end
%这里都是用直管等效
function M = haveInnerPipeTransferMatrix(a,k,Lv1,Lv2,Dv,Dpipe ...
    ,Lin,Lout,Din,optDamping,optMach)


    if ~isstruct(optDamping)
        if isnan(optDamping)
            error('optDamping不能为空');
        end
    end
    if ~isstruct(optMach)
        if isnan(optMach)
            error('optMach不能为空');
        end
    end
    

    if ((Lv1 < 0) || (Lv2 < 0))
        error('长度尺寸有误');
    end
    Mv1 = straightPipeTransferMatrix(Lv1-Lin,'k',k,'d',Dv,'a',a,...
            'isDamping',optDamping.isDamping,'coeffDamping',optDamping.coeffDampVessel...
            ,'mach',optMach.machVessel,'notmach',optMach.notMach);
    Mv2 = straightPipeTransferMatrix(Lv2-Lout,'k',k,'d',Dv,'a',a,...
                'isDamping',optDamping.isDamping,'coeffDamping',optDamping.coeffDampVessel...
                ,'mach',optMach.machVessel,'notmach',optMach.notMach);
    %急速变径的传递矩阵
    Sv = pi.* Dv.^2 ./ 4;
    Spipe = pi.* Dpipe.^2 ./ 4;
    LM = sudEnlargeTransferMatrix(Spipe,Sv,a,'coeffdamping',optDamping.coeffDampStraight,'mach',optMach.machStraight,'notMach',optMach.notMach);
    RM = sudReduceTransferMatrix(Sv,Spipe,a,'coeffdamping',optDamping.coeffDampStraight,'mach',optMach.machStraight,'notMach',optMach.notMach);
    innerLM = innerPipeCavityTransferMatrix(Dv,Din,Lin,'a',a,'k',k);
    innerRM = innerPipeCavityTransferMatrix(Dv,Din,Lout,'a',a,'k',k);
   
    %内插管的管道传递矩阵
    innerPM = straightPipeTransferMatrix(Lin+Lout,'k',k,'d',Din,'a',a,...
                 'isDamping',optDamping.isDamping,'coeffDamping',optDamping.coeffDampInnerPipe...
                ,'mach',optMach.machInnerPipe,'notmach',optMach.notMach);   
    M = RM * Mv2 * innerRM * innerPM * innerLM * Mv1 * LM;
end