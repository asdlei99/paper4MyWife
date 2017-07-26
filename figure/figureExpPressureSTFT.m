function [fh,spectrogramData] = figureExpPressureSTFT(dataCells,meaPoint,Fs,varargin)
%绘制实验数据的短时傅立叶变换的普图
% dataCells：dataStructCells下的具体测量的数据dataStructCells{n,2}
% meaPoint:测点
% varargin可选属性：
% chartType：绘图类型，可选‘contour’（默认）或者‘plot3’
% baseField: 绘图数据类型，
pp = varargin;
varargin = {};
STFT.windowSectionPointNums = 1024;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
subplotRow = 1;
subplotCol = -1;
figureHeight = 10;
%允许特殊的把地一个varargin作为legend
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
        case 'stft' %误差带的类型
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
    error('subplotRow 必须大于等于1');
end

fh.figure = figure;
if 1 == length(meaPoint)
    paperFigureSet_normal();
    wave=dataCells.pressure(:,meaPoint);
    [fh.plotHandles,spectrogramData] = plotSTFT( wave,STFT,Fs,varargin{:});
    box on;
    xlim([0,50]);
    xlabel('频率(Hz)','FontName',paperFontName(),'FontSize',paperFontSize()); 
    ylabel('时间(s)','FontName',paperFontName(),'FontSize',paperFontSize());
    zlabel('幅值(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
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
            fh.ylabel = ylabel('时间(s)','FontName',paperFontName(),'FontSize',paperFontSize());
        end
        fh.xlabel(i) = xlabel('频率(Hz)','FontName',paperFontName(),'FontSize',paperFontSize());
    end
    fh.colorBar = colorbar;
    colorBarTicks = get(fh.colorBar,'Ticks')
    set(fh.colorBar,'Ticks',[0,colorBarTicks(end)]);
    set(fh.colorBar,'TickLabels',{'低','高'},'FontName',paperFontName(),'FontSize',paperFontSize());
    set(fh.colorBar,'Position',...
    [0.941127558168275 0.109140624239201 0.00928362573099406 0.816901042427465]);
end
end

