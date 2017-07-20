function [fh,spectrogramData] = figureExpPressureSTFT(dataCells,meaPoint,Fs,varargin)
%����ʵ�����ݵĶ�ʱ����Ҷ�任����ͼ
% dataCells��dataStructCells�µľ������������dataStructCells{n,2}
% meaPoint:���
% varargin��ѡ���ԣ�
% chartType����ͼ���ͣ���ѡ��contour����Ĭ�ϣ����ߡ�plot3��
% baseField: ��ͼ�������ͣ�
pp = varargin;
chartType = 'contour';
baseField = 'rawData';
STFT.windowSectionPointNums = 1024;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'stft' %����������
        	STFT = val;
        case 'charttype'
            chartType = val;
        case 'basefield'
            baseField = val;
        otherwise
       		error('��������%s',prop);
    end
end

figure
paperFigureSet_normal();
wave=dataCells.pressure(:,meaPoint);
[fh,spectrogramData] = plotSTFT( wave,SIFT,Fs,varargin )
xlabel('frequency(Hz)'); 
ylabel('time(s)');
zlabel('amplitude');

end

