function [ h,fillH,markH] = plotSpectrum( fre,mag,varargin )
%����Ƶ��ͼ��Ƶ��ͼ���������
% By:����Զ
%   fre Ƶ��
%   mag ��ֵ
%   varargin �����������ã�
% color ������ɫ
% isFill �Ƿ����
% isMarkPeak �Ƿ��Ƿ�ֵ
% markCount ��ǵķ�ֵ����
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
textAlignment = -1;%0 �� 1 ���� -1 �Զ�
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
        otherwise
            error('�����������')
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
%ylim(axisData(3:4));
end



