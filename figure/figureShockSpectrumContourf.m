function fh = figureShockSpectrumContourf( dataCells,varargin)
%绘制冲击响应的图
%
pp = varargin;
varargin = {};
figureHeight = 10;
legendLabels = {};
ys = {};
xlimValue = [];
xlabelValue = [];
oneColorBar = 1;
amplituteType = 'normal';
if 0 ~= mod(length(pp),2)
    legendLabels = pp{1};
    pp=pp(2:end);
end
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'legendlabels'
            legendLabels = val;
        case 'figureheight'
            figureHeight = val;
        case 'y'
            ys = val;
        case 'amplitutetype'
            amplituteType = val;
        case 'xlim'
            xlimValue = val;
        case 'xlabel'
            xlabelValue = val;
        case 'ylabel'
            ylabelValue = val;
        case 'onecolorbar'
            oneColorBar = val;
        otherwise
       		varargin{length(varargin)+1} = prop;
            varargin{length(varargin)+1} = val;
    end
end
fh.figure = figure;
subplotRow = ceil(length(dataCells)/2);

if 1==length(dataCells)
    paperFigureSet_normal(figureHeight);
    dataCell = dataCells;
    if strcmp(amplituteType,'db')
        dataCell.Mag = 20 * log10(dataCell.Mag);
    end
    fh.gca = gca;
    fh.contourfHandle = plotSpectrumContourf(dataCell.Mag'...
        ,dataCell.Fre'...
        ,ys...
        ,varargin{:});
    if ~isempty(legendLabels)
        title(legendLabels);
    end
    if ~isempty(xlimValue)
        xlim(xlimValue);
    end
    if ~isempty(xlabelValue)
        xlabel(xlabelValue);
    end
    if ~isempty(ylabelValue)
        ylabel(ylabelValue);
    end
else
    paperFigureSet_FullWidth(figureHeight);
    if ~isempty(xlimValue)
        if ~iscell(xlimValue)
            xlimValue = cellfun(@(x) xlimValue,cell(1,length(dataCells),1),'UniformOutput',false);
        end
    end
    if ~isempty(xlabelValue)
        if ~iscell(xlabelValue)
            xlabelValue = cellfun(@(x) xlabelValue,cell(1,length(dataCells),1),'UniformOutput',false);
        end
    end
    if ~isempty(ylabelValue)
        if ~iscell(ylabelValue)
            ylabelValue = cellfun(@(x) ylabelValue,cell(1,length(dataCells),1),'UniformOutput',false);
        end
    end
    isShowColorBar = 1;
    if oneColorBar
        isShowColorBar = 0;
    end
    maxValue = zeros(1,length(dataCells));
    for plotCount = 1:length(dataCells)
        dataCell = dataCells{plotCount};
        if strcmp(amplituteType,'db')
            dataCell.Mag = 20 * log10(dataCell.Mag);
        end
        subplot(subplotRow,2,plotCount);
        fh.gca(plotCount) = gca;
        fh.contourfHandle(plotCount) = plotSpectrumContourf(dataCell.Mag'...
            ,dataCell.Fre'...
            ,ys{plotCount}...
            ,'isShowColorBar',isShowColorBar...
            ,varargin{:});
        maxValue(plotCount) = max(max(dataCell.Mag'));
        if 0 == mod(plotCount,2)
            set(gca,'Position',[0.5 0.15 0.332 0.78]);
        else
            set(gca,'Position',[0.09 0.15 0.332 0.78]);
        end
        if ~isempty(legendLabels)
            title(legendLabels{plotCount});
        end
        if ~isempty(xlimValue)
            xlim(xlimValue{plotCount});
        end
        if ~isempty(xlabelValue)
            xlabel(xlabelValue{plotCount});
        end
        if ~isempty(ylabelValue)
            ylabel(ylabelValue{plotCount});
        end
    end
    maxValue = max(maxValue);
    maxValue
    fh.oneColorBar = colorbar('Position'...
    ,[0.889252208759419 0.142227464933993 0.0284655172413792 0.783828117892076]...
    ,'Ticks',[0,maxValue] ...
    ,'TickLabels',{'低','高'}...
    );
end

end

