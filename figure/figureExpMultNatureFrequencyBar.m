function fh = figureExpMultNatureFrequencyBar(dataCombineStructCells,natureFre,varargin)
%����ʵ�����ݵ�ѹ������Ƶ�ԱȰ�ͼ
pp = varargin;
errorType = 'ci';%����������ģʽ��std��mean+-sd,ciΪ95%�������䣬minmaxΪ�����С
rang = 1:13;
legendLabels = {};
baseField = 'rawData';
figureHeight = 6;
%natureFre = 1;%0.5���ư뱶Ƶ
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
        case 'legendlabels'
            legendLabels = val;
        case 'figureheight'
            figureHeight = val;
        otherwise
       		error('��������%s',prop);
    end
end


fh.figure = figure;
paperFigureSet_normal(figureHeight);

%��Ҫ��ʾ��һ�����
ys = [];
errUp = [];
errDown = [];
tf1 = 1;
tf2 = 2;
tf3 = 3;
if 0.5 == natureFre
    tf1 = 0.5;
    tf2 = 1.5;
    tf3 = 2.5;
end
[y{1},stdVal{1},maxVal{1},minVal{1},muci{1}] = getExpCombineNatureFrequencyDatas(dataCombineStructCells,tf1,baseField);
[y{2},stdVal{2},maxVal{2},minVal{2},muci{2}] = getExpCombineNatureFrequencyDatas(dataCombineStructCells,tf2,baseField);
[y{3},stdVal{3},maxVal{3},minVal{3},muci{3}] = getExpCombineNatureFrequencyDatas(dataCombineStructCells,tf3,baseField);
for i=1:3
    ys(i,:) = y{i}(rang);
    if strcmp(errorType,'std')
        errUp(i,:) = stdVal{i}(rang);
        errUp(i,:) = stdVal{i}(rang);
    elseif strcmp(errorType,'minmax')
        errUp(i,:) = maxVal{i}(2,rang) - y{i}(rang);
        errUp(i,:) = y{i}(rang) - minVal{i}(1,rang);
    else
        errUp(i,:) = muci{i}(2,rang) - y{i}(rang);
        errDown(i,:) = y{i}(rang) - muci{i}(1,rang);
    end
end
ys = ys';
err(:,:,2) = errUp';
err(:,:,1) = errDown';
fh.barHandle = barwitherr(err,ys);
xlabel('���','FontName',paperFontName(),'FontSize',paperFontSize());
ylabel('��ֵ(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
if ~isempty(legendLabels)
    fh.legend = legend(legendLabels,'FontName',paperFontName(),'FontSize',paperFontSize());
end
fh.gca = gca;

end


