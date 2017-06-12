function [Handle,x] = plotWave( wave,fs,varargin )
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
x = 0:length(wave)-1;
x = x * (1/fs);
if 0 ~= mod(size(pp,2),2)
    Handle = plot(x,wave,pp{1});
    pp = pp(2:end);
end

index = 1:2:size(pp,2) > 1
for i = index
    set(Handle,pp{i},pp{i+1});
end

hold on;
grid on;
set(gcf,'color','w');

end



