function [pressure1,pressure2] = oneVesselPulsationCalc( massFlowE,Frequency,time ...
    ,L1,L2,Lv,l,Dpipe,Dv...
    ,sectionL1,sectionL2,varargin)
%������ݹ��ݵ�����
% StraightInStraightOut��ֱ��ֱ��
%  ���� L1     l    Lv   l    L2  
%              __________        
%             |          |      
%  -----------|          |----------
%             |__________|       
% ֱ�� Dpipe       Dv       Dpipe  

%biasInBiasOut�������� (��ǰ������)
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

%EqualBiasInOut:��ǰ����ǰ��
%   Detailed explanation goes here
%                 |  L1
%              l  |      inlet
%       _________ |__________
%       |                   |
%       |     Lv            |  Dv
%       |___________________|
%              l  |    
%                 |
%        outlet:  | L2 Dpipe (DbiasΪ����ܵĹܵ�ֱ����ȡ0����)

% BiasFontInStraightOut ��ǰ��ֱ��
% Dbias ƫ�ù��ڲ��뻺��޵Ĺܾ������ƫ�ù�û���ڲ��绺��ޣ�DbiasΪ0
%   Detailed explanation goes here
%   inlet   |  L1
%        l  |     Lv    
%   bias2___|_______________
%       |                   |  Dpipe
%       |lv1  V          lv2|�������� L2  
%       |___________________| outlet
%           Dv              l  

% straightinbiasout ��ǰ��ֱ��
% Dbias ƫ�ù��ڲ��뻺��޵Ĺܾ������ƫ�ù�û���ڲ��绺��ޣ�DbiasΪ0
%   Detailed explanation goes here
%   inlet   |  L2
%        l  |     Lv    
%   bias2___|_______________
%       |                   |  Dpipe
%       |lv2  V          lv1|�������� L1  
%       |___________________| outlet
%           Dv              l  


%BiasFrontInBiasFrontOut:��ǰ����ǰ��
%   Detailed explanation goes here
%           |  L1
%      lv1  |      inlet
%       ___ |_______________
%       |                   |
%       |     Lv            |  Dv
%       |___________________|
%           |    
%           |
%  outlet:  | L2 Dpipe (DbiasΪ����ܵĹܵ�ֱ����ȡ0����)

% massFlowE��������Ҷ�任�����������,������fft�������з�ֵ����
% Frequency ������Ӧ��Ƶ�ʣ��˳����Ƕ�ӦmassFlowE��һ��
% L �ܳ�
% sectionL �ܵ������ֶΣ����ֵ���ܳ���L
%  opt �������ã����������
pp=varargin;
k = nan;
oumiga = nan;
a = 345;%����
% S = nan;
% Sv = nan;

vtype = 'StraightInStraightOut';%Ĭ��ֱ��ֱ��
isDamping = 1;
coeffDamping = nan;
coeffFriction = nan;
meanFlowVelocity = nan;
isUseStaightPipe = 1;%ʹ��ֱ�����۴��滺��ޣ���ô�����ʱ�൱������ֱ��ƴ��
mach = nan;
notMach = 0;%ǿ�Ʋ�ʹ��mach
isOpening = 0;

if 1 == size(pp,2)
%�����̬����ֻ��һ����˵���Ǹ��ṹ��
    st = pp{1};
    if ~isstruct(st)
        error('����varargin��Ҫһ��makeCommonTransferMatrixInputStruct�����Ľṹ��');
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
            case 'a' %����
                a = val; 
            case 'acousticvelocity' %����
                a = val;
            case 'acoustic' %����
                a = val;
            case 'isdamping' %�Ƿ��������
                isDamping = val;   
            case 'friction' %�ܵ�Ħ��ϵ������������ϵ��ʱʹ��
                coeffFriction = val;
            case 'coefffriction' %�ܵ�Ħ��ϵ������������ϵ��ʱʹ��
                coeffFriction = val;
            case 'meanflowvelocity' %ƽ�����٣���������ϵ��ʱʹ��
                meanFlowVelocity = val;
            case 'flowvelocity' %ƽ�����٣���������ϵ��ʱʹ��
                meanFlowVelocity = val;
            case 'mach' %��������������������ʹ�ô�������Ĺ�ʽ����
                mach = val;
            case 'isusestaightpipe'
                isUseStaightPipe = val;%ʹ��ֱ���������
            case 'usestaightpipe'
                isUseStaightPipe = val;
            case 'm'
                mach = val;
            case 'notmach' %ǿ��������������趨
                notMach = val;
            case 'isopening'%�ܵ�ĩ���Ƿ�Ϊ�޷����(����)�����Ϊ0������Ϊ�տڣ���������
                isOpening = val;
            case 'lv1'
                lv1 = val;
            case 'lv2'
                lv2 = val;
            otherwise
                error('��������%s',prop);
        end
    end
end
%����û�û�ж���k��ô��Ҫ�����������м���
% S = (pi.*Dpipe^2)./4;
% Sv1 = (pi.*Dv.^2)./4;
% Sv2 = (pi.*Dv2.^2)./4;
if isnan(a)
    error('���ٱ��붨��');
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
%% ���ݴ��ݾ�������ʼ������ѹ��
%% ���ݳ�ʼ������ѹ���������������ѹ��

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

