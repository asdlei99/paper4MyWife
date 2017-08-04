function [pressure1,pressure2,pressure3] = doubleVesselElbowPulsationCalc(massFlowE,Frequency,time ...
,L1,L2,L3,Lv1,Lv2,l,Dpipe,Dv1,Dv2,lv3,Dbias,sectionL1,sectionL2,sectionL3,varargin)
%       ���� L1     l    Lv    l    L2   l    Lv
%                   __________            ___________ 
%                  |          |          |           |   
%       -----------|          |----------|           |
%                  |__________|          |__   ______|      
% ֱ��      Dpipe       Dv       Dpipe      | |
%                                           | | L3 
%                                           | |
    %����˫��-�޶�����ͷ
% if 1.5 == L2
% L1,L2,L3,Lv,l,Dpipe,Dv,lv3,Dbias,sectionL1,sectionL2,sectionL3,varargin
% end
pp=varargin;
a = nan;%����


isDamping = 0;
isOpening = 1;
coeffFriction = nan;
meanFlowVelocity = nan;
isUseStaightPipe = 1;%ʹ��ֱ�����۴��滺��ޣ���ô�����ʱ�൱������ֱ��ƴ��
mach = nan;
notMach = 0;%ǿ�Ʋ�ʹ��mach
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'd' %�ܵ�ֱ��
            Dpipe = val;
        case 'a'
        	a = val;
        case 'acousticvelocity'
        	a = val;
        case 'acoustic'
        	a = val;
        case 'isdamping' %�Ƿ��������
            isDamping = val;   
        case 'friction' %�ܵ�Ħ��ϵ������������ϵ��ʱʹ�ã����������һ������Ϊ2����������һ������ֱ�ܵģ��ڶ���������޵�
            coeffFriction = val;
        case 'coefffriction' %�ܵ�Ħ��ϵ������������ϵ��ʱʹ�ã����������һ������Ϊ2����������һ������ֱ�ܵģ��ڶ���������޵�
            coeffFriction = val;
        case 'meanflowvelocity' %ƽ�����٣���������ϵ��ʱʹ�ã����������һ������Ϊ2����������һ������ֱ�ܵģ��ڶ���������޵�
            meanFlowVelocity = val;
        case 'flowvelocity' %ƽ�����٣���������ϵ��ʱʹ��,ע�������������ֻ��һ����ֵʱ�������ٴ�����޵Ĺܵ������٣������ǻ�����������
            meanFlowVelocity = val;
        case 'isusestaightpipe'
            isUseStaightPipe = val;%ʹ��ֱ���������
        case 'usestaightpipe'
            isUseStaightPipe = val;
        case 'mach' %��������������������ʹ�ô�������Ĺ�ʽ����
            mach = val;
        case 'm'
            mach = val;
        case 'isopening'
            isOpening = val;
        case 'notmach'
            notMach = val;
        otherwise
       		error('��������%s',prop);
    end
end
% L1,L2,L3,Lv1,Lv2,l,Dpipe,Dv1,Dv2,lv3,Dbias,sectionL1,sectionL2,sectionL3,varargin



%����û�û�ж���k��ô��Ҫ�����������м���
if isnan(a)
    error('���ٱ��붨��');
end
count = 1;
pressureE1 = [];
for i = 1:length(Frequency)
    f = Frequency(i);
    %��ĩ�˹ܵ�
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