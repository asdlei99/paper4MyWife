function fh = figureExpNatureFrequencyBar(dataCombineStructCells,natureFre,varargin)
%����ʵ�����ݵ�ѹ������Ƶ�ԱȰ�ͼ
pp = varargin;
errorType = 'ci';%����������ģʽ��std��mean+-sd,ciΪ95%�������䣬minmaxΪ�����С
rang = 1:13;
legendLabels = {};
baseField = 'rawData';
%��������İѵ�һ��varargin��Ϊlegend
if 0 ~= mod(length(pp),2)
    legendLabels = pp{1};
    pp=pp(2:end);
end
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'errortype' %����������
        	errorType = val;
        case 'rang'
            rang = val;
        case 'basefield'
            baseField = val;
        case 'legendLlabels'
            legendLabels = val;
        otherwise
       		error('��������%s',prop);
    end
end


fh.figure = figure;
paperFigureSet_normal();

%��Ҫ��ʾ��һ�����
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

xlabel('���');
ylabel('��ֵ(kPa)');

end


