function [fh,spectrogramData] = figureExpPressureSTFT(dataCells,meaPoint,Fs,varargin)
%����ʵ�����ݵĶ�ʱ����Ҷ�任����ͼ
% dataCells��dataStructCells�µľ������������dataStructCells{n,2}
% meaPoint:���
% varargin��ѡ���ԣ�
% chartType����ͼ���ͣ���ѡ��contour����Ĭ�ϣ����ߡ�plot3��
% baseField: ��ͼ�������ͣ�
pp = varargin;
varargin = {};
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
        otherwise
       		varargin{length(varargin)+1} = prop;
            varargin{length(varargin)+1} = val;
    end
end


fh.figure = figure
if 1 == length(meaPoint)
    paperFigureSet_normal();
    wave=dataCells.pressure(:,meaPoint);
    [fh.plotHandles,spectrogramData] = plotSTFT( wave,STFT,Fs,varargin{:});
    box on;
    xlim([0,50]);
    xlabel('Ƶ��(Hz)'); 
    ylabel('ʱ��(s)');
    zlabel('��ֵ(kPa)');
else
    paperFigureSet_FullWidth(8)
    for i=1:length(meaPoint)
        fh.subplotHandles = subplot(1,length(meaPoint),i);
        wave=dataCells.pressure(:,meaPoint(i));
        [fh.plotHandles(i),spectrogramData] = plotSTFT( wave,STFT,Fs,varargin{:});
        colorbar('off');
        box on;
        xlim([0,50]);
%         xlabel('Ƶ��(Hz)'); 
%         ylabel('ʱ��(s)');
%         zlabel('��ֵ(kPa)');
    end
    colorbar;
end
end

