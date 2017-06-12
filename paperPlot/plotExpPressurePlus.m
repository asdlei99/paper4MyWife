function handle = plotExpPressurePlus(pressureDatas,meaPoint,fs,varargin)
%绘制实验的压力
%
% pressureDadas 压力数据的矩阵
% meaPoint 测点
% fs 压力采样率
% 可接上plot函数的后续输入，如"-r",或者"color",[254,212,122]./255这样


waveH = plotWave(pressureDatas(:,meaPoint),fs,varargin);

    
end
