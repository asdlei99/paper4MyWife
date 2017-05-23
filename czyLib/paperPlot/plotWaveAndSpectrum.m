function [outPut] = plotWaveAndSpectrum( wave,fs,varargin )
%绘制频谱图，频谱图会填充区域
% By:尘中远
%   fre 频率
%   mag 幅值
%   varargin 其它属性设置：
% color 线条颜色
% isFill 是否填充
% isMarkPeak 是否标记峰值
% markCount 标记的峰值个数
pp=varargin;
lineColor = [255,0,0]./255;
isFill = 0;
isMarkPeak = 0;
markCount = 10;
markColor = [0,0,255]./255;
markerFaceColor = nan;
minPeakDistance = 1;
fillH = [];
markH = [];
isMarkData = 0;
MarkDataCount = 3;
textAlignment = -1;%0 横 1 竖着 -1 自动
figureHandle = nan;
showFigure = 1;
scale = 'amp';

while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch prop
        case 'color'
            lineColor=val;
        case 'isFill'
            isFill=val;
        case 'isMarkPeak'
            isMarkPeak=val;
        case 'markCount'
            isMarkPeak = 1;
            markCount=val;
        case 'markColor'
            isMarkPeak = 1;
            markColor=val;
        case 'markerFaceColor'
            isMarkPeak = 1;
            markerFaceColor=val;
        case 'minPeakDistance'
            isMarkPeak = 1;
            minPeakDistance=val;
        case 'isMarkData'
            isMarkData = val;
        case 'MarkDataCount'
            MarkDataCount = val;
        case 'textAlignment'
            textAlignment = val;
        case 'figureHandle'
            figureHandle = val;
        case 'showFigure'
            showFigure = val;
        case 'scale'
            scale = val;
        otherwise
            error('参数输入错误！')
    end
end

if isnan(figureHandle)
    if showFigure
       figureHandle = figure;
    else
       figureHandle = figure('visible','off');
    end
end
outPut.figure = figureHandle;

x = 0:length(wave)-1;
x = x * (1/fs);
subplot(2,1,1)
outPut.waveH = plot(x,wave,'-b');
hold on;
grid on;
[fre,mag] = frequencySpectrum(wave,fs,'scale',scale);

if size(fre,2)>1
    fre = fre';
end
if size(mag,2)>1
    mag = mag';
end

subplot(2,1,2)
outPut.spectrumH = plot(fre,mag);
set(outPut.spectrumH,'color',lineColor);
hold on;
grid on;
if isFill
    outPut.fillH = fill([0;fre;fre(end);0],[0;mag;0;0],lineColor);
    set(outPut.fillH,'edgealpha',0);
    set(outPut.fillH,'FaceAlpha',0.4);
end
axisData = axis;
if isMarkPeak
    [pks,locs]=findpeaks(mag,'SORTSTR','descend','MINPEAKDISTANCE',minPeakDistance,'NPEAKS',markCount);
    hold on;
    outPut.markH = plot(fre(locs),pks);
    set(outPut.markH,'color',markColor);
    set(outPut.markH,'LineStyle','none');
    set(outPut.markH,'Marker','v');
    if ~isnan(markerFaceColor)
        set(outPut.markH,'markerfacecolor',markerFaceColor);
    end
    if isMarkData
        hold on;
        for i=1:MarkDataCount
            if textAlignment == -1
                if pks(i)/axisData(4) > 0.7
                    text(fre(locs(i)),pks(i),sprintf(' %g Hz',fre(locs(i)))...
                    ,'VerticalAlignment','middle','HorizontalAlignment','left');
                else
                    text(fre(locs(i)),pks(i),sprintf(' %g Hz',fre(locs(i)))...
                    ,'VerticalAlignment','middle','HorizontalAlignment','left'...
                    ,'Rotation',90);
                end
            elseif textAlignment==0
                text(fre(locs(i)),pks(i),sprintf(' %g Hz',fre(locs(i)))...
                    ,'VerticalAlignment','middle','HorizontalAlignment','left');
            elseif textAlignment==1
                text(fre(locs(i)),pks(i),sprintf(' %g Hz',fre(locs(i)))...
                    ,'VerticalAlignment','middle','HorizontalAlignment','left'...
                    ,'Rotation',90);
            end
            
        end
    end
end
set(gcf,'color','w');
%ylim(axisData(3:4));
end



