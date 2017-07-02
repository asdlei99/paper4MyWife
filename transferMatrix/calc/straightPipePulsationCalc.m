function pressure = straightPipePulsationCalc( massFlowE,Frequency,time,L...
    ,sectionL,varargin)
%计算直管气流脉动
% massFlowE经过傅里叶变换后的质量流量,仅仅是fft，不进行幅值修正
% Frequency 流量对应的频率，此长度是对应massFlowE的一半
% L 管长
% sectionL 管道脉动分段，最大值不能超过L
%  opt 附属设置，包括阻尼等
    pp=varargin;
    dynViscosity = nan;
    density = nan;
    calcWay2 = 0;
    k = nan;
    oumiga = nan;
    f = nan;
    a = nan;%声速
    S = nan;
    Dpipe = nan;
    isDamping = 0;
    coeffFriction = nan;
    meanFlowVelocity = nan;
    mach = nan;
    notMach = 0;%强制不使用mach
    isOpening = 1;
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
        Dpipe = st.D;
    else
        while length(pp)>=2
            prop =pp{1};
            val=pp{2};
            pp=pp(3:end);
            switch lower(prop)
                case 's' %截面
                    S = val;
                case 'd' %管道直径
                    Dpipe = val;
                    S = (pi.*Dpipe^2)./4;
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
                case 'm'
                    mach = val;
                case 'notmach' %强制用马赫数计算设定
                    notMach = val;
                case 'isopening'%管道末端是否为无反射端(开口)，如果为0，就是为闭口，无流量端
                    isOpening = val;
                case 'calcway2'
                    calcWay2 = val;
                case 'dynvis'%动力学粘度pa-s
                    dynViscosity = val;
                case 'dynviscosity'%动力学粘度pa-s
                    dynViscosity = val;
                case 'density'%密度
                    density = val;    
                otherwise
                    error('参数错误%s',prop);
            end
        end
    end



    count = 1;
    pressureE1 = [];
    for i = 1:length(Frequency)
        f = Frequency(i);
        matrix_total = straightPipeTransferMatrix(L,'s',S,'f',f,'a',a,'D',Dpipe...
            ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
            ,'m',mach,'notmach',notMach...
            ,'calcWay2',calcWay2,'density',density,'dynViscosity',dynViscosity);
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
    %% 根据初始点脉动压力推演其余点脉动压力

    count = 1;
    for len = sectionL
        count2 = 1;
        pressureEi = [];
        for i = 1:length(Frequency)
            f = Frequency(i);
            matrixTOther = straightPipeTransferMatrix(len,'s',S,'f',f,'a',a,'D',Dpipe...
            ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
            ,'m',mach,'notmach',notMach...
            ,'calcWay2',calcWay2,'density',density,'dynViscosity',dynViscosity);
            pressureEi(count2) = matrixTOther(1,1)*pressureE1(count2) + matrixTOther(1,2)*massFlowE(count2);
            count2 = count2 + 1;
        end
        pressure(:,count) = changToWave(pressureEi,Frequency,time);
        count = count + 1;
    end
end

