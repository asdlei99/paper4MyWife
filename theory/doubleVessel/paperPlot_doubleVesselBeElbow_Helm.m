%% ˫��-�޶�����ͷ�ڲ�0.5D�׹���ȫ������ķ���ȹ�����
clc;
close all;
clear;
currentPath = fileparts(mfilename('fullpath'));

isOpening = 	0;%�ܵ��տ�
%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
rpm = 420;
outDensity = 1.5608;%����25�Ⱦ���ѹ����0.15MPaG���¶ȶ�Ӧ�ܶ�
multFre=[14,28,42];
Fs = 4096;
[massFlowRaw,time,~,opt.meanFlowVelocity] = massFlowMaker(0.25,0.098,rpm...
	,0.14,1.075,outDensity,'rcv',0.15,'k',1.4,'pr',0.15,'fs',Fs,'oneSecond',6);

[FreRaw,AmpRaw,PhRaw,massFlowERaw] = frequencySpectrum(detrend(massFlowRaw,'constant'),Fs);
 FreRaw = [7,14,21,28,14*3];
 massFlowERaw = [0.02,0.2,0.03,0.003,0.007];


% ��ȡ��ҪƵ��
massFlowE = massFlowERaw;
Fre = FreRaw;

isDamping = 1;
%��ͼ����
isXShowRealLength = 1;



opt.acousticVelocity = 345;%����
opt.isDamping = isDamping;%�Ƿ��������
opt.coeffDamping = nan;%����
opt.coeffFriction = 0.04;%�ܵ�Ħ��ϵ��
SreaightMeanFlowVelocity =20;%14.5;%�ܵ�ƽ������
SreaightCoeffFriction = 0.03;
VesselMeanFlowVelocity =8;%14.5;%�����ƽ������
VesselCoeffFriction = 0.003;

% opt.meanFlowVelocity =14.5;%14.5;%�ܵ�ƽ������
opt.isUseStaightPipe = 1;%�����������ݾ���ķ���
opt.mach = opt.meanFlowVelocity / opt.acousticVelocity;
opt.notMach = 0;

%% �ȼ��㺥ķ����Ϊ14hzʱ��ֱ�������
% dp = 0.025:0.005:0.045;
dp = [0.098,0.098/2,0.098/4,0.098,0.098/2];
Dv = 0.372;%����޵�ֱ����m��;
Lv = 1.1;%������ܳ� 
lc = [0.003,0.003,0.003,0.5,0.5];
helmholtzV = (pi*Dv.^2/4)*(Lv/2)-(pi.*dp.^2/4).*lc;
% lc = helmholtzLcWithFrequency(opt.acousticVelocity,dp,14,helmholtzV);

% dp = ones(1,length(lc)).*0.025;

for i = 1:length(dp)     
    para(i).opt = opt;
    para(i).L1 = 3.5;%L1(m)
    para(i).L2 = 6;%L2��m������
    para(i).L3 = 1.5;%˫�޴����޶�����ͷ���޼��
    para(i).L4 = 4;%˫�޴����޶�����ͷ���ڹܳ�
    para(i).L5 = 5.85;%4.5;%˫���޼������L2��m������
    para(i).Dpipe = 0.098;%�ܵ�ֱ����m��%Ӧ����0.106
    para(i).l = 0.01;
    para(i).DV1 = 0.372;%����޵�ֱ����m��
    para(i).LV1 = 1.1;%������ܳ� ��1.1m��
    para(i).DV2 = 0.372;%variant_DV2(i);%(4.*V2./(pi.*variant_r(i)))^(1/3);%����޵�ֱ����0.372m��
    para(i).LV2 = 1.1;%variant_r(i).*para(i).DV2;%������ܳ� ��1.1m��
    para(i).V2 = pi.*para(i).DV2^2./4.*para(i).LV2;
    para(i).Lv1 = para(i).LV1./2;%�����ǻ1�ܳ�
    para(i).Lv2 = para(i).LV1-para(i).Lv1;%�����ǻ2�ܳ�   
    para(i).lv1 = para(i).LV1./2-(0.150+0.168);%para(i).Lv./2-0.232;%�ڲ�ܳ���ƫ�ùܣ�ƫ�ù�la=�����ܳ�-�޷�ͷ��Ե��ƫ�ù����ľ�
    para(i).lv2 = 0;%���ڲ�ƫ��
    para(i).lv3 = 0.150+0.168;%��Ե�һƫ�û�������ƫ�ó���
    para(i).dp = dp(i);%��ķ���ȹ��������ӹܹܾ�
    para(i).lc = lc(i);%��ķ���ȹ��������ӹܹܳ�
%     para(i).lv4 = para(i).Lv./2-para(i).Lin;
    para(i).Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
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
dcpss.f_pass = 7;%ͨ��Ƶ��5Hz
dcpss.f_stop = 5;%��ֹƵ��3Hz
dcpss.rp = 0.1;%�ߴ���˥��DB������
dcpss.rs = 30;%��ֹ��˥��DB������

dataCount = 2;
calcDatas{1,2} = 'xֵ';
calcDatas{1,3} = 'ѹ������';
calcDatas{1,4} = '1��Ƶ';
calcDatas{1,5} = '2��Ƶ';
calcDatas{1,6} = '3��Ƶ';
for i = 1:length(para)
   if i==1
        %����ֱ��
        %ֱ���ܳ�
        straightPipeLength = para(i).L1 + 2*para(i).l+para(i).Lv1+para(i).Lv2 + para(i).L2;
        straightPipeSection = [para(i).sectionL1,...
                                para(i).L1 + 2*para(i).l+para(i).Lv1+para(i).Lv2 + para(i).sectionL2];
        temp = find(straightPipeLength>para(i).L1);%�ҵ���������ڵ�����
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
        calcDatas{dataCount,1} = sprintf('ֱ��');
        calcDatas{dataCount,2} = X;
        calcDatas{dataCount,3} = plusStraight;
        calcDatas{dataCount,4} = multFreAmpValue_straightPipe{i}(1,:);
        calcDatas{dataCount,5} = multFreAmpValue_straightPipe{i}(2,:);
        calcDatas{dataCount,6} = multFreAmpValue_straightPipe{i}(3,:);
        dataCount = dataCount + 1;
   end

     
%       ���� L1     l    Lv    l    L2   l    Lv
%                   __________            ___________ 
%                  |          |          |           |   
%       -----------|          |----------|           |
%                  |__________|          |__   ______|      
% ֱ��      Dpipe       Dv       Dpipe      | |
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

    calcDatas{dataCount,1} = sprintf('˫��-�޶�����ͷ');
    calcDatas{dataCount,2} = [para(i).sectionL1, para(i).L1 + 2*para(i).l+para(i).LV1+para(i).sectionL3,...
                                para(i).L1 + 2*para(i).l+para(i).LV1+para(i).L3+ 2*para(i).l+para(i).lv3+para(i).DV2./2+para(i).sectionL4];
    calcDatas{dataCount,3} = plusDBE{i};
    calcDatas{dataCount,4} = multFreAmpValueDBE{i}(1,:);
    calcDatas{dataCount,5} = multFreAmpValueDBE{i}(2,:);
    calcDatas{dataCount,6} = multFreAmpValueDBE{i}(3,:);
    dataCount = dataCount + 1;
      end

    
%       ���� L1     l    Lv   l l    Lv     l        L2
%                   __________   ___________ 
%                  |          | |           |   
%       -----------|          |-|           |-------------------
%                  |__________| |___________|      
% ֱ��      Dpipe       Dv           Dv          Dpipe     
%����˫�޴���
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

    calcDatas{dataCount,1} = sprintf('˫���޼������');
    calcDatas{dataCount,2} = [para(i).sectionL1, ...
                                para(i).L1 + 2*para(i).l+para(i).LV1+2*para(i).l+para(i).LV2+para(i).sectionL5];
    calcDatas{dataCount,3} = plusDBS{i};
    calcDatas{dataCount,4} = multFreAmpValueDBS{i}(1,:);
    calcDatas{dataCount,5} = multFreAmpValueDBS{i}(2,:);
    calcDatas{dataCount,6} = multFreAmpValueDBS{i}(3,:);
    dataCount = dataCount + 1;
end
    
%       ���� L1     l    Lv    l    L2   l    Lv
%                   __________            ____________
%                  |          |          |     |      |   
%       -----------|          |----------|     |--    |
%                  |__________|          |__ __|______|      
% ֱ��      Dpipe       Dv       Dpipe      | 
%                                           | L3 
%                                           |
%����˫��-�޶�����ͷ�ڲ�װ�ǻ����ڲ���γɺ�ķ���ȹ�����
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
    Fr(i) = opt.acousticVelocity./(2.*pi).*sqrt((pi.*para(i).dp^2./4)./(para(i).lc.*(pi.*para(i).DV2.^2./4.*(para(i).LV2./2)-(pi.*(para(i).dp+0.008).^2/4).*para(i).lc)));%0.008�ǹܱں�

    calcDatas{dataCount,1} = sprintf('˫��-�޶�����ͷ�ڲ�1D����ȫ������ķ���ȹ�����,lc:%g,dp:%g,Fr:%g',lc(i),dp(i),Fr(i));
    calcDatas{dataCount,2} = [para(i).sectionL1, para(i).L1 + 2*para(i).l+para(i).LV1+para(i).sectionL3,...
                                para(i).L1 + 2*para(i).l+para(i).LV1+para(i).L3+ 2*para(i).l+para(i).lv3+para(i).DV2./2+para(i).sectionL4];
    calcDatas{dataCount,3} = plusDBEH{i};
    calcDatas{dataCount,4} = multFreAmpValueDBEH{i}(1,:);
    calcDatas{dataCount,5} = multFreAmpValueDBEH{i}(2,:);
    calcDatas{dataCount,6} = multFreAmpValueDBEH{i}(3,:);
    dataCount = dataCount + 1;
    
    
% %  ���� L1     l    Lv   l    L2  
% %                   __________        
% %                  |          |      
% %       -----------|          |----------
% %                  |__________|       
% % ֱ�� Dpipe       Dv       Dpipe  
%     %���㵥һ�����
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
%         calcDatas{dataCount,1} = sprintf('ֱ��ֱ�������');
%         calcDatas{dataCount,2} = X;
%         calcDatas{dataCount,3} = plusOV;
%         calcDatas{dataCount,4} = multFreAmpValue_OV{i}(1,:);
%         calcDatas{dataCount,5} = multFreAmpValue_OV{i}(2,:);
%         calcDatas{dataCount,6} = multFreAmpValue_OV{i}(3,:);
%         dataCount = dataCount + 1;
%     end


end

ignoreHeader = 1;
%����ѹ������
figure 
plotDataCells(calcDatas,'xcol',2,'ycol',3,'legendcol',1,'ignoreHeader',ignoreHeader);
title('����ѹ�����ֵ');
% %����1��Ƶ
% figure
% plotDataCells(calcDatas,'xcol',2,'ycol',4,'legendcol',1,'ignoreHeader',ignoreHeader);
% title('ѹ��1��Ƶ');
% %����2��Ƶ
% figure
% plotDataCells(calcDatas,'xcol',2,'ycol',5,'legendcol',1,'ignoreHeader',ignoreHeader);
% title('ѹ��2��Ƶ');
% %����3��Ƶ
% figure
% plotDataCells(calcDatas,'xcol',2,'ycol',6,'legendcol',1,'ignoreHeader',ignoreHeader);
% title('ѹ��3��Ƶ');

result = externPlotDatasCell(calcDatas,'dataRowsIndexs',[2:size(calcDatas,1)]...
    ,'dataColumnIndex',[2:size(calcDatas,2)]...
    ,'dataParamLegend',calcDatas(1,2:size(calcDatas,2))...
    ,'dataNameLegend',calcDatas(2:size(calcDatas,1)),1);