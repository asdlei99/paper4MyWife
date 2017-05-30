function [ filteringData,magPks,fg] = selfAdaptingMainFrequencyFilter( wave,mainFrequencyCount,type,varargin)
%自适应主频滤波
%   wave 波形
%   mainFrequencyCount
%   主频率个数，主频率搜索方式使用findpeaks，需要调整可以通过MINPEAKDISTANCE，来调整峰值间距
%   type 类型，'none'将不进行主频率倍频成分查找，'one' 将查找最高倍频的成分，'all'将查找所有倍频成分

pp=varargin;
minPeakDistance = 1;%峰值的最小位移距离
neighborCount = 0;%主频率的旁边频率，如果为0主频率的两边的频率不保留，如果为1，把两边保留各一个，以此类推
isShowFigure = 0;
Fs = 200;
isInputFs = 0;
fg = nan;
otherFreSet = 'thr';%zero : 把其余频率设置为0，thr ： 设置一个门槛，其余频率的最高点为这个门槛值，其他按比例缩小，设置为thr后需要添加thr属性，否则会以默认值0.1处理
thr = 0.1;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'minpeakdistance' %峰值的最小位移距离
            minPeakDistance=val;
        case 'neighborcount'
            neighborCount = val;
        case 'isshowfigure'
            isShowFigure = val;
        case 'fs'
            Fs = val;   %采样率，绘图时需要此参数 
            isInputFs = 1;
        case 'otherfreset'
            otherFreSet = val;
        case 'thr'
            thr = val;
    end
end
if ~strcmpi(type,'none')
    if ~isInputFs
        error('非none模式必须输入采样频率');
    end
end
n=length(wave);
[dcWave,meanWave]= fun_delete_DC(wave);
wave_fft = fft(dcWave);
mag_data = abs(wave_fft);
phase_data = angle(wave_fft);
[magPks,locs]=findpeaks(mag_data,'SORTSTR','descend','MINPEAKDISTANCE',minPeakDistance,'NPEAKS',mainFrequencyCount);
retainFreIndex = [];
count = 0;
Fre=(0:n-1)*Fs/n;%真实频率
Fre = Fre(1:floor(n/2));
if strcmp(type,'none')
    for j = 1:length(locs)
        count = count + 1;
        mfi = locs(j);
        retainFreIndex(count) = mfi;
        if neighborCount>0
            for i=1:neighborCount
                count = count + 1;
                retainFreIndex(count) = mfi-i;
                count = count + 1;
                retainFreIndex(count) = mfi+i;
            end
        end
    end
elseif strcmp(type,'one')
   for j = 1:length(locs)
        count = count + 1;
        mfi = locs(j);
        retainFreIndex(count) = mfi;
        if neighborCount>0
            for i=1:neighborCount
                count = count + 1;
                retainFreIndex(count) = mfi-i;
                count = count + 1;
                retainFreIndex(count) = mfi+i;
            end
        end
   end
   otherIndex = findOtherMultFreIndex(locs(1),n);
   retainFreIndex = union(retainFreIndex,otherIndex);
else
    for j = 1:length(locs)
        count = count + 1;
        mfi = locs(j);
        retainFreIndex(count) = mfi;
        if neighborCount>0
            for i=1:neighborCount
                count = count + 1;
                retainFreIndex(count) = mfi-i;
                count = count + 1;
                retainFreIndex(count) = mfi+i;
            end
        end
    end
    for i=1:length(locs)
        otherIndex = findOtherMultFreIndex(locs(i),n);
        retainFreIndex = union(retainFreIndex,otherIndex);
    end
   
end

retainFreIndex = unique(retainFreIndex);
retainFreIndex(retainFreIndex<=0) = [];
retainFreIndex(retainFreIndex>n) = [];
otherFreIndex = 1:length(wave_fft);
otherFreIndex = setdiff(otherFreIndex,retainFreIndex);
if strcmpi(otherFreSet,'zero')
    mag_data(otherFreIndex) = 0;
else
    maxOtherMag = max(mag_data(otherFreIndex).*2./n);
    curRate = maxOtherMag/thr;
    mag_data(otherFreIndex) = mag_data(otherFreIndex)./curRate;
end
%复原数据
filteringData = mag_data .* exp(1i.*phase_data);
filteringData = ifft(filteringData);
filteringData=real(filteringData);
filteringData = filteringData + meanWave;
if isShowFigure
   fg = showFigure(wave,filteringData,Fs);
end
end

function [Fre, Amp,Ph] = fun_fft( data,Fs,isAddZero)
    if nargin==2
        isAddZero = 0;
    end
%傅里叶变换
%   得到的是x和y的值
    n=length(data);
    if isAddZero
        
        N=2^nextpow2(n);
    else
        N = n;
    end
    Y = fft(data,N);
    Amp=abs(Y);
    Fre=(0:N-1)*Fs/N;%真实频率
    Fre = Fre(1:N/2);
    %Fre=Fs/2*linspace(0,1,N/2)';
    Amp = Amp(1:N/2)*2/n;
    Ph=2*angle(Y(1:N/2));
    Ph=Ph*180/pi;
    Fre = Fre';
end

function fg = showFigure(wave,filteringData,Fs)
    n=length(wave);
    [fre,amp] = fun_fft(wave,Fs);
    [freFilter,ampFilter] = fun_fft(filteringData,Fs);
    xt = 0:1/Fs:((n-1)/Fs);
    clrWave = [237,82,82]./255;
    clrFilter = [106,70,209]./255;
    fg = figure;
    subplot(3,2,1)
    h(1) = plot(xt,wave,'color',clrWave);
    grid on;
    xlim([xt(1),xt(end)]);
    title('原始信号');
    xlabel('时间(s)');
    ylabel('幅值');
    subplot(3,2,2)
    h(2) = plotSpectrum(fre,amp,'color',clrWave,'isFill',1);
    xlim([fre(1),fre(end)]);
    title('原始信号频谱');
    xlabel('频率(Hz)');
    ylabel('幅值');
    subplot(3,2,3)
    h(3) = plot(xt,filteringData,'color',clrFilter);
    grid on;
    xlim([xt(1),xt(end)]);
    title('滤波后信号');
    xlabel('时间(s)');
    ylabel('幅值');
    subplot(3,2,4)
    h(4) = plotSpectrum(freFilter,ampFilter,'color',clrFilter,'isFill',1);
    xlim([freFilter(1),freFilter(end)]);
    title('滤波后信号频谱');
    xlabel('频率(Hz)');
    ylabel('幅值');
    
    subplot(3,2,[5,6])
    h(5) = plot(xt,wave,'color',clrWave);
    hold on;
    h(6) = plot(xt,filteringData,'color',clrFilter);
    grid on;
    title('滤波后信号与原始信号对比');
    xlabel('时间(s)');
    ylabel('幅值');
    textLegend={'原始信号','滤波后信号'};
    legend(h(5:6),textLegend);
    
    set(gcf,'color','w');
end

function resIndex = findOtherMultFreIndex(freIndex,n)
% 找到半倍频及倍频
MultFre1 = [];
temp = freIndex*2;
count = 0;
while temp<n
    count = count + 1;
    MultFre1(count) = temp;
    temp=freIndex*(count+2);
end
temp1 = floor(freIndex/2);
temp2 = ceil(freIndex/2);
MultFre2(1) = temp1;
MultFre2(2) = temp2;
temp1 = floor(freIndex*1.5);
temp2 = ceil(freIndex*1.5);
MultFre2(3) = temp1;
MultFre2(4) = temp2;
% MultFre2 = [];
% count = 0;
% while temp1>1 && temp2>1
%     temp1 = floor(temp1);
%     temp2 = ceil(temp2);
%     if temp1~= temp2
%         count = count + 1;
%         MultFre2(count) = temp1;
%         count = count + 1;
%         MultFre2(count) = temp2;
%         temp1 = floor(freIndex/(count+2));
%         temp2 = ceil(freIndex/(count+2));
%     else
%         count = count + 1;
%         MultFre2(count) = temp1;
%         temp1 = floor(freIndex/(count+2));
%         temp2 = ceil(freIndex/(count+2));
%     end
% end

resIndex = union(MultFre1,MultFre2);
end