function fh = figureExpNatureFrequencyBar(dataCombineStructCells,natureFre,varargin)
%绘制实验数据的压力波倍频对比棒图
pp = varargin;
errorType = 'ci';%绘制误差带的模式，std：mean+-sd,ci为95%置信区间，minmax为最大最小
rang = 1:13;
legendLabels = {};
baseField = 'rawData';
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
        case 'basefield'
            baseField = val;
        case 'legendLlabels'
            legendLabels = val;
        otherwise
       		error('参数错误%s',prop);
    end
end


fh.figure = figure;
paperFigureSet_normal();

%需要显示单一缓冲罐
ys = [];
errUp = [];
errDown = [];
for i = 1:length(dataCombineStructCells)
    if 1==length(dataCombineStructCells)
        [y,stdVal,maxVal,minVal,muci] = getExpCombineNatureFrequencyDatas(dataCombineStructCells,natureFre,baseField);
    else
        [y,stdVal,maxVal,minVal,muci] = getExpCombineNatureFrequencyDatas(dataCombineStructCells{i},natureFre,baseField);
    end

    ys(i,:) = y(rang);

    
    if strcmp(errorType,'std')
        errUp(i,:) = stdVal(rang);
        errUp(i,:) = stdVal(rang);
    elseif strcmp(errorType,'minmax')
        errUp(i,:) = maxVal(2,rang) - y(rang);
        errUp(i,:) = y(rang) - minVal(1,rang);
    else strcmp(errorType,'ci')
        errUp(i,:) = muci(2,rang) - y(rang);
        errDown(i,:) = y(rang) - muci(1,rang);
    end
end
err(:,:,1) = errUp;
err(:,:,1) = errDown;
fh.barHandle = barwitherr(err,ys);


if ~isempty(legendLabels)
    fh.legend = legend(legendLabels);
end

xlabel('测点');
ylabel('幅值(kPa)');

end


