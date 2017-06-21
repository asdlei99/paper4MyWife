function fh = plotVesselRegion( axesHandle,vesselRang )
%���ƻ���޵�����
%   ��ͼ����ӻ���޵�����
if nargin < 2
    vesselRang = [2,3];
end
ylim = get(axesHandle,'YLim');
x = [vesselRang(1),vesselRang(2),vesselRang(2),vesselRang(1)];
y = [ylim(1),ylim(1),ylim(2),ylim(2)];
fh = fill(x,y,getVesselRegionFaceColor());
set(fh,'FaceAlpha',0.3);
set(fh,'EdgeColor',getVesselRegionFaceColor());
set(fh,'EdgeAlpha',0.3);
end

