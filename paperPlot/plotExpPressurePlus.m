function handle = plotExpPressurePlus(pressureDatas,meaPoint,fs,varargin)
%����ʵ���ѹ��
%
% pressureDadas ѹ�����ݵľ���
% meaPoint ���
% fs ѹ��������
% �ɽ���plot�����ĺ������룬��"-r",����"color",[254,212,122]./255����


waveH = plotWave(pressureDatas(:,meaPoint),fs,varargin);

    
end
