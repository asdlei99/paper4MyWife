function [Handle,x] = plotWave( wave,fs,varargin )
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



