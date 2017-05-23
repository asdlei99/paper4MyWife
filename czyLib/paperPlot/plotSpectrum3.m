function [ h,fillH ] = plotSpectrum3( fre,mag,Y,varargin )
%绘制频谱图，频谱图会填充区域
%   fre 频率
%   mag 幅值
%   Y 第三参考系
%   lineColor 线条颜色
%   isFill 是否进行填充
%   otherSetting 其它设置，
% otherSetting.isMarkTop
% 是否标记峰值，在此设置为true的情况下，频谱的峰值会被标记，同时otherSetting.markCount才有效
% otherSetting.markCount 标记峰值的个数
pp=varargin;
lineColor = [255,0,0]./255;
isFill = 0;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch prop
        case 'color'
            lineColor=val;
        case 'isFill'
            isFill=val;
        otherwise
            error('参数输入错误！')
    end
end



if length(Y) == 1
    Y = ones(length(fre),1) .* Y;
end

h = plot3(fre,Y,mag);
set(h,'color',lineColor);

if isFill
    hold on;
    fillH = fill3([0;fre;fre(end);0],[Y(1);Y;Y(1);Y(1)],[0;mag;0;0],lineColor);
    set(fillH,'edgealpha',0);
    set(fillH,'FaceAlpha',0.4);
else
    fillH = [];
end


end

