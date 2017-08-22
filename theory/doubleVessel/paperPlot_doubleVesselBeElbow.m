%% ˫��-�޶�����ͷ
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
% massFlowERaw = [0.01,0.1,0.03,0.003,0.007];
% FreRaw = [14];
% massFlowERaw = [0.2];



% ��ȡ��ҪƵ��
massFlowE = massFlowERaw;
Fre = FreRaw;

isDamping = 1;
%��ͼ����
isXShowRealLength = 1;

opt.acousticVelocity = 345;%����
opt.isDamping = isDamping;%�Ƿ��������
opt.coeffDamping = nan;%����
opt.coeffFriction = 0.003;%�ܵ�Ħ��ϵ��
SreaightMeanFlowVelocity =20;%14.5;%�ܵ�ƽ������
SreaightCoeffFriction = 0.003;
VesselMeanFlowVelocity =15;%14.5;%�����ƽ������
VesselCoeffFriction = 0.04;

% opt.meanFlowVelocity =14.5;%14.5;%�ܵ�ƽ������
opt.isUseStaightPipe = 1;%�����������ݾ���ķ���
opt.mach = opt.meanFlowVelocity / opt.acousticVelocity;
opt.notMach = 0;

baseFrequency = 14;
allowDeviation = 0.5;
multFreTimes = 3;
semiFreTimes = 3;
beforeAfterMeaPoint = nan;
calcPeakPeakValueSection = nan;

variant_lv3 = 0.150+0.168;%[0.3,1.1,1.9];%0.150+0.168;
% V2 = pi.*0.372^2./4.*1.1;%�̶����ʱ��
% variant_r = [0.5,1,2,3,4,5,6,7,8,9];%����޳�����
%variant_DV2 = [0.4,0.5,0.6,0.7,0.8,0.9];%[0.372,0.5261];%[0.1,0.2,0.3,0.4,0.5,0.6];
%variant_LV2 = [1,2,3,4,5,6];%[2.2,1.1];%[1,2,3,4,5,6];

dataStructCells = {};
calcDatas = {};


for i = 1:length(variant_lv3)     
    para(i).opt = opt;
    para(i).L1 = 3.5;%L1(m)
    para(i).L2 = 6;%L2��m������
    para(i).L3 = 1.5;%1.5;%˫�޴����޶�����ͷ���޼��
    para(i).L4 = 4;%4%˫�޴����޶�����ͷ���ڹܳ�
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
    para(i).lv3 = variant_lv3(i);%��Ե�һƫ�û�������ƫ�ó���

%     para(i).lv4 = para(i).Lv./2-para(i).Lin;
    para(i).Dbias = 0;%ƫ�ù�������岿��Ϊ0�����Զ�Ӧֱ��Ϊ0
%     para(i).Dex = para(i).Din;
    para(i).sectionL1 = 0:0.25:para(i).L1;%[2.5,3.5];%0:0.25:para(i).L1;
    para(i).sectionL2 = 0:0.25:para(i).L2;
    para(i).sectionL3 = 0:0.25:para(i).L3;
    para(i).sectionL4 = 0:0.25:para(i).L4;
    para(i).sectionL5 = 0:0.25:para(i).L5;
    name{i} = sprintf('lv3:%g',variant_lv3(i));
end

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
                ,'friction',para(i).opt.coeffFriction,'meanFlowVelocity',para(i).opt.meanFlowVelocity...
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


   
% Dbias ƫ�ù��ڲ��뻺��޵Ĺܾ������ƫ�ù�û���ڲ��绺��ޣ�DbiasΪ0
%   Detailed explanation goes here
%                       |  L2
%              Lv    l  | outlet
%        _______________|___ bias2
%       |                   |  Dpipe
%       |lv2  V          lv1|�������� L1  
%       |___________________| inlet
%           Dv              l      
    
    %�������˳�ӳ���ǰƫ��
    [pressure1OSFB,pressure2OSFB] = ...
        vesselStraightFrontBiasPulsationCalc(massFlowE,Fre,time,...
            para(i).L1,para(i).L2,...
            para(i).LV1,para(i).l,para(i).Dpipe,para(i).DV1,...
            para(i).lv3,para(i).Dbias,...
            para(i).sectionL1,para(i).sectionL2,...
            'a',para(i).opt.acousticVelocity,'isDamping',para(i).opt.isDamping,'friction',0.011,...
            'meanFlowVelocity',para(i).opt.meanFlowVelocity,'isUseStaightPipe',1,...
            'm',para(i).opt.mach,'notMach',para(i).opt.notMach...
            ,'isOpening',isOpening...
            );%,'coeffDamping',opt.coeffDamping
    rawDataStruct = fun_dataProcessing([pressure1OSFB,pressure2OSFB]...
            ,'fs',Fs...
            ,'basefrequency',baseFrequency...
            ,'allowdeviation',allowDeviation...
            ,'multfretimes',multFreTimes...
            ,'semifretimes',semiFreTimes...
            ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
            ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
            );
    dataStructCells{1,1} = '���ڼ������-ֱ����ǰ��';
    dataStructCells{1,2} = rawDataStruct;
    plus1OSFB{i} = calcPuls(pressure1OSFB,dcpss);
    plus2OSFB{i} = calcPuls(pressure2OSFB,dcpss);
    plusOSFB{i} = [plus1OSFB{i},plus2OSFB{i}];
    multFreAmpValueOSFB{i} = calcWaveFreAmplitude([pressure1OSFB,pressure2OSFB],Fs,multFre,'freErr',1);

    calcDatas{dataCount,1} = sprintf('���ڼ������-ֱ����ǰ��');
    calcDatas{dataCount,2} = X;
    calcDatas{dataCount,3} = plusOSFB{i};
    calcDatas{dataCount,4} = multFreAmpValueOSFB{i}(1,:);
    calcDatas{dataCount,5} = multFreAmpValueOSFB{i}(2,:);
    calcDatas{dataCount,6} = multFreAmpValueOSFB{i}(3,:);
    dataCount = dataCount + 1;
 
    
    
    
%       ���� L1     l    Lv    l    L2   l    Lv
%                   __________            ___________ 
%                  |          |          |           |   
%       -----------|          |----------|           |
%                  |__________|          |__   ______|      
% ֱ��      Dpipe       Dv       Dpipe      | |
%                                           | | L3 
%                                           | |
    %����˫��-�޶�����ͷ ������ٵ��ڵ�45ʱ��ģ��Ͻӽ�(L1,L3,L4,0.045)
    [pressure1DBE,pressure2DBE,pressure3DBE] = ...
        doubleVesselElbowPulsationCalc(massFlowE,Fre,time,...
            para(i).L1,para(i).L3,para(i).L4,...
            para(i).LV1,para(i).LV2,para(i).l,para(i).Dpipe,para(i).DV1,para(i).DV2,...
            para(i).lv3,para(i).Dbias,...
            para(i).sectionL1,para(i).sectionL3,para(i).sectionL4,...
            'a',para(i).opt.acousticVelocity,'isDamping',para(i).opt.isDamping,'friction',0.045,...
            'meanFlowVelocity',opt.meanFlowVelocity,'isUseStaightPipe',1,...
            'm',para(i).opt.mach,'notMach',para(i).opt.notMach...
            ,'isOpening',isOpening...
            );%,'coeffDamping',opt.coeffDamping
     rawDataStruct = fun_dataProcessing([pressure1DBE,pressure2DBE]...
            ,'fs',Fs...
            ,'basefrequency',baseFrequency...
            ,'allowdeviation',allowDeviation...
            ,'multfretimes',multFreTimes...
            ,'semifretimes',semiFreTimes...
            ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
            ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
            );
    dataStructCells{2,1} = '˫��-�޶�����ͷ';
    dataStructCells{2,2} = rawDataStruct;
    plus1DBE{i} = calcPuls(pressure1DBE,dcpss);
    plus2DBE{i} = calcPuls(pressure2DBE,dcpss);
    plus3DBE{i} = calcPuls(pressure3DBE,dcpss);
    aheadMaxPlusDBE(i) = max(plus1DBE{i});%��ǰ�����������
    afterMaxPlusDBE(i) = max(plus3DBE{i});%�޺������������
    plusDBE{i} = [plus1DBE{i},plus2DBE{i},plus3DBE{i}];
    multFreAmpValueDBE{i} = calcWaveFreAmplitude([pressure1DBE,pressure2DBE,pressure3DBE],Fs,multFre,'freErr',1);

    calcDatas{dataCount,1} = sprintf('˫��-�޶�����ͷ,lv3:%g',variant_lv3(i));
    calcDatas{dataCount,2} = [para(i).sectionL1, para(i).L1 + 2*para(i).l+para(i).LV1+para(i).sectionL3,...
                                para(i).L1 + 2*para(i).l+para(i).LV1+para(i).L3+ 2*para(i).l+para(i).lv3+para(i).DV2./2+para(i).sectionL4];
    calcDatas{dataCount,3} = plusDBE{i};
    calcDatas{dataCount,4} = multFreAmpValueDBE{i}(1,:);
    calcDatas{dataCount,5} = multFreAmpValueDBE{i}(2,:);
    calcDatas{dataCount,6} = multFreAmpValueDBE{i}(3,:);
    dataCount = dataCount + 1;


    
%       ���� L1     l    Lv   l l    Lv     l        L2
%                   __________   ___________ 
%                  |          | |           |   
%       -----------|          |-|           |-------------------
%                  |__________| |___________|      
% ֱ��      Dpipe       Dv           Dv          Dpipe     
%����˫�޴���
% if i==1
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
    rawDataStruct = fun_dataProcessing([pressure1DBS,pressure2DBS]...
            ,'fs',Fs...
            ,'basefrequency',baseFrequency...
            ,'allowdeviation',allowDeviation...
            ,'multfretimes',multFreTimes...
            ,'semifretimes',semiFreTimes...
            ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
            ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
            );
    dataStructCells{3,1} = '˫���޼������';
    dataStructCells{3,2} = rawDataStruct;
    plus1DBS{i} = calcPuls(pressure1DBS,dcpss);
    plus2DBS{i} = calcPuls(pressure2DBS,dcpss);
    aheadMaxPlusDBS(i) = max(plus1DBS{i});%��ǰ�����������
    afterMaxPlusDBS(i) = max(plus2DBS{i});%�޺������������
    plusDBS{i} = [plus1DBS{i},plus2DBS{i}];
    multFreAmpValueDBS{i} = calcWaveFreAmplitude([pressure1DBS,pressure2DBS],Fs,multFre,'freErr',1);

    calcDatas{dataCount,1} = sprintf('˫���޼������,lv3:%g',variant_lv3(i));
    calcDatas{dataCount,2} = [para(i).sectionL1, ...
                                para(i).L1 + 2*para(i).l+para(i).LV1+2*para(i).l+para(i).LV2+para(i).sectionL5];
    calcDatas{dataCount,3} = plusDBS{i};
    calcDatas{dataCount,4} = multFreAmpValueDBS{i}(1,:);
    calcDatas{dataCount,5} = multFreAmpValueDBS{i}(2,:);
    calcDatas{dataCount,6} = multFreAmpValueDBS{i}(3,:);
    dataCount = dataCount + 1;
%  end

    
    
%  ���� L1     l    Lv   l    L2  
%                   __________        
%                  |          |      
%       -----------|          |----------
%                  |__________|       
% ֱ�� Dpipe       Dv       Dpipe  
    %���㵥һ�����
    if i == 1
        [pressure1OV,pressure2OV] = oneVesselPulsationCalc(massFlowE,Fre,time,...
                para(i).L1,para(i).L2,...
                para(i).LV1,para(i).l,para(i).Dpipe,para(i).DV1,...
                para(i).sectionL1,para(i).sectionL2,...
                'a',opt.acousticVelocity,'isDamping',opt.isDamping,'friction',opt.coeffFriction,...
                'meanFlowVelocity',para(i).opt.meanFlowVelocity,'isUseStaightPipe',1,...
                'm',para(i).opt.mach,'notMach',para(i).opt.notMach...
                ,'isOpening',isOpening...
            );
        rawDataStruct = fun_dataProcessing([pressure1OV,pressure2OV]...
            ,'fs',Fs...
            ,'basefrequency',baseFrequency...
            ,'allowdeviation',allowDeviation...
            ,'multfretimes',multFreTimes...
            ,'semifretimes',semiFreTimes...
            ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
            ,'calcpeakpeakvaluesection',calcPeakPeakValueSection...
            );
        dataStructCells{4,1} = 'ֱ��ֱ�������';
        dataStructCells{4,2} = rawDataStruct;
        plus1OV = calcPuls(pressure1OV,dcpss);
        plus2OV = calcPuls(pressure2OV,dcpss);
        plusOV = [plus1OV,plus2OV];
        multFreAmpValue_OV{i} = calcWaveFreAmplitude([pressure1OV,pressure2OV],Fs,multFre,'freErr',1);

        calcDatas{dataCount,1} = sprintf('ֱ��ֱ�������');
        calcDatas{dataCount,2} = X;
        calcDatas{dataCount,3} = plusOV;
        calcDatas{dataCount,4} = multFreAmpValue_OV{i}(1,:);
        calcDatas{dataCount,5} = multFreAmpValue_OV{i}(2,:);
        calcDatas{dataCount,6} = multFreAmpValue_OV{i}(3,:);
        dataCount = dataCount + 1;
    end


end

ignoreHeader = 1;
%����ѹ������
figure 
plotDataCells(calcDatas,'xcol',2,'ycol',3,'legendcol',1,'ignoreHeader',ignoreHeader);
title('����ѹ�����ֵ');
% figure
% subplot(1,2,1)
% hold on;
% h1 = plot(variant_lv3,aheadMaxPlusDBE./1000,'--r');
% set(h1,'Marker','x');
% h2 = plot(variant_lv3,afterMaxPlusDBE./1000,'--r');
% set(h2,'Marker','<');
% xlabel('lv3(m)');
% ylabel('peak-to-peak pressure pulsation (kPa)');
% title('DoubleTank(Tank2BeELbow)');
% legend([h1,h2],{'at measurement 1','at measurement 13'});

% % subplot(1,2,2)
% hold on;
% h3 = plot(variant_lv3,aheadMaxPlusDBS./1000,'--r');
% set(h3,'Marker','x');
% h4 = plot(variant_lv3,afterMaxPlusDBS./1000,'--r');
% set(h4,'Marker','<');
% xlabel('lv3(m)');
% ylabel('peak-to-peak pressure pulsation (kPa)');
% title('DoubleTank');
% legend([h3,h4],{'at measurement 1','at measurement 13'});
%����1��Ƶ
figure
plotDataCells(calcDatas,'xcol',2,'ycol',4,'legendcol',1,'ignoreHeader',ignoreHeader);
title('ѹ��1��Ƶ');
%����2��Ƶ
figure
plotDataCells(calcDatas,'xcol',2,'ycol',5,'legendcol',1,'ignoreHeader',ignoreHeader);
title('ѹ��2��Ƶ');
%����3��Ƶ
figure
plotDataCells(calcDatas,'xcol',2,'ycol',6,'legendcol',1,'ignoreHeader',ignoreHeader);
title('ѹ��3��Ƶ');

result = externPlotDatasCell(calcDatas,'dataRowsIndexs',[2:size(calcDatas,1)]...
    ,'dataColumnIndex',[2:size(calcDatas,2)]...
    ,'dataParamLegend',calcDatas(1,2:size(calcDatas,2))...
    ,'dataNameLegend',calcDatas(2:size(calcDatas,1)),1);