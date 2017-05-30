function [ filteringData,magPks,fg] = selfAdaptingMainFrequencyFilter( wave,mainFrequencyCount,type,varargin)
%����Ӧ��Ƶ�˲�
%   wave ����
%   mainFrequencyCount
%   ��Ƶ�ʸ�������Ƶ��������ʽʹ��findpeaks����Ҫ��������ͨ��MINPEAKDISTANCE����������ֵ���
%   type ���ͣ�'none'����������Ƶ�ʱ�Ƶ�ɷֲ��ң�'one' ��������߱�Ƶ�ĳɷ֣�'all'���������б�Ƶ�ɷ�

pp=varargin;
minPeakDistance = 1;%��ֵ����Сλ�ƾ���
neighborCount = 0;%��Ƶ�ʵ��Ա�Ƶ�ʣ����Ϊ0��Ƶ�ʵ����ߵ�Ƶ�ʲ����������Ϊ1�������߱�����һ�����Դ�����
isShowFigure = 0;
Fs = 200;
isInputFs = 0;
fg = nan;
otherFreSet = 'thr';%zero : ������Ƶ������Ϊ0��thr �� ����һ���ż�������Ƶ�ʵ���ߵ�Ϊ����ż�ֵ��������������С������Ϊthr����Ҫ���thr���ԣ��������Ĭ��ֵ0.1����
thr = 0.1;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'minpeakdistance' %��ֵ����Сλ�ƾ���
            minPeakDistance=val;
        case 'neighborcount'
            neighborCount = val;
        case 'isshowfigure'
            isShowFigure = val;
        case 'fs'
            Fs = val;   %�����ʣ���ͼʱ��Ҫ�˲��� 
            isInputFs = 1;
        case 'otherfreset'
            otherFreSet = val;
        case 'thr'
            thr = val;
    end
end
if ~strcmpi(type,'none')
    if ~isInputFs
        error('��noneģʽ�����������Ƶ��');
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
Fre=(0:n-1)*Fs/n;%��ʵƵ��
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
%��ԭ����
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
%����Ҷ�任
%   �õ�����x��y��ֵ
    n=length(data);
    if isAddZero
        
        N=2^nextpow2(n);
    else
        N = n;
    end
    Y = fft(data,N);
    Amp=abs(Y);
    Fre=(0:N-1)*Fs/N;%��ʵƵ��
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
    title('ԭʼ�ź�');
    xlabel('ʱ��(s)');
    ylabel('��ֵ');
    subplot(3,2,2)
    h(2) = plotSpectrum(fre,amp,'color',clrWave,'isFill',1);
    xlim([fre(1),fre(end)]);
    title('ԭʼ�ź�Ƶ��');
    xlabel('Ƶ��(Hz)');
    ylabel('��ֵ');
    subplot(3,2,3)
    h(3) = plot(xt,filteringData,'color',clrFilter);
    grid on;
    xlim([xt(1),xt(end)]);
    title('�˲����ź�');
    xlabel('ʱ��(s)');
    ylabel('��ֵ');
    subplot(3,2,4)
    h(4) = plotSpectrum(freFilter,ampFilter,'color',clrFilter,'isFill',1);
    xlim([freFilter(1),freFilter(end)]);
    title('�˲����ź�Ƶ��');
    xlabel('Ƶ��(Hz)');
    ylabel('��ֵ');
    
    subplot(3,2,[5,6])
    h(5) = plot(xt,wave,'color',clrWave);
    hold on;
    h(6) = plot(xt,filteringData,'color',clrFilter);
    grid on;
    title('�˲����ź���ԭʼ�źŶԱ�');
    xlabel('ʱ��(s)');
    ylabel('��ֵ');
    textLegend={'ԭʼ�ź�','�˲����ź�'};
    legend(h(5:6),textLegend);
    
    set(gcf,'color','w');
end

function resIndex = findOtherMultFreIndex(freIndex,n)
% �ҵ��뱶Ƶ����Ƶ
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