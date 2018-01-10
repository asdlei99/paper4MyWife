function M = vesselHaveInnerPipeInBiasTransferMatrix(Lv1,Lv2,l,Dv,Dpipe ...
    ,Lin,Lout,Dinnerpipe,Lbias,varargin)

%������ݹ��ݵ�����
%                 L1
%                     |
%                     |
%           l  Lbias  |          Lv              l    L2  
%              _______|_________________________        
%             |    dp1(n1)   |    dp2(n2)       |
%             |        ______|______ lc         |     
%             |        ______ ______ Dinnerpipe |----------
%             |              |                  |
%             |_________Lin__|__Lout____________|       
%                               
%    Dpipe                   Dv                     Dpipe 
%             |   Linner     | 
% Lin �ڲ����ڶγ��� 
% Lout�ڲ�ܳ��ڶγ���
pp=varargin;
k = nan;
oumiga = nan;
f = nan;
a = nan;%����
isDamping = 1;%Ĭ��ʹ������
coeffDamping = nan;
coeffFriction = nan;
meanFlowVelocity = nan;
mach = nan;
notMach = 0;%ǿ�Ʋ�ʹ��mach
DInsert = 0;
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
        case 'isdamping' %�Ƿ��������
            isDamping = val;   
        case 'coeffdamping' %����ϵ������һ������Ϊ2����������һ������ֱ�ܵģ��ڶ���������޵�
            coeffDamping = val;
        case 'damping' %����ϵ������һ������Ϊ2����������һ������ֱ�ܵģ��ڶ���������޵�
            coeffDamping = val;
        case 'friction' %�ܵ�Ħ��ϵ������������ϵ��ʱʹ�ã����������һ������Ϊ2����������һ������ֱ�ܵģ��ڶ���������޵�
            coeffFriction = val;
        case 'coefffriction' %�ܵ�Ħ��ϵ������������ϵ��ʱʹ�ã����������һ������Ϊ2����������һ������ֱ�ܵģ��ڶ���������޵�
            coeffFriction = val;
        case 'meanflowvelocity' %ƽ�����٣���������ϵ��ʱʹ�ã����������һ������Ϊ2����������һ������ֱ�ܵģ��ڶ���������޵�
            meanFlowVelocity = val;
        case 'flowvelocity' %ƽ�����٣���������ϵ��ʱʹ��,ע�������������ֻ��һ����ֵʱ�������ٴ�����޵Ĺܵ������٣������ǻ�����������
            meanFlowVelocity = val;
        case 'mach' %��������������������ʹ�ô�������Ĺ�ʽ����
            mach = val;
        case 'm'
            mach = val;
        case 'notmach'
            notMach = val;
		case 'dinsert'
			DInsert = val;
        otherwise
       		error('��������%s',prop);
    end
end
%����û�û�ж���k��ô��Ҫ�����������м���
if isnan(a)
    error('���ٱ��붨��');
end
if isnan(k)
	if isnan(oumiga)
		if isnan(f)
			error('��û������kʱ��������Ҫ����oumiga,f,acoustic�е�����');
		else
			oumiga = 2.*f.*pi;
		end
	end
	k = oumiga./a;
end
%��������
S = pi .* Dpipe.^2 ./ 4;
Sv = pi .* Dv.^2 ./ 4;%����޽����
Sp = pi*Dinnerpipe.^2./4;%�׹ܹܾ������
Sv_p = Sv-Sp;%ȥ���׹ܵĻ���޽����
Dv_inner = (4*Sv_p/pi).^0.5;%��������ֱ��
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
    error(['��ָ�����٣������ǹܵ����뻺���ʱ�����٣�',...
    '����Ҫָ����������٣�����ʹ��һ������4��Ԫ�ص�����[pipe��vessel,vessel_Inner,InnerPipe]']);
end

if isDamping
    if isnan(coeffDamping)
        if isnan(coeffFriction)
            error('����Ҫ�������ᣬ��û�ж�������ϵ�����趨�塰coeffFriction���ܵ�Ħ��ϵ��');
        end
        if isnan(meanFlowVelocity)
            error('����Ҫ�������ᣬ��û�ж�������ϵ�����趨�塰meanFlowVelocity��ƽ������');
        end
        if length(meanFlowVelocity) < 4
            error('��meanFlowVelocity��ƽ�����ٵĳ��ȹ�С������Ϊ4');
        end
        Dtemp = [Dpipe,Dv,Dv_inner,Dinnerpipe];
        coeffDamping = (4.*coeffFriction.*meanFlowVelocity./Dtemp)./(2.*a);       
    end
    if length(coeffDamping)<4
        %���뿼��4��
        coeffDamping(2) = (4.*coeffFriction.*mfvVessel./Dv)./(2.*a);
        coeffDamping(3) = (4.*coeffFriction.*mfvVessel./Dv_inner)./(2.*a);
        coeffDamping(4) = (4.*coeffFriction.*mfvVessel./Din)./(2.*a);
    end
end
if ~isnan(mach)
    if length(mach) ~= 4 
        mach = meanFlowVelocity./a;%���,mach(1)ֱ��mach��mach(2)�����mach:mach(3)���ڲ�ܵĻ���޵�mach:mach(4)�ڲ�ܵ�mach
    end
else
    mach = meanFlowVelocity./a;%���,mach(1)ֱ��mach��mach(2)�����mach:mach(3)���ڲ�ܵĻ���޵�mach:mach(4)�ڲ�ܵ�mach
end

optMach.notMach = notMach;
optMach.machStraight = mach(1);
optMach.machVessel = mach(2);
optMach.machVesselWithInnerPipe = mach(3);
optMach.machInnerPipe = mach(4);

optDamping.isDamping = isDamping;
if isDamping
    optDamping.coeffDampStraight = coeffDamping(1);
    optDamping.coeffDampVessel = coeffDamping(2);%����޵�����ϵ��
    optDamping.coeffDampVesselWithInnerPipe = coeffDamping(3);%����޵�����ϵ��
    optDamping.coeffDampInnerPipe = coeffDamping(4);%����޵�����ϵ��
    
    optDamping.mfvStraight = meanFlowVelocity(1);
    optDamping.mfvVessel = meanFlowVelocity(2);
    optDamping.mfvVesselWithInnerPipe = meanFlowVelocity(3);
    optDamping.mfvInnerPipe = meanFlowVelocity(4);
else
    optDamping.coeffDampStraight = nan;
    optDamping.coeffDampVessel = nan;%����޵�����ϵ��
    optDamping.coeffDampVesselWithInnerPipe = nan;%����޵�����ϵ��
    optDamping.coeffDampInnerPipe = nan;%����޵�����ϵ��
    
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
Mv = haveInnerPipeInBiasTransferMatrix(a,k,Lv1,Lv2,Dv,Dpipe ...
    ,Lin,Lout,Dinnerpipe,Lbias,DInsert,optDamping,optMach);
M = M2 * Mv * M1;
end
%���ﶼ����ֱ�ܵ�Ч
function M = haveInnerPipeInBiasTransferMatrix(a,k,Lv1,Lv2,Dv,Dpipe ...
    ,Lin,Lout,Dinnerpipe,Lbias,DInsert,optDamping,optMach)


    if ~isstruct(optDamping)
        if isnan(optDamping)
            error('optDamping����Ϊ��');
        end
    end
    if ~isstruct(optMach)
        if isnan(optMach)
            error('optMach����Ϊ��');
        end
    end
    

    if ((Lv1 < 0) || (Lv2 < 0))
        error('���ȳߴ�����');
    end
    Mv1 = IBstraightPipeTransferMatrix(Lbias+Lin-Lv1,'k',k,'d',Dinnerpipe,'dv',Dv,'a',a,...
            'isDamping',optDamping.isDamping,'coeffDamping',optDamping.coeffDampVessel...
            ,'mach',optMach.machVessel,'notmach',optMach.notMach);
    Mv2 = straightPipeTransferMatrix(Lv2-Lout,'k',k,'d',Dv,'a',a,...
                'isDamping',optDamping.isDamping,'coeffDamping',optDamping.coeffDampVessel...
                ,'mach',optMach.machVessel,'notmach',optMach.notMach);
    %���ٱ侶�Ĵ��ݾ���
    Sv = pi.* Dv.^2 ./ 4;
    Spipe = pi.* Dpipe.^2 ./ 4;
    LM = sudEnlargeTransferMatrix(Spipe,Sv,a,'coeffdamping',optDamping.coeffDampStraight,'mach',optMach.machStraight,'notMach',optMach.notMach);
    RM = sudReduceTransferMatrix(Sv,Spipe,a,'coeffdamping',optDamping.coeffDampStraight,'mach',optMach.machStraight,'notMach',optMach.notMach);
    lv4 = Lv1 - Lin;
	innerLM = innerPipeCavityTransferMatrix(Dv,DInsert,lv4,'a',a,'k',k);
    innerRM = innerPipeCavityTransferMatrix(Dv,Dinnerpipe,Lout,'a',a,'k',k);
	lv1 = Lv1 - Lbias;
    innerLMIB = innerPipeCavityTransferMatrix(Dv,Dinnerpipe,lv1,'a',a,'k',k);
   
    %�ڲ�ܵĹܵ����ݾ���
    innerPM = straightPipeTransferMatrix(Lin+Lout,'k',k,'d',Dinnerpipe,'a',a,...
                 'isDamping',optDamping.isDamping,'coeffDamping',optDamping.coeffDampInnerPipe...
                ,'mach',optMach.machInnerPipe,'notmach',optMach.notMach);   
    M = RM * Mv2 * innerRM * innerPM * innerLMIB * Mv1* innerLM  * LM;
end