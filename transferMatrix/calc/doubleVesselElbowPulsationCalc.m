function [pressure1,pressure2,pressure3] = doubleVesselElbowPulsationCalc(massFlowE,Frequency,time ...
,L1,L2,L3,Lv1,Lv2,l,Dpipe,Dv1,Dv2,lv3,Dbias,sectionL1,sectionL2,sectionL3,varargin)
%       长度 L1     l    Lv    l    L2   l    Lv
%                   __________            ___________ 
%                  |          |          |           |   
%       -----------|          |----------|           |
%                  |__________|          |__   ______|      
% 直径      Dpipe       Dv       Dpipe      | |
%                                           | | L3 
%                                           | |
    %计算双罐-罐二作弯头
% if 1.5 == L2
% L1,L2,L3,Lv,l,Dpipe,Dv,lv3,Dbias,sectionL1,sectionL2,sectionL3,varargin
% end
pp=varargin;
a = nan;%声速


isDamping = 0;
isOpening = 1;
coeffFriction = nan;
meanFlowVelocity = nan;
isUseStaightPipe = 1;%使用直管理论代替缓冲罐，那么缓冲罐时相当于三个直管拼接
mach = nan;
notMach = 0;%强制不使用mach
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'd' %管道直径
            Dpipe = val;
        case 'a'
        	a = val;
        case 'acousticvelocity'
        	a = val;
        case 'acoustic'
        	a = val;
        case 'isdamping' %是否包含阻尼
            isDamping = val;   
        case 'friction' %管道摩擦系数，计算阻尼系数时使用，如果输入是一个长度为2的向量，第一个代表直管的，第二个代表缓冲罐的
            coeffFriction = val;
        case 'coefffriction' %管道摩擦系数，计算阻尼系数时使用，如果输入是一个长度为2的向量，第一个代表直管的，第二个代表缓冲罐的
            coeffFriction = val;
        case 'meanflowvelocity' %平均流速，计算阻尼系数时使用，如果输入是一个长度为2的向量，第一个代表直管的，第二个代表缓冲罐的
            meanFlowVelocity = val;
        case 'flowvelocity' %平均流速，计算阻尼系数时使用,注意如果输入流速只有一个数值时，此流速代表缓冲罐的管道的流速，而不是缓冲罐里的流速
            meanFlowVelocity = val;
        case 'isusestaightpipe'
            isUseStaightPipe = val;%使用直管理论替代
        case 'usestaightpipe'
            isUseStaightPipe = val;
        case 'mach' %马赫数，加入马赫数将会使用带马赫数的公式计算
            mach = val;
        case 'm'
            mach = val;
        case 'isopening'
            isOpening = val;
        case 'notmach'
            notMach = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
% L1,L2,L3,Lv1,Lv2,l,Dpipe,Dv1,Dv2,lv3,Dbias,sectionL1,sectionL2,sectionL3,varargin



%如果用户没有定义k那么需要根据其他进行计算
if isnan(a)
    error('声速必须定义');
end
count = 1;
pressureE1 = [];
for i = 1:length(Frequency)
    f = Frequency(i);
    %最末端管道
    matrix_L3{count} = straightPipeTransferMatrix(L3,'f',f,'a',a,'d',Dpipe...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'m',mach,'notmach',notMach);
    matrix_Mv2{count} = vesselStraightFrontBiasTransferMatrix(Lv2,l,lv3,Dbias ...
        ,'a',a,'d',Dpipe,'dv',Dv2,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity,'f',f ...
        ,'isUseStaightPipe',isUseStaightPipe,'m',mach,'notmach',notMach);
    matrix_L2{count} = straightPipeTransferMatrix(L2,'f',f,'a',a,'d',Dpipe...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'m',mach,'notmach',notMach);
    matrix_Mv1{count} = vesselTransferMatrix(Lv1,l,'f',f,'a',a,'D',Dpipe,'Dv',Dv1...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'isUseStaightPipe',isUseStaightPipe,'m',mach,'notmach',notMach);
    matrix_L1{count} = straightPipeTransferMatrix(L1,'f',f,'a',a,'D',Dpipe...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'m',mach,'notmach',notMach);
%     if 1.5 == L2
%         fprintf('Frequency:%g,massFlowE:%\n',f,massFlowE(count));
%         fprintf('\nmatrix_3:[%g,%g;%g,%g]',matrix_L3{count}(1,1),matrix_L3{count}(1,2),matrix_L3{count}(2,1),matrix_L3{count}(2,2));
%         fprintf('\nmatrix_v2:[%g,%g;%g,%g]',matrix_Mv2{count}(1,1),matrix_Mv2{count}(1,2),matrix_Mv2{count}(2,1),matrix_Mv2{count}(2,2));
%         fprintf('\nmatrix_2:[%g,%g;%g,%g]',matrix_L2{count}(1,1),matrix_L2{count}(1,2),matrix_L2{count}(2,1),matrix_L2{count}(2,2));
%         fprintf('\nmatrix_v1:[%g,%g;%g,%g]',matrix_Mv1{count}(1,1),matrix_Mv1{count}(1,2),matrix_Mv1{count}(2,1),matrix_Mv1{count}(2,2));
%         fprintf('\nmatrix_1:[%g,%g;%g,%g]',matrix_L1{count}(1,1),matrix_L1{count}(1,2),matrix_L1{count}(2,1),matrix_L1{count}(2,2));
%     end
    matrix_total = matrix_L3{count} * matrix_Mv2{count} * matrix_L2{count} * matrix_Mv1{count} * matrix_L1{count};
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
% sectionL1
% sectionL2
% sectionL3
count = 1;
pressure1 = [];
if ~isempty(sectionL1)
    for len = sectionL1
        pressureEi = [];
        for i = 1:length(Frequency)
            f = Frequency(i);
            matrix_lx1 = straightPipeTransferMatrix(len,'f',f,'a',a,'D',Dpipe...
            ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
            ,'m',mach,'notmach',notMach);
            pressureEi(i) = matrix_lx1(1,1)*pressureE1(i) + matrix_lx1(1,2)*massFlowE(i);
        end       
        pressure1(:,count) = changToWave(pressureEi,Frequency,time);
        count = count + 1;
    end
end

count = 1;
pressure2 = [];
if ~isempty(sectionL2)
    for len = sectionL2
        pressureEi = [];
        for i = 1:length(Frequency)
            f = Frequency(i);
            matrix_lx2 = straightPipeTransferMatrix(len,'f',f,'a',a,'D',Dpipe...
            ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
            ,'m',mach,'notmach',notMach);
            matrix_Xl2_total = matrix_lx2  * matrix_Mv1{i} * matrix_L1{i};
        
            pressureEi(i) = matrix_Xl2_total(1,1)*pressureE1(i) + matrix_Xl2_total(1,2)*massFlowE(i);
        end
        pressure2(:,count) = changToWave(pressureEi,Frequency,time);
        count = count + 1;
    end
end

count = 1;
pressure3 = [];
if ~isempty(sectionL3)
    for len = sectionL3
        pressureEi = [];
        for i = 1:length(Frequency)
            f = Frequency(i);
            matrix_lx3 = straightPipeTransferMatrix(len,'f',f,'a',a,'D',Dpipe...
            ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
            ,'m',mach,'notmach',notMach);
            matrix_Xl3_total = matrix_lx3 * matrix_Mv2{i} * matrix_L2{i} * matrix_Mv1{i} * matrix_L1{i};
        
            pressureEi(i) = matrix_Xl3_total(1,1)*pressureE1(i) + matrix_Xl3_total(1,2)*massFlowE(i);
        end       
        pressure3(:,count) = changToWave(pressureEi,Frequency,time);
        count = count + 1;
    end
end
end