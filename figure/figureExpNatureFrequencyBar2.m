function fh = figureExpNatureFrequencyBar2(dataCombineStructCell,natureFres,varargin)
%����ʵ�����ݵ�ѹ������Ƶ�ԱȰ�ͼ
pp = varargin;
errorType = 'ci';%����������ģʽ��std��mean+-sd,ciΪ95%�������䣬minmaxΪ�����С
rang = 1:13;
legendLabels = {};
baseField = 'rawData';
figureHeight = 6;
isFigure = false;
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
        case 'isfigure'
            isFigure = val;
        otherwise
       		error('��������%s',prop);
    end
end

if isFigure
    fh.figure = figure;
    paperFigureSet('normal',figureHeight);
end
%��Ҫ��ʾ��һ�����
ys = [];
errUp = [];
errDown = [];
for i = 1:length(natureFres)
    [y,stdVal,maxVal,minVal,muci] = getExpCombineNatureFrequencyDatas(dataCombineStructCell,natureFres(i),baseField);
    ys(i,:) = y(rang);
    if strcmp(errorType,'std')
        errUp(i,:) = stdVal(rang);
        errUp(i,:) = stdVal(rang);
    elseif strcmp(errorType,'minmax')
        errUp(i,:) = maxVal(2,rang) - y(rang);
        errUp(i,:) = y(rang) - minVal(1,rang);
    else
        errUp(i,:) = muci(2,rang) - y(rang);
        errDown(i,:) = y(rang) - muci(1,rang);
    end
end
ys = ys';
err(:,:,2) = errUp';
err(:,:,1) = errDown';
fh.barHandle = barwitherr(err,ys);

% for i=1:length(fh.barHandle) %h = fh.barHandle
%     set(fh.barHandle(i),'FaceColor',getPlotColor(i));
%     set(fh.barHandle(i),'LineWidth',1);
%     set(fh.barHandle(i),'FaceAlpha',0.8);
%     set(fh.barHandle(i),'EdgeColor',getPlotColor(i));
% end

if ~isempty(legendLabels)
    fh.legend = legend(fh.barHandle,legendLabels,'FontName',paperFontName(),'FontSize',paperFontSize());
end

xlabel('���','FontName',paperFontName(),'FontSize',paperFontSize());
ylabel('��ֵ(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
fh.gca = gca;
end


