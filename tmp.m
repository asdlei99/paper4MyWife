
%��ͼ����
isXShowRealLength = 1;
isShowStraightPipe=1;%�Ƿ���ʾֱ��
isShowOnlyVessel=1;%�Ƿ���ʾ���ڼ������
a = 345;
acousticVelocity = 345;%����
isDamping = 1;%�Ƿ��������
coeffFriction = 0.04;%�ܵ�Ħ��ϵ��
SreaightMeanFlowVelocity =20;%14.5;%�ܵ�ƽ������
SreaightCoeffFriction = 0.03;
VesselMeanFlowVelocity =8;%14.5;%�����ƽ������
VesselCoeffFriction = 0.003;
PerfClosedMeanFlowVelocity =9;%14.5;%�����׹�ƽ������
PerfClosedCoeffFriction = 0.04;
PerfOpenMeanFlowVelocity =15;%14.5;%���ڿ׹�ƽ������
PerfOpenCoeffFriction = 0.035;
meanFlowVelocity =14.5;%14.5;%�ܵ�ƽ������
isUseStaightPipe = 1;%�����������ݾ���ķ���
mach = meanFlowVelocity / acousticVelocity;
notMach = 1;
coeffDamping = nan;
calcDatas = {};

L1 = 3.5;%L1(m)
L2 = 6;%L2��m������
Dpipe = 0.106;%�ܵ�ֱ����m��%Ӧ����0.106
vhpicStruct.l = 0.01;
vhpicStruct.Dv = 0.372;%����޵�ֱ����m��
vhpicStruct.Lv = 1.1;%������ܳ� 
vhpicStruct.Lv1 =vhpicStruct.Lv./2;%�����ǻ1�ܳ�
vhpicStruct.Lv2 = vhpicStruct.Lv-vhpicStruct.Lv1;%�����ǻ2�ܳ�
vhpicStruct.lc = 0.005;%�ڲ�ܱں�
vhpicStruct.dp1 = 0.013;%���׾�
vhpicStruct.dp2 = 0.013;%���׾�
vhpicStruct.lp1 = 0.16;%�ڲ����ڶηǿ׹ܿ��׳���
vhpicStruct.lp2 = 0.16;%�ڲ�ܳ��ڶο׹ܿ��׳���
vhpicStruct.n1 = 72;%��ڶο���
vhpicStruct.n2 = 72;%���ڶο���
vhpicStruct.Lin = 0.25;%�ڲ����ڶγ���
vhpicStruct.Lout = 0.25;
%         vhpicStruct.la1 = 0.03;%�׹���ڶο�����ڳ���
vhpicStruct.la2 = 0.06;%�׹�
vhpicStruct.lb1 = 0.06;
%         vhpicStruct.lb2 = 0.03;
vhpicStruct.Din = 0.106/2;
vhpicStruct.la1 = vhpicStruct.Lin - vhpicStruct.lp1-vhpicStruct.la2;%0.25;%�ڲ����ڶγ���
vhpicStruct.lb2 = vhpicStruct.Lout - vhpicStruct.lp2-vhpicStruct.lb1;%0.25;
vhpicStruct.bp1 = vhpicStruct.n1.*(vhpicStruct.dp1)^2./(4.*vhpicStruct.Din.*vhpicStruct.lp1);%������
vhpicStruct.bp2 = vhpicStruct.n2.*(vhpicStruct.dp2)^2./(4.*vhpicStruct.Din.*vhpicStruct.lp2);%������
vhpicStruct.nc1 = 8;%����һȦ��8����
vhpicStruct.nc2 = 8;%����һȦ��8����
vhpicStruct.Cloum1 = vhpicStruct.n1./vhpicStruct.nc1;%����һ�˹̶����׳��ȵĿ׹����ܿ�����Ȧ��
vhpicStruct.Cloum2 = vhpicStruct.n2./vhpicStruct.nc2;
vhpicStruct.s1 = ((vhpicStruct.lp1./vhpicStruct.Cloum1)-vhpicStruct.dp1)./2;%����������֮������Ĭ�ϵȼ��
vhpicStruct.s2 = ((vhpicStruct.lp2./vhpicStruct.Cloum2)-vhpicStruct.dp2)./2;
vhpicStruct.sc1 = (pi.*vhpicStruct.Din - vhpicStruct.nc1.*vhpicStruct.dp1)./vhpicStruct.nc1;%һ�ܿ��ף����ڿ׼��
vhpicStruct.sc2 = (pi.*vhpicStruct.Din - vhpicStruct.nc2.*vhpicStruct.dp2)./vhpicStruct.nc2;
l = vhpicStruct.lp1;
vhpicStruct.xSection1 = [0,ones(1,1).*(l/(1))];
l = vhpicStruct.lp2;
vhpicStruct.xSection2 = [0,ones(1,1).*(l/(1))];
sectionL1 = 0:0.25:L1;%[2.5,3.5];%0:0.25:L1;
sectionL2 = 0:0.25:L2;%[5.87,6.37,6.87��7.37,7.87,8.37,8.87,9.37,9.87,10.37]-L1-vhpicStruct.Lv1-vhpicStruct.Lv2;%0:0.25:L2;
vhpicStruct.lv1 = vhpicStruct.Lv./2-(0.150+0.168);%vhpicStruct.Lv./2-0.232;%�ڲ�ܳ���ƫ�ùܣ�ƫ�ù�la=�����ܳ�-�޷�ͷ��Ե��ƫ�ù����ľ�
vhpicStruct.lv2 = 0;%���ڲ�ƫ��
vhpicStruct.lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
vhpicStruct.lv4 = vhpicStruct.Lv./2-vhpicStruct.Lin;
vhpicStruct.Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
vhpicStruct.Dex = vhpicStruct.Din;

holepipeLength1 = vhpicStruct.Lin - vhpicStruct.la1 - vhpicStruct.la2;
hl1 = sum(vhpicStruct.xSection1);
if(~cmpfloat(holepipeLength1,hl1))
    error('�׹ܲ������ô���holepipeLength1=%.8f,hl1=%.8f;Lin:%g,la1:%g,la2:%g,sum(xSection1):%g,dp:%g'...
        ,holepipeLength1,hl1...
        ,vhpicStruct.Lin,vhpicStruct.la1,vhpicStruct.la2...
        ,sum(vhpicStruct.xSection1),vhpicStruct.dp);
end



syms f

%��ĩ�˹ܵ�
    matrix_L2 = straightPipeTransferMatrix(L2,'f',f,'a',a,'D',Dpipe...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'m',mach,'notmach',notMach);
    matrix_Mv = vesselIBHaveInnerPerfBothClosedCompTransferMatrix(Dpipe,vhpicStruct.Dv,vhpicStruct.l,vhpicStruct.Lv1,vhpicStruct.Lv2...
        ,vhpicStruct.lc,vhpicStruct.dp1,vhpicStruct.dp2,vhpicStruct.lp1,vhpicStruct.lp2,vhpicStruct.n1,vhpicStruct.n2...
        ,vhpicStruct.la1,vhpicStruct.la2,vhpicStruct.lb1,vhpicStruct.lb2,vhpicStruct.Din...
        ,vhpicStruct.Dex,vhpicStruct.Dbias,vhpicStruct.lv1,vhpicStruct.lv4...
        ,vhpicStruct.xSection1,vhpicStruct.xSection2...
        ,'f',f,'a',a...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'notmach',notMach...
        );
    matrix_L1 = straightPipeTransferMatrix(L1,'f',f,'a',a,'D',Dpipe...
        ,'isDamping',isDamping,'coeffFriction',coeffFriction,'meanFlowVelocity',meanFlowVelocity...
        ,'m',mach,'notmach',notMach);
    matrix_total = matrix_L2 * matrix_Mv * matrix_L1;
    A = matrix_total(1,1);
    B = matrix_total(1,2);
    C = matrix_total(2,1);
    D = matrix_total(2,2);