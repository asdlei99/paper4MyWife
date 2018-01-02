function [ h,fillH,markH] = plotSpectrum( fre,mag,varargin )
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
markDataStyle = 'fre';
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'color'
            lineColor=val;
        case 'isfill'
            isFill=val;
        case 'ismarkpeak'
            isMarkPeak=val;
        case 'markcount'
            isMarkPeak = 1;
            markCount=val;
        case 'markcolor'
            isMarkPeak = 1;
            markColor=val;
        case 'markerfacecolor'
            isMarkPeak = 1;
            markerFaceColor=val;
        case 'minpeakdistance'
            isMarkPeak = 1;
            minPeakDistance=val;
        case 'ismarkdata'
            isMarkData = val;
        case 'markdatacount'
            MarkDataCount = val;
        case 'textalignment'
            textAlignment = val;
        case 'markdatastyle'
            markDataStyle = val;
        otherwise
            error('参数输入错误！%s',prop);
    end
end

if size(fre,2)>1
    fre = fre';
end
if size(mag,2)>1
    mag = mag';
end

h = plot(fre,mag);
set(h,'color',lineColor);
hold on;
grid on;
if isFill
    fillH = fill([0;fre;fre(end);0],[0;mag;0;0],lineColor);
    set(fillH,'edgealpha',0);
    set(fillH,'FaceAlpha',0.4);
end
axisData = axis;
if isMarkPeak
    [pks,locs]=findpeaks(mag,'SORTSTR','descend','MINPEAKDISTANCE',minPeakDistance,'NPEAKS',markCount);
    hold on;
    markH = plot(fre(locs),pks);
    set(markH,'color',markColor);
    set(markH,'LineStyle','none');
    set(markH,'Marker','v');
    if ~isnan(markerFaceColor)
        set(markH,'markerfacecolor',markerFaceColor);
    end
    if isMarkData
        hold on;
        for i=1:MarkDataCount
            if strcmpi(markDataStyle,'fre')
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
            else
                 text(fre(locs(i)),pks(i),sprintf('%d',i)...
                        ,'VerticalAlignment','bottom','HorizontalAlignment','Center');
            end
            
        end
    end
end
%ylim(axisData(3:4));
end



