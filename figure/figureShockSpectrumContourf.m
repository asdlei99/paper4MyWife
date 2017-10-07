function fh = figureShockSpectrumContourf( dataCells,varargin)
%»æÖÆ³å»÷ÏìÓ¦µÄÍ¼
%
pp = varargin;
varargin = {};
figureHeight = 10;
legendLabels = {};
ys = {};
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
else
    paperFigureSet_FullWidth(figureHeight);
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
            ,varargin{:});
        if ~isempty(legendLabels)
            title(legendLabels{plotCount});
        end
    end
end

end

