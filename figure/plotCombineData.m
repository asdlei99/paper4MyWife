function fh = plotCombineData(dataCombineStruct,dataField,varargin)
%绘制CombineStruct的图
% dataCombineStruct 传入一个dataCombineStruct
% dataField 要绘制的filed
% varargin可选属性：
% errortype:'std':上下误差带是标准差，'ci'上下误差带是95%置信区间，'minmax'上下误差带是min和max置信区间，‘none’不绘制误差带
% rang：‘测点范围’默认为1:13,除非改变测点顺序，否则不需要变更
% showpurevessel：‘是否显示单一缓冲罐’
    pp = varargin;
    errorType = 'ci';
    rang = 1:13;
    legendLabels = {};
    isFigure = 0;
    otherProp = {};%其他的属性，用于传递给plot
    x = constExpMeasurementPointDistance();%测点对应的距离
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
            case 'isfigure'
                isFigure = val;
            case 'x'
                x = val;
            otherwise
                otherProp{length(otherProp)+1} = prop;
                otherProp{length(otherProp)+1} = val;
        end
    end
    if isFigure
        fh.gcf = figure();
        paperFigureSet_normal();
    end
    if iscell(dataField)
        if length(dataField) == 1
            [y,stdVal,maxVal,minVal,muci] = getExpCombineData(dataCombineStruct,dataField{1});
        elseif length(dataField) == 2
            [y,stdVal,maxVal,minVal,muci] = getExpCombineData(dataCombineStruct,dataField{2},dataField{1});
        end
    else
        [y,stdVal,maxVal,minVal,muci] = getExpCombineData(dataCombineStruct,dataField);
    end
    if isnan(y)
        error('没有获取到数据，请确保数据进行过人工脉动读取');
    end
    y = y(rang);
    if strcmp(errorType,'std')
        yUp = y + stdVal(rang);
        yDown = y - stdVal(rang);
    elseif strcmp(errorType,'ci')
        yUp = muci(2,rang);
        yDown = muci(1,rang);
    elseif strcmp(errorType,'minmax')
        yUp = maxVal(rang);
        yDown = minVal(rang);
    end
    if strcmp(errorType,'none')
        fh.plotHandle = plot(x,y,otherProp{:});
    else
        [fh.plotHandle(plotCount),fh.errFillHandle(plotCount)] = plotWithError(x,y,yUp,yDown,otherProp{:});
    end


    
end




