%% ��һ����޵�������ƫ�þ���lv1��������lv1
function theoryDataCells = oneVesselChangLv1(lv1,varargin)
vType = 'StraightInStraightOut';
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

%EqualBiasInOut:���н����г�
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


%          

% straightInBiasOut:ֱ����ǰ��
%��������˳�ӣ�����ǰ��λ��������������
% Dbias ƫ�ù��ڲ��뻺��޵Ĺܾ������ƫ�ù�û���ڲ��绺��ޣ�DbiasΪ0
%                       |  L2
%              Lv    l  | outlet
%        _______________|___ bias2
%       |                   |  Dpipe
%       |lv2  V          lv1|�������� L1  
%       |___________________| inlet
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
pp = varargin;
massflowData = nan;
%% ��ʼ����
%
param.isOpening = 0;%�ܵ��տ�%rpm = 300;outDensity = 1.9167;multFre=[10,20,30];%����25�Ⱦ���ѹ����0.2MPaG���¶ȶ�Ӧ�ܶ�
param.rpm = 420;
param.outDensity = 1.5608;
param.Fs = 4096;
param.acousticVelocity = 345;%���٣�m/s��
param.isDamping = 1;
param.coeffFriction = 0.03;
param.meanFlowVelocity = 16;
param.L = 10;%�ܳ���
param.L1 = 3.5;%(m)
param.L2 = 6;
param.Lv = 1.1;
param.l = 0.01;%(m)����޵����ӹܳ�
param.Dv = 0.372;
param.sectionL1 = 0:0.5:param.L1;%linspace(0,param.L1,14);
param.sectionL2 = 0:0.5:param.L2;%linspace(0,param.L2,14);
param.Dpipe = 0.098;%�ܵ�ֱ����m��
param.X = [param.sectionL1, param.sectionL1(end) + 2*param.l + param.Lv + param.sectionL2];
param.lv1 = 0.318;
param.lv2 = 0.318;

while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'massflowdata'
            massflowData = val;
        case 'vtype'
            vType = val;
        case 'param'
            param = val;
        otherwise
            error('�������:%s',prop);
    end
end


if isnan(massflowData)
    [massFlowRaw,time,~,opt.meanFlowVelocity] = massFlowMaker(0.25,0.098,param.rpm...
        ,0.14,1.075,param.outDensity,'rcv',0.15,'k',1.4,'pr',0.15,'fs',param.Fs,'oneSecond',6);
    [freRaw,AmpRaw,PhRaw,massFlowERaw] = frequencySpectrum(detrend(massFlowRaw,'constant'),param.Fs);
    freRaw = [7,14,21,28,14*3];
    massFlowERaw = [0.02,0.2,0.03,0.003,0.007];
    massFlowE = massFlowERaw;
    param.fre = freRaw;
    param.massFlowE = massFlowE;
else
    time = makeTime(param.Fs,1024);
    param.fre = massflowData(1,:);
    param.massFlowE = massflowData(2,:);
end


baseFrequency = 14;
multFreTimes = 3;
semiFreTimes = 3;
allowDeviation = 0.5;


dcpss = getDefaultCalcPulsSetStruct();
dcpss.calcSection = [0.2,0.8];
dcpss.fs = param.Fs;
dcpss.isHp = 0;
dcpss.f_pass = 7;%ͨ��Ƶ��5Hz
dcpss.f_stop = 5;%��ֹƵ��3Hz
dcpss.rp = 0.1;%�ߴ���˥��DB������
dcpss.rs = 30;%��ֹ��˥��DB������
theoryDataCells{1,1} = '����';
theoryDataCells{1,2} = 'dataCells';
theoryDataCells{1,3} = 'X';
theoryDataCells{1,4} = 'lv1';
theoryDataCells{1,5} = 'input';

for i = 1:length(lv1)
    
    param.lv1 = lv1(i);
    [pressure1,pressure2] = oneVesselPulsationCalc(param.massFlowE,param.fre,time...
        ,param.L1,param.L2,param.Lv,param.l,param.Dpipe,param.Dv ...
        ,param.sectionL1,param.sectionL2 ...
        ,'vType',vType...
        ,'a',param.acousticVelocity...
        ,'isDamping',param.isDamping...
        ,'friction',param.coeffFriction...
        ,'isOpening',param.isOpening...
        ,'meanFlowVelocity',param.meanFlowVelocity...
        ,'lv1',param.lv1...
        ,'lv2',param.lv2...
        );
    beforeAfterMeaPoint = [length(param.sectionL1),length(param.sectionL1)+1];
    pressure = [pressure1,pressure2];
    %[plus,filterData] = calcPuls(pressure,dcpss);
    theoryDataCells{i+1,1} = sprintf('�����ƫ�þ���:%g',param.lv1);
    theoryDataCells{i+1,2} = fun_dataProcessing(pressure...
                                ,'fs',param.Fs...
                                ,'basefrequency',baseFrequency...
                                ,'allowdeviation',allowDeviation...
                                ,'multfretimes',multFreTimes...
                                ,'semifretimes',semiFreTimes...
                                ,'beforeAfterMeaPoint',beforeAfterMeaPoint...
                                ,'calcpeakpeakvaluesection',nan...
                                );
    theoryDataCells{i+1,3} = param.X;
    theoryDataCells{i+1,4} = param.lv1;
    theoryDataCells{i+1,5} = param;
    
end


end
