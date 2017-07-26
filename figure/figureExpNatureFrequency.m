function fh = figureExpNatureFrequency(dataCombineStructCells,varargin)
%绘制实验数据的压力脉动和抑制率图
pp = varargin;
chartType = 'line';
varargin = {};
%允许特殊的把地一个varargin作为legend
if 0 ~= mod(length(pp),2)
    varargin{1} = pp{1};
    pp=pp(2:end);
end

while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'charttype' %绘图类型可选'line'和'bar'
            chartType = val;
        otherwise
            varargin{length(varargin)+1} = prop;
            varargin{length(varargin)+1} = val;
    end
end
% if strcmp(chartType,'line')
    fh = plotInLine(dataCombineStructCells,varargin{:});
% else
%     fh = plotInBar(dataCombineStructCells,varargin{:});
end
end


function fh = plotInLine(dataCombineStructCells,varargin)
    pp = varargin;
    errorType = 'ci';%绘制误差带的模式，std：mean+-sd,ci为95%置信区间，minmax为最大最小
    rang = 1:13;
    yFilterFunPtr = nan;
    legendLabels = {};
    baseField = 'rawData';
    showPureVessel = 0;
    rpm = 420;
    natureFre= [1,2];%固有频率，支持[0.5,1,1.5,2,2.5,3]
    %允许特殊的把地一个varargin作为legend
    if 0 ~= mod(length(pp),2)
        legendLabels = pp{1};
        pp=pp(2:end);
    end
    while length(pp)>=2
        prop =pp{1};
        val=pp{2};
        pp=pp(3:end);
        switch lower(prop)
            case 'errortype' %误差带的类型
                errorType = val;
            case 'rang'
                rang = val;
            case 'yfilterfunptr'
                yFilterFunPtr = val;
            case 'basefield'
                baseField = val;
            case 'naturefre'
                natureFre = val;
            case 'nf'
                natureFre = val;
            case 'showpurevessel'
                showPureVessel = val;
            case 'rpm'
                rpm = val;
            otherwise
                error('参数错误%s',prop);
        end
    end


    fh.figure = figure;
    paperFigureSet_normal();
    x = constExpMeasurementPointDistance();%测点对应的距离
    %需要显示单一缓冲罐

    if showPureVessel
        dataPat = getPureVesselCombineDataPath(rpm);
        st = loadExpCombineDataStrcut(dataPat);
        for i=1:length(natureFre)
            plotLineStyle = getLineStyle(i);
            [y,stdVal,maxVal,minVal,muci] = getExpCombineNatureFrequencyDatas(st,natureFre(i),baseField);
            [yUp,yDown] = getUpDownRang(y,stdVal,maxVal,minVal,muci,errorType,rang);
            y = y(rang);
            if strcmp(errorType,'none')
                fh.vesselHandle(i) = plot(x,y,'color',[160,162,162]./255 ...
                    ,'LineStyle',plotLineStyle');
            else
                [fh.vesselHandle(i),fh.vesselErrFillHandle(i)] = plotWithError(x,y,yUp,yDown...
                    ,'color',[160,162,162]./255 ...
                    ,'LineStyle',plotLineStyle);
            end
        end
        
        hold on;
    end

    for plotCount = 1:length(dataCombineStructCells)
        plotMarker = getMarkStyle(plotCount);
        plotColor = getPlotColor(plotCount);
        
        for i=1:length(natureFre)
            plotLineStyle = getLineStyle(i);
            if 1==length(dataCombineStructCells)
                [y,stdVal,maxVal,minVal,muci] = getExpCombineNatureFrequencyDatas(dataCombineStructCells,natureFre(i),baseField);
            else
                [y,stdVal,maxVal,minVal,muci] = getExpCombineNatureFrequencyDatas(dataCombineStructCells{plotCount},natureFre(i),baseField);
            end
            [yUp,yDown] = getUpDownRang(y,stdVal,maxVal,minVal,muci,errorType,rang);
            y = y(rang);
            if isa(yFilterFunPtr,'function_handle')
                [y,yUp,yDown]= yFilterFunPtr(y,yUp,yDown);
            end
            if strcmp(errorType,'none')
                fh.plotHandle(plotCount,i) = plot(x,y...
                    ,'color',getPlotColor(plotCount)...
                    ,'Marker',plotMarker...
                    ,'LineStyle',plotLineStyle);
            else
                [fh.plotHandle(plotCount,i),fh.errFillHandle(plotCount,i)] = plotWithError(x,y,yUp,yDown...
                    ,'color',plotColor...
                    ,'Marker',plotMarker...
                    ,'LineStyle',plotLineStyle);
            end
        end
    end
    xlim([2,11]);
    if ~isempty(legendLabels)
        fh.legend = legend(fh.plotHandle,legendLabels,0);
    end
    set(gca,'Position',[0.13 0.18 0.79 0.65]);
    fh.textboxTopAxixTitle = annotation('textbox',...
        [0.48 0.885 0.0998 0.0912],...
        'String','测点',...
        'FaceAlpha',0,...
        'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
    fh.textarrow = annotation('textarrow',[0.38 0.33],...
        [0.744 0.665],'String',{'缓冲罐'},'FontName',paperFontName(),'FontSize',paperFontSize());
    fh.vesselFillHandle = plotVesselRegion(gca,constExpVesselRangDistance());
    ax = axis;
    % 绘制测点线
    yLabel2Detal = (ax(4) - ax(3))/12;
    for i = 1:length(x)
        fh.measurementGridLine(i) = plot([x(i),x(i)],[ax(3),ax(4)],':','color',[160,160,160]./255);
        if 0 == mod(i,2)
            continue;
        end
        if x(i) < 10
            fh.measurementText(i) = text(x(i)-0.15,ax(4)+yLabel2Detal,sprintf('%d',i),'FontName',paperFontName(),'FontSize',paperFontSize());
        else
            fh.measurementText(i) = text(x(i)-0.3,ax(4)+yLabel2Detal,sprintf('%d',i),'FontName',paperFontName(),'FontSize',paperFontSize());           
        end
    end
    xlabel('管线距离(m)');
    ylabel('倍频幅值(kPa)');
end
