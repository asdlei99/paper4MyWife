function fh = plotVesselRegion( axesHandle,vesselRang,varargin )
%���ƻ���޵�����
%   ��ͼ����ӻ���޵�����
pp = varargin;
color = getVesselRegionFaceColor();
yPercent = [0,0];
FaceAlpha = 0.3;
EdgeAlpha = 0.3;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'color' %����������
        	color = val;
        case 'ypercent'
            yPercent = val;
        case 'facealpha'
            FaceAlpha = val;
        case 'edgealpha'
            EdgeAlpha = val;
        otherwise
            error('��������%s',prop);
    end
end
ylim = get(axesHandle,'YLim');
yLen = ylim(2) - ylim(1);
y1 = ylim(1) + yLen*yPercent(1);
y2 = ylim(2) - yLen*yPercent(2);
x = [vesselRang(1),vesselRang(2),vesselRang(2),vesselRang(1)];
y = [y1,y1,y2,y2];
fh = fill(x,y,color);
set(fh,'FaceAlpha',FaceAlpha);
set(fh,'EdgeColor',color);
set(fh,'EdgeAlpha',EdgeAlpha);
end

