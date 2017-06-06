
%绘图参数
isXShowRealLength = 1;
isShowStraightPipe=1;%是否显示直管
isShowOnlyVessel=1;%是否显示无内件缓冲罐
a = 345;
acousticVelocity = 345;%声速
isDamping = 1;%是否计算阻尼
coeffFriction = 0.04;%管道摩察系数
SreaightMeanFlowVelocity =20;%14.5;%管道平均流速
SreaightCoeffFriction = 0.03;
VesselMeanFlowVelocity =8;%14.5;%缓冲罐平均流速
VesselCoeffFriction = 0.003;
PerfClosedMeanFlowVelocity =9;%14.5;%堵死孔管平均流速
PerfClosedCoeffFriction = 0.04;
PerfOpenMeanFlowVelocity =15;%14.5;%开口孔管平均流速
PerfOpenCoeffFriction = 0.035;
meanFlowVelocity =14.5;%14.5;%管道平均流速
isUseStaightPipe = 1;%计算容器传递矩阵的方法
mach = meanFlowVelocity / acousticVelocity;
notMach = 1;
coeffDamping = nan;
calcDatas = {};

L1 = 3.5;%L1(m)
L2 = 6;%L2（m）长度
Dpipe = 0.106;%管道直径（m）%应该是0.106
vhpicStruct.l = 0.01;
vhpicStruct.Dv = 0.372;%缓冲罐的直径（m）
vhpicStruct.Lv = 1.1;%缓冲罐总长 
vhpicStruct.Lv1 =vhpicStruct.Lv./2;%缓冲罐腔1总长
vhpicStruct.Lv2 = vhpicStruct.Lv-vhpicStruct.Lv1;%缓冲罐腔2总长
vhpicStruct.lc = 0.005;%内插管壁厚
vhpicStruct.dp1 = 0.013;%开孔径
vhpicStruct.dp2 = 0.013;%开孔径
vhpicStruct.lp1 = 0.16;%内插管入口段非孔管开孔长度
vhpicStruct.lp2 = 0.16;%内插管出口段孔管开孔长度
vhpicStruct.n1 = 72;%入口段孔数
vhpicStruct.n2 = 72;%出口段孔数
vhpicStruct.Lin = 0.25;%内插管入口段长度
vhpicStruct.Lout = 0.25;
%         vhpicStruct.la1 = 0.03;%孔管入口段靠近入口长度
vhpicStruct.la2 = 0.06;%孔管
vhpicStruct.lb1 = 0.06;
%         vhpicStruct.lb2 = 0.03;
vhpicStruct.Din = 0.106/2;
vhpicStruct.la1 = vhpicStruct.Lin - vhpicStruct.lp1-vhpicStruct.la2;%0.25;%内插管入口段长度
vhpicStruct.lb2 = vhpicStruct.Lout - vhpicStruct.lp2-vhpicStruct.lb1;%0.25;
vhpicStruct.bp1 = vhpicStruct.n1.*(vhpicStruct.dp1)^2./(4.*vhpicStruct.Din.*vhpicStruct.lp1);%开孔率
vhpicStruct.bp2 = vhpicStruct.n2.*(vhpicStruct.dp2)^2./(4.*vhpicStruct.Din.*vhpicStruct.lp2);%开孔率
vhpicStruct.nc1 = 8;%假设一圈有8个孔
vhpicStruct.nc2 = 8;%假设一圈有8个孔
vhpicStruct.Cloum1 = vhpicStruct.n1./vhpicStruct.nc1;%计算一端固定开孔长度的孔管上能开多少圈孔
vhpicStruct.Cloum2 = vhpicStruct.n2./vhpicStruct.nc2;
vhpicStruct.s1 = ((vhpicStruct.lp1./vhpicStruct.Cloum1)-vhpicStruct.dp1)./2;%相邻两开孔之间间隔，默认等间隔
vhpicStruct.s2 = ((vhpicStruct.lp2./vhpicStruct.Cloum2)-vhpicStruct.dp2)./2;
vhpicStruct.sc1 = (pi.*vhpicStruct.Din - vhpicStruct.nc1.*vhpicStruct.dp1)./vhpicStruct.nc1;%一周开孔，相邻孔间距
vhpicStruct.sc2 = (pi.*vhpicStruct.Din - vhpicStruct.nc2.*vhpicStruct.dp2)./vhpicStruct.nc2;
l = vhpicStruct.lp1;
vhpicStruct.xSection1 = [0,ones(1,1).*(l/(1))];
l = vhpicStruct.lp2;
vhpicStruct.xSection2 = [0,ones(1,1).*(l/(1))];
sectionL1 = 0:0.25:L1;%[2.5,3.5];%0:0.25:L1;
sectionL2 = 0:0.25:L2;%[5.87,6.37,6.87，7.37,7.87,8.37,8.87,9.37,9.87,10.37]-L1-vhpicStruct.Lv1-vhpicStruct.Lv2;%0:0.25:L2;
vhpicStruct.lv1 = vhpicStruct.Lv./2-(0.150+0.168);%vhpicStruct.Lv./2-0.232;%内插管长于偏置管，偏置管la=罐体总长-罐封头边缘到偏置管中心距
vhpicStruct.lv2 = 0;%出口不偏置
vhpicStruct.lv3 = 0.150+0.168;%针对单一偏置缓冲罐入口偏置长度
vhpicStruct.lv4 = vhpicStruct.Lv./2-vhpicStruct.Lin;
vhpicStruct.Dbias = 0;%偏置管伸入罐体部分为0，所以对应直径为0
vhpicStruct.Dex = vhpicStruct.Din;

holepipeLength1 = vhpicStruct.Lin - vhpicStruct.la1 - vhpicStruct.la2;
hl1 = sum(vhpicStruct.xSection1);
if(~cmpfloat(holepipeLength1,hl1))
    error('孔管参数设置错误：holepipeLength1=%.8f,hl1=%.8f;Lin:%g,la1:%g,la2:%g,sum(xSection1):%g,dp:%g'...
        ,holepipeLength1,hl1...
        ,vhpicStruct.Lin,vhpicStruct.la1,vhpicStruct.la2...
        ,sum(vhpicStruct.xSection1),vhpicStruct.dp);
end



syms f

%最末端管道
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