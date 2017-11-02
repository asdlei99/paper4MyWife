function fh = figureShockSpectrumContourf( dataCells,varargin)
%绘制冲击响应的图
%
pp = varargin;
varargin = {};
figureHeight = 10;
legendLabels = {};
xs = {};
xlimValue = [];
xlabelValue = [];
oneColorBar = 1;
xSection = [];
sectionPlotTitle = {};
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
        case 'x'
            xs = val;
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
        case 'xsection'
            xSection = val;
        case 'sectionplottitle'
            sectionPlotTitle = val;
        otherwise
       		varargin{length(varargin)+1} = prop;
            varargin{length(varargin)+1} = val;
    end
end
fh.figure = figure;
if isempty(xSection)
    subplotRow = ceil(length(dataCells)/2);
else
    subplotRow = ceil(length(dataCells)/2) + 1;
end
if 1==length(dataCells)
    paperFigureSet_normal(figureHeight);
    dataCell = dataCells;
    if strcmp(amplituteType,'db')
        dataCell.Mag = 20 * log10(dataCell.Mag);
    end
    fh.gca = gca;
    if isempty(xSection)
        fh.contourfHandle = plotSpectrumContourf(dataCell.Mag'...
            ,dataCell.Fre'...
            ,xs...
            ,varargin{:});
    else
        subplot(1,2,1);
        fre = dataCell.Fre(:,1);
        index = getSectionIndex(xSection,fre);
        fh.contourfHandle = plotSpectrumContourf(dataCell.Mag'...
            ,dataCell.Fre'...
            ,xs...
            ,varargin{:});
        hold on;
        ax = axis();
        count = 1;
        for xS = xSection
            fh.xSectionPlotHandle(count) = plot([xS,xS],[ax(3),ax(4)],'--w');
            count = count + 1;
        end
        
        fh.gca(1) = gca;
        set(fh.gca(1),'Position',[0.09 0.196 0.332 0.7]);
        fh.oneColorBar = colorbar('Position'...
            ,[0.45268970875942 0.142227464933993 0.0284655172413794 0.783828117892077]...
            ,'TickLabels',{'',''}...
            );
        fh.lowText = annotation('textbox',...
            [0.47 0.103 0.0573908045977011 0.0826822916666666],...
            'String',{'低'},...
            'FitBoxToText','off'...
            ,'EdgeColor','none');
        fh.heightText = annotation('textbox',...
            [0.47 0.893472222222225 0.0628649425287363 0.0992187499999999],...
            'String',{'高'},...
            'FitBoxToText','off'...
            ,'EdgeColor','none');
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
        subplot(1,2,2);
        count = 1;
        for xSIndex = index
            x = xs;
            y = dataCell.Mag(xSIndex,:);
            if(count > 1)
                hold on;
            end
            fh.sectionXPlotHandle(count) = plot(x,y,'color',getPlotColor(count));
            count = count + 1;
        end
        if ~isempty(sectionPlotTitle)
            title(sectionPlotTitle);
        end
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
    minValue = zeros(1,length(dataCells));
    sectionDatas = {};
    for plotCount = 1:length(dataCells)
        dataCell = dataCells{plotCount};
        if strcmp(amplituteType,'db')
            dataCell.Mag = 20 * log10(dataCell.Mag);
        end
        subplot(subplotRow,2,plotCount);
        fh.gca(plotCount) = gca;
        fh.contourfHandle(plotCount) = plotSpectrumContourf(dataCell.Mag'...
            ,dataCell.Fre'...
            ,xs{plotCount}...
            ,'isShowColorBar',isShowColorBar...
            ,varargin{:});
        maxValue(plotCount) = max(max(dataCell.Mag'));
        minValue(plotCount) = min(min(dataCell.Mag'));
        if isempty(xSection)
            if 0 == mod(plotCount,2)
                set(gca,'Position',[0.5 0.196 0.332 0.7]);
            else
                set(gca,'Position',[0.09 0.196 0.332 0.7]);
            end
        end
        ax = axis();
        xSectionPlotHandle = [];
        hold on;
        count = 1;
        for xS = xSection
            xSectionPlotHandle(count) = plot([xS,xS],[ax(3),ax(4)],'--w');
            count = count + 1;
        end
        fre = dataCell.Fre(:,1);
        index = getSectionIndex(xSection,fre);
        count = 1;
        sectionData = {};
        for xSIndex = index
            sectionData{count,1} = xSIndex;
            sectionData{count,2} = xs{plotCount};
            sectionData{count,3} = dataCell.Mag(xSIndex,:);
            count = count + 1;
        end
        sectionDatas{plotCount} = sectionData;
        fh.xSectionPlotHandle{plotCount} = xSectionPlotHandle;
        if ~isempty(legendLabels)
            fh.titleHandle(plotCount) = title(legendLabels{plotCount});
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
    if ~isempty(xSection)
        subplot(subplotRow,2,[length(dataCells)+1,length(dataCells)+2]);
        fh.gcaBottomPlot = gca;
        hold on;
        count = 1;
        for i = 1:length(sectionDatas)
            sectionData = sectionDatas{i};
            color = getPlotColor(i);
            for j = 1:size(sectionData,1)
                x = sectionData{j,2};
                y = sectionData{j,3};
                fh.sectionXPlotHandle(count) = plot(x,y,'color',color...
                    ,'LineStyle',getLineStyle(j));
                count = count + 1;
            end
        end
        if ~isempty(sectionPlotTitle)
            title(sectionPlotTitle);
        end
    end
    box on;
    maxValue = max(maxValue);
    minValue = min(minValue);
    fh.oneColorBar = colorbar('Position'...
    ,[0.889252208759419 0.142227464933993 0.0284655172413792 0.783828117892076]...
    ,'Ticks',[minValue,maxValue] ...
    ,'TickLabels',{'',''}...
    );
    fh.lowText = annotation('textbox',...
        [0.918 0.111848958333333 0.0573908045977011 0.0826822916666666],...
        'String',{'低'},...
        'FitBoxToText','off'...
        ,'EdgeColor','none');
    fh.heightText = annotation('textbox',...
        [0.918 0.862604166666667 0.062864942528736 0.09921875],...
        'String',{'高'},...
        'FitBoxToText','off'...
        ,'EdgeColor','none');
end

end

function res = getSectionIndex(xSection,fre)
    res = zeros(1,length(xSection));
    count = 1;
    for xS = xSection
        index = find(fre == xS);
        if isempty(index)
            ratio = 1;
            while isempty(index)
                index = find((fre > (xS-0.5*ratio)) & (fre < (xS+0.5*ratio)));
                ratio = ratio + 1;
            end
            res(count) = index(1);
        else
            res(count) = index(1);
        end
        count = count + 1;
    end
end

