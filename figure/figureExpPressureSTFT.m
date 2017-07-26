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
subplotRow = 1;
subplotCol = -1;
figureHeight = 10;
%��������İѵ�һ��varargin��Ϊlegend
legendLabels = {};
if 0 ~= mod(length(pp),2)
    legendLabels = pp{1};
    pp=pp(2:end);
end
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'stft' %����������
        	STFT = val;
        case 'legendlabels'
            legendLabels = val;
        case 'subplotrow'
            subplotRow = val;
        case 'subplotcol'
            subplotCol = val;
        case 'figureheight'
            figureHeight = val;
        otherwise
       		varargin{length(varargin)+1} = prop;
            varargin{length(varargin)+1} = val;
    end
end

if subplotRow <= 0
    error('subplotRow ������ڵ���1');
end

fh.figure = figure;
if 1 == length(meaPoint)
    paperFigureSet_normal();
    wave=dataCells.pressure(:,meaPoint);
    [fh.plotHandles,spectrogramData] = plotSTFT( wave,STFT,Fs,varargin{:});
    box on;
    xlim([0,50]);
    xlabel('Ƶ��(Hz)','FontName',paperFontName(),'FontSize',paperFontSize()); 
    ylabel('ʱ��(s)','FontName',paperFontName(),'FontSize',paperFontSize());
    zlabel('��ֵ(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
else
    paperFigureSet_FullWidth(figureHeight)
    if subplotCol <= 0
        subplotCol = length(meaPoint) / subplotRow;
    end
    for i=1:length(meaPoint)
        fh.subplotHandles = subplot(subplotRow,subplotCol,i);
        wave=dataCells.pressure(:,meaPoint(i));
        [fh.plotHandles(i),spectrogramData] = plotSTFT( wave,STFT,Fs,varargin{:});
        colorbar('off');
        box on;
        xlim([0,50]);
        if ~isempty(legendLabels)
            fh.title(i) = title(legendLabels{i},'FontName',paperFontName(),'FontSize',paperFontSize());
        end
        if 1==i || 0 == mod(i-1,subplotCol)
            fh.ylabel = ylabel('ʱ��(s)','FontName',paperFontName(),'FontSize',paperFontSize());
        end
        fh.xlabel(i) = xlabel('Ƶ��(Hz)','FontName',paperFontName(),'FontSize',paperFontSize());
    end
    fh.colorBar = colorbar;
    colorBarTicks = get(fh.colorBar,'Ticks')
    set(fh.colorBar,'Ticks',[0,colorBarTicks(end)]);
    set(fh.colorBar,'TickLabels',{'��','��'},'FontName',paperFontName(),'FontSize',paperFontSize());
    set(fh.colorBar,'Position',...
    [0.941127558168275 0.109140624239201 0.00928362573099406 0.816901042427465]);
end
end

