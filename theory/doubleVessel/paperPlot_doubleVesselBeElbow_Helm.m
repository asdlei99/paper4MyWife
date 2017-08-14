%% 双罐-罐二作弯头内插0.5D孔管入全开出亥姆霍兹共鸣器
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));

isOpening = 	0;%管道闭口
%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%环境25度绝热压缩到0.2MPaG的温度对应密度
rpm = 420;
outDensity = 1.5608;%环境25度绝热压缩到0.15MPaG的温度对应密度
multFre=[14,28,42];
Fs = 4096;
[massFlowRaw,time,~,opt.meanFlowVelocity] = massFlowMaker(0.25,0.098,rpm...
	,0.14,1.075,outDensity,'rcv',0.15,'k',1.4,'pr',0.15,'fs',Fs,'oneSecond',6);

[FreRaw,AmpRaw,PhRaw,massFlowERaw] = frequencySpectrum(detrend(massFlowRaw,'constant'),Fs);
 FreRaw = [7,14,21,28,14*3];
 massFlowERaw = [0.02,0.2,0.03,0.003,0.007];


% 提取主要频率
massFlowE = massFlowERaw;
Fre = FreRaw;

isDamping = 1;
%绘图参数
isXShowRealLength = 1;



opt.acousticVelocity = 345;%声速
opt.isDamping = isDamping;%是否计算阻尼
opt.coeffDamping = nan;%阻尼
opt.coeffFriction = 0.04;%管道摩察系数
SreaightMeanFlowVelocity =20;%14.5;%管道平均流速
SreaightCoeffFriction = 0.03;
VesselMeanFlowVelocity =8;%14.5;%缓冲罐平均流速
VesselCoeffFriction = 0.003;

% opt.meanFlowVelocity =14.5;%14.5;%管道平均流速
opt.isUseStaightPipe = 1;%计算容器传递矩阵的方法
opt.mach = opt.meanFlowVelocity / opt.acousticVelocity;
opt.notMach = 0;

%% 先计算亥姆霍兹为14hz时的直径和体积
% dp = 0.025:0.005:0.045;
dp = [0.098,0.098/2,0.098/4,0.098,0.098/2];
Dv = 0.372;%缓冲罐的直径（m）;
Lv = 1.1;%缓冲罐总长 
lc = [0.003,0.003,0.003,0.5,0.5];
helmholtzV = (pi*Dv.^2/4)*(Lv/2)-(pi.*dp.^2/4).*lc;
% lc = helmholtzLcWithFrequency(opt.acousticVelocity,dp,14,helmholtzV);

% dp = ones(1,length(lc)).*0.025;

for i = 1:length(dp)     
    para(i).opt = opt;
    para(i).L1 = 3.5;%L1(m)
    para(i).L2 = 6;%L2（m）长度
    para(i).L3 = 1.5;%双罐串联罐二作弯头两罐间距
    para(i).L4 = 4;%双罐串联罐二作弯头出口管长
    para(i).L5 = 5.85;%4.5;%双罐无间隔串联L2（m）长度
    para(i).Dpipe = 0.098;%管道直径（m）%应该是0.106
    para(i).l = 0.01;
    para(i).DV1 = 0.372;%缓冲罐的直径（m）
    para(i).LV1 = 1.1;%缓冲罐总长 （1.1m）
    para(i).DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%缓冲罐的直径（0.372m）
    para(i).LV2 = 1.1;%variant_r(i).*para(i).DV2;%缓冲罐总长 （1.1m）
    para(i).V2 = pi.*para(i).DV2^2./4.*para(i).LV2;
    para(i).Lv1 = para(i).LV1./2;%缓冲罐腔1总长
    para(i).Lv2 = para(i).LV1-para(i).Lv1;%缓冲罐腔2总长   
    para(i).lv1 = para(i).LV1./2-(0.150+0.168);%para(i).Lv./2-0.232;%内插管长于偏置管，偏置管la=罐体总长-罐封头边缘到偏置管中心距
    para(i).lv2 = 0;%出口不偏置
    para(i).lv3 = 0.150+0.168;%针对单一偏置缓冲罐入口偏置长度
    para(i).dp = dp(i);%亥姆霍兹共鸣器连接管管径
    para(i).lc = lc(i);%亥姆霍兹共鸣器连接管管长
%     para(i).lv4 = para(i).Lv./2-para(i).Lin;
    para(i).Dbias = 0;%偏置管伸入罐体部分为0，所以对应直径为0
%     para(i).Dex = para(i).Din;
    para(i).sectionL1 = 0:0.25:para(i).L1;%[2.5,3.5];%0:0.25:para(i).L1;
    para(i).sectionL2 = 0:0.25:para(i).L2;
    para(i).sectionL3 = 0:0.25:para(i).L3;
    para(i).sectionL4 = 0:0.25:para(i).L4;
    para(i).sectionL5 = 0:0.25:para(i).L5;
    
    name{i} = sprintf('lc:%g',lc(i));
end



calcDatas = {};

%%
dcpss = getDefaultCalcPulsSetStruct();
dcpss.calcSection = [0.3,0.7];
dcpss.sigma = 2.8;
dcpss.fs = Fs;
dcpss.isHp = 0;
dcpss.f_pass = 7;%通过频率5Hz
dcpss.f_stop = 5;%截止频率3Hz
dcpss.rp = 0.1;%边带区衰减DB数设置
dcpss.rs = 30;%截止区衰减DB数设置

dataCount = 2;
calcDatas{1,2} = 'x值';
calcDatas{1,3} = '压力脉动';
calcDatas{1,4} = '1倍频';
calcDatas{1,5} = '2倍频';
calcDatas{1,6} = '3倍频';
for i = 1:length(para)
   if i==1
        %计算直管
        %直管总长
        straightPipeLength = para(i).L1 + 2*para(i).l+para(i).Lv1+para(i).Lv2 + para(i).L2;
        straightPipeSection = [para(i).sectionL1,...
                                para(i).L1 + 2*para(i).l+para(i).Lv1+para(i).Lv2 + para(i).sectionL2];
        temp = find(straightPipeLength>para(i).L1);%找到缓冲罐所在的索引
        sepratorIndex = temp(1);
        
        temp = straightPipePulsationCalc(massFlowE,Fre,time,straightPipeLength,straightPipeSection...
                ,'d',para(i).Dpipe,'a',opt.acousticVelocity,'isDamping',opt.isDamping...
                ,'friction',SreaightCoeffFriction,'meanFlowVelocity',SreaightMeanFlowVelocity...
                ,'m',para(i).opt.mach,'notMach',para(i).opt.notMach,...
                'isOpening',isOpening);
        plusStraight = calcPuls(temp,dcpss);
        multFreAmpValue_straightPipe{i} = calcWaveFreAmplitude(temp,Fs,multFre,'freErr',1);

        if isXShowRealLength
            X = straightPipeSection;
        else
            X = 1:length(plusStraight);
        end
        calcDatas{dataCount,1} = sprintf('直管');
        calcDatas{dataCount,2} = X;
        calcDatas{dataCount,3} = plusStraight;
        calcDatas{dataCount,4} = multFreAmpValue_straightPipe{i}(1,:);
        calcDatas{dataCount,5} = multFreAmpValue_straightPipe{i}(2,:);
        calcDatas{dataCount,6} = multFreAmpValue_straightPipe{i}(3,:);
        dataCount = dataCount + 1;
   end

     
%       长度 L1     l    Lv    l    L2   l    Lv
%                   __________            ___________ 
%                  |          |          |           |   
%       -----------|          |----------|           |
%                  |__________|          |__   ______|      
% 直径      Dpipe       Dv       Dpipe      | |
%                                           | | L3 
%                                           | |
      if i==1 
        [pressure1DBE,pressure2DBE,pressure3DBE] = ...
        doubleVesselElbowPulsationCalc(massFlowE,Fre,time,...
            para(i).L1,para(i).L3,para(i).L4,...
            para(i).LV1,para(i).LV2,para(i).l,para(i).Dpipe,para(i).DV1,para(i).DV2,...
            para(i).lv3,para(i).Dbias,...
            para(i).sectionL1,para(i).sectionL3,para(i).sectionL4,...
            'a',para(i).opt.acousticVelocity,'isDamping',para(i).opt.isDamping,'friction',0.045,...
            'meanFlowVelocity',para(i).opt.meanFlowVelocity,'isUseStaightPipe',1,...
            'm',para(i).opt.mach,'notMach',para(i).opt.notMach...
            ,'isOpening',isOpening...
            );%,'coeffDamping',opt.coeffDamping
    plus1DBE{i} = calcPuls(pressure1DBE,dcpss);
    plus2DBE{i} = calcPuls(pressure2DBE,dcpss);
    plus3DBE{i} = calcPuls(pressure3DBE,dcpss);
    plusDBE{i} = [plus1DBE{i},plus2DBE{i},plus3DBE{i}];
    multFreAmpValueDBE{i} = calcWaveFreAmplitude([pressure1DBE,pressure2DBE,pressure3DBE],Fs,multFre,'freErr',1);

    calcDatas{dataCount,1} = sprintf('双罐-罐二作弯头');
    calcDatas{dataCount,2} = [para(i).sectionL1, para(i).L1 + 2*para(i).l+para(i).LV1+para(i).sectionL3,...
                                para(i).L1 + 2*para(i).l+para(i).LV1+para(i).L3+ 2*para(i).l+para(i).lv3+para(i).DV2./2+para(i).sectionL4];
    calcDatas{dataCount,3} = plusDBE{i};
    calcDatas{dataCount,4} = multFreAmpValueDBE{i}(1,:);
    calcDatas{dataCount,5} = multFreAmpValueDBE{i}(2,:);
    calcDatas{dataCount,6} = multFreAmpValueDBE{i}(3,:);
    dataCount = dataCount + 1;
      end

    
%       长度 L1     l    Lv   l l    Lv     l        L2
%                   __________   ___________ 
%                  |          | |           |   
%       -----------|          |-|           |-------------------
%                  |__________| |___________|      
% 直径      Dpipe       Dv           Dv          Dpipe     
%计算双罐串联
if i==1
    [pressure1DBS,pressure2DBS] = ...
        doubleVesselSeriesPulsationCalc(massFlowE,Fre,time,...
            para(i).L1,para(i).L5,...
            para(i).LV1,para(i).LV2,para(i).l,para(i).Dpipe,para(i).DV1,para(i).DV2,...
            para(i).sectionL1,para(i).sectionL5,...
            'a',para(i).opt.acousticVelocity,'isDamping',para(i).opt.isDamping,'friction',0.003,...
            'meanFlowVelocity',para(i).opt.meanFlowVelocity,'isUseStaightPipe',1,...
            'm',para(i).opt.mach,'notMach',para(i).opt.notMach...
            ,'isOpening',isOpening...
            );%,'coeffDamping',opt.coeffDamping
    plus1DBS{i} = calcPuls(pressure1DBS,dcpss);
    plus2DBS{i} = calcPuls(pressure2DBS,dcpss);
    plusDBS{i} = [plus1DBS{i},plus2DBS{i}];
    multFreAmpValueDBS{i} = calcWaveFreAmplitude([pressure1DBS,pressure2DBS],Fs,multFre,'freErr',1);

    calcDatas{dataCount,1} = sprintf('双罐无间隔串联');
    calcDatas{dataCount,2} = [para(i).sectionL1, ...
                                para(i).L1 + 2*para(i).l+para(i).LV1+2*para(i).l+para(i).LV2+para(i).sectionL5];
    calcDatas{dataCount,3} = plusDBS{i};
    calcDatas{dataCount,4} = multFreAmpValueDBS{i}(1,:);
    calcDatas{dataCount,5} = multFreAmpValueDBS{i}(2,:);
    calcDatas{dataCount,6} = multFreAmpValueDBS{i}(3,:);
    dataCount = dataCount + 1;
end
    
%       长度 L1     l    Lv    l    L2   l    Lv
%                   __________            ____________
%                  |          |          |     |      |   
%       -----------|          |----------|     |--    |
%                  |__________|          |__ __|______|      
% 直径      Dpipe       Dv       Dpipe      | 
%                                           | L3 
%                                           |
%计算双罐-罐二作弯头内插孔板腔体二内插管形成亥姆霍兹共鸣器
    [pressure1DBEH,pressure2DBEH,pressure3DBEH] = ...
        doubleVesselElbowHelmPulsationCalc(massFlowE,Fre,time,...
            para(i).L1,para(i).L3,para(i).L4,...
            para(i).LV1,para(i).LV2,para(i).Lv1,para(i).Lv2,para(i).l,para(i).Dpipe,para(i).DV1,para(i).DV2,...
            para(i).lv3,para(i).Dbias,...
            para(i).dp,para(i).lc,...
            para(i).sectionL1,para(i).sectionL3,para(i).sectionL4,...
            'a',para(i).opt.acousticVelocity,'isDamping',para(i).opt.isDamping,'friction',0.041,...
            'meanFlowVelocity',para(i).opt.meanFlowVelocity,'isUseStaightPipe',1,...
            'm',para(i).opt.mach,'notMach',para(i).opt.notMach...
            ,'isOpening',isOpening...
            );%,'coeffDamping',opt.coeffDamping
    plus1DBEH{i} = calcPuls(pressure1DBEH,dcpss);
    plus2DBEH{i} = calcPuls(pressure2DBEH,dcpss);
    plus3DBEH{i} = calcPuls(pressure3DBEH,dcpss);
    plusDBEH{i} = [plus1DBEH{i},plus2DBEH{i},plus3DBEH{i}];
    multFreAmpValueDBEH{i} = calcWaveFreAmplitude([pressure1DBEH,pressure2DBEH,pressure3DBEH],Fs,multFre,'freErr',1);
    Fr(i) = opt.acousticVelocity./(2.*pi).*sqrt((pi.*para(i).dp^2./4)./(para(i).lc.*(pi.*para(i).DV2.^2./4.*(para(i).LV2./2)-(pi.*(para(i).dp+0.008).^2/4).*para(i).lc)));%0.008是管壁厚

    calcDatas{dataCount,1} = sprintf('双罐-罐二作弯头内插1D管入全开出亥姆霍兹共鸣器,lc:%g,dp:%g,Fr:%g',lc(i),dp(i),Fr(i));
    calcDatas{dataCount,2} = [para(i).sectionL1, para(i).L1 + 2*para(i).l+para(i).LV1+para(i).sectionL3,...
                                para(i).L1 + 2*para(i).l+para(i).LV1+para(i).L3+ 2*para(i).l+para(i).lv3+para(i).DV2./2+para(i).sectionL4];
    calcDatas{dataCount,3} = plusDBEH{i};
    calcDatas{dataCount,4} = multFreAmpValueDBEH{i}(1,:);
    calcDatas{dataCount,5} = multFreAmpValueDBEH{i}(2,:);
    calcDatas{dataCount,6} = multFreAmpValueDBEH{i}(3,:);
    dataCount = dataCount + 1;
    
    
% %  长度 L1     l    Lv   l    L2  
% %                   __________        
% %                  |          |      
% %       -----------|          |----------
% %                  |__________|       
% % 直径 Dpipe       Dv       Dpipe  
%     %计算单一缓冲罐
%     if i == 1
%         [pressure1OV,pressure2OV] = oneVesselPulsationCalc(massFlowE,Fre,time,...
%                 para(i).L1,para(i).L2,...
%                 para(i).Lv,para(i).l,para(i).Dpipe,para(i).Dv,...
%                 para(i).sectionL1,para(i).sectionL2,...
%                 'a',opt.acousticVelocity,'isDamping',opt.isDamping,'friction',opt.coeffFriction,...
%                 'meanFlowVelocity',para(i).opt.meanFlowVelocity,'isUseStaightPipe',1,...
%                 'm',para(i).opt.mach,'notMach',para(i).opt.notMach...
%                 ,'isOpening',isOpening...
%             );
%         plus1OV = calcPuls(pressure1OV,dcpss);
%         plus2OV = calcPuls(pressure2OV,dcpss);
%         plusOV = [plus1OV,plus2OV];
%         multFreAmpValue_OV{i} = calcWaveFreAmplitude([pressure1OV,pressure2OV],Fs,multFre,'freErr',1);
% 
%         calcDatas{dataCount,1} = sprintf('直进直出缓冲罐');
%         calcDatas{dataCount,2} = X;
%         calcDatas{dataCount,3} = plusOV;
%         calcDatas{dataCount,4} = multFreAmpValue_OV{i}(1,:);
%         calcDatas{dataCount,5} = multFreAmpValue_OV{i}(2,:);
%         calcDatas{dataCount,6} = multFreAmpValue_OV{i}(3,:);
%         dataCount = dataCount + 1;
%     end


end

ignoreHeader = 1;
%绘制压力脉动
figure 
plotDataCells(calcDatas,'xcol',2,'ycol',3,'legendcol',1,'ignoreHeader',ignoreHeader);
title('脉动压力峰峰值');
% %绘制1倍频
% figure
% plotDataCells(calcDatas,'xcol',2,'ycol',4,'legendcol',1,'ignoreHeader',ignoreHeader);
% title('压力1倍频');
% %绘制2倍频
% figure
% plotDataCells(calcDatas,'xcol',2,'ycol',5,'legendcol',1,'ignoreHeader',ignoreHeader);
% title('压力2倍频');
% %绘制3倍频
% figure
% plotDataCells(calcDatas,'xcol',2,'ycol',6,'legendcol',1,'ignoreHeader',ignoreHeader);
% title('压力3倍频');

result = externPlotDatasCell(calcDatas,'dataRowsIndexs',[2:size(calcDatas,1)]...
    ,'dataColumnIndex',[2:size(calcDatas,2)]...
    ,'dataParamLegend',calcDatas(1,2:size(calcDatas,2))...
    ,'dataNameLegend',calcDatas(2:size(calcDatas,1)),1);