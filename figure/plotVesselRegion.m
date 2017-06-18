function fh = plotVesselRegion( axesHandle,vesselRang )
%绘制缓冲罐的区域
%   在图里添加缓冲罐的区域
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

