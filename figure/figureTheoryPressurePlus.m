function fh = figureTheoryPressurePlus(dataCells,X,varargin)
%绘制dataCells数据组成的脉动压力值
% dataCells为dataStruct组成的cell，若只输入一个dataStruct，绘制二维图
% X 为对应的x值，若dataCells是一个cell，X对应也是一个cell
% 可变参varargin：
% 'y':如果Y赋值（数组），将会以3d形式绘制，否则会以二维图绘制多个曲线
% 'yLabelText':如果以3d绘制，此值作为y轴的label
% 'chartType':可选为'plot3'，'surf',不同值使用不同函数绘制
% 'sectionY':指定对y值进行切片，切片会在图上显示一个切面
% 'markSectionY':仅在‘sectionY’生效时有用，指定切片的曲线标记方式
%                可选'none'-不标记,'markLine'-在图上以线的形式标记,'shadow'-投影到x,z面上
% 'markSectionYLabel':在切面的顶部角显示文字内容
% 'sectionX':指定对x值进行切片，切片会在图上显示一个切面
% 'markSectionX':仅在‘sectionX’生效时有用，指定切片的曲线标记方式
%                可选'none'-不标记,'markLine'-在图上以线的形式标记,'shadow'-投影到x,z面上
% 'markSectionXLabel':在切面的顶部角显示文字内容
% 'EdgeColor':仅在charttype=‘surf’生效，指定surf的EdgeColor属性
% 'fixAxis': 坐标轴限制在最紧凑模式，如果surf含有nan，不建议使用
pp = varargin;
legendLabels = {};
yLabelText = '';
xLabelText = '管线距离(m)';
zLabelText = '脉动峰峰值(kPa)';
Y = nan;%如果Y赋??，将会以3d形式绘制
sectionY = nan;
markSectionY = 'none';% 是否对切片的y值进行标记，标记可选'none'-不标记,'markLine'-在图上以线的形式标记,'shadow'-投影到x,z面上
markSectionYLabel = {};
sectionX = nan;
markSectionX = 'none';% 是否对切片的x值进行标记，标记可选'none'-不标记,'markLine'-在图上以线的形式标记,'shadow'-投影到x,z面上
markSectionXLabel = {};
newFigure = 0;%是否调用figure，否则不会调用
% fh = nan;
fixAxis = 0;
edgeColor = 'none';
figureHeight = 6;%图片的高度，在newFigure == 1时生效
fontName = paperFontName();
%允许特殊的把地一个varargin作为legend
chartType = 'plot3';
if 0 ~= mod(length(pp),2)
    legendLabels = pp{1};
    pp=pp(2:end);
end
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'y'
            Y = val;
        case 'charttype'
            chartType = val;
        case 'ylabeltext'
            yLabelText = val;
        case 'xlabeltext'
            xLabelText = val;
        case 'zlabeltext'
            zLabelText = val;
        case 'sectiony'%对一个指定的y值进行切片,形成一个切面，取值将会取最接近的y值
            sectionY = val;
        case 'marksectiony'
            markSectionY = val;
        case 'marksectionylabel'
            markSectionYLabel = val;
        case 'sectionx'%对一个指定的y值进行切片,形成一个切面，取值将会取最接近的y值
            sectionX = val;
        case 'marksectionx'
            markSectionX = val;
        case 'marksectionxlabel'
            markSectionXLabel = val;
        case 'edgecolor'
            edgeColor = val;
        case 'fixaxis'
            fixAxis = val;
        case 'legendlabels'
            legendLabels = val;
        case 'newfigure'
            newFigure = val;
        case 'figureheight'
            figureHeight = val;
        case 'fontname'
            fontName = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
if newFigure
    fh.figure = figure;
    paperFigureSet_normal(figureHeight);
end
set(gca,'FontName',fontName,'FontSize',paperFontSize());
if isnan(Y)
    for i = 1:length(dataCells)
        if 2 == i
            hold on;
        end
        if(1 == length(dataCells))
            y = dataCells.pulsationValue;
        else
            y = dataCells{i}.pulsationValue;
        end
        y = y./1000;
        if size(X,1) > 1
            x = X{i};
        else
            if iscell(X)
                x(i,:) = X{1};
            else
                x(i,:) = X;
            end
        end
        if isnan(y)
            error('没有获取到数据');
        end

        plotHandle(i) = plot(x,y,'color',getPlotColor(i)...
            ,'Marker',getMarkStyle(i));
        
    end
    if ~isempty(legendLabels)
        legHandle = legend(plotHandle,legendLabels,0);
    end

    xlabel(xLabelText,'FontSize',paperFontSize());
    ylabel(zLabelText,'FontSize',paperFontSize());
    fh.plotHandle = plotHandle;
    fh.legendHandle = legHandle;
else
    if strcmp(chartType,'plot3')
        fh = figurePlotPlot3(dataCells,X,Y,sectionY,markSectionY,sectionX,markSectionX);
        box on;
    elseif strcmp(chartType,'surf')
        fh = figurePlotSurf(dataCells,X,Y,edgeColor...
            ,sectionY,markSectionY,markSectionYLabel...
            ,sectionX,markSectionX,markSectionXLabel...
            ,fixAxis...
            );
        box on;
        grid on;
    else
        fh =  figurePlotContourf(dataCells,X,Y,edgeColor...
            ,sectionY,markSectionY,markSectionYLabel...
            ,sectionX,markSectionX,markSectionXLabel...
            ,fixAxis,chartType...
            );
        box on;
    end
    xlabel(xLabelText,'FontSize',paperFontSize());
    ylabel(yLabelText,'FontSize',paperFontSize());
    zlabel(zLabelText,'FontSize',paperFontSize());
    fh.gca = gca;
    
        
    
end

end

function fhRet = figurePlotPlot3(dataCells,X,Y,sectionY,markSectionY,sectionX,markSectionX)
    hold on;
     for i = 1:length(dataCells)
        z = dataCells{i}.pulsationValue;
        z = z ./ 1000;
        if size(X,1) > 1
            x = X{i};
        else
            if iscell(X)
                x(i,:) = X{1};
            else
                x(i,:) = X;
            end
        end
        fhRet.plotHandle(i) = plot3(x,Y(i).*ones(length(x),1),z);
     end
end


function fh = figurePlotSurf(dataCells,X,Y,edgeColor...
    ,sectionY,markSectionY,markSectionYLabel...
    ,sectionX,markSectionX,markSectionXLabel...
    ,fixAxis...
    )
    hold on;
    maxLengthX = max(cellfun(@(x) size(x.pulsationValue,2),dataCells));
    z = zeros(length(dataCells),maxLengthX);
    z(:) = nan;
    x = z;
    y = z;
    for i = 1:length(dataCells)
        z(i,1:length(dataCells{i}.pulsationValue)) = dataCells{i}.pulsationValue;
        if size(X,1) > 1
            x(i,1:length(X{i})) = X{i};
        else
            if iscell(X)
                x(i,1:length(X{i})) = X{1};
            else
                x(i,1:length(X)) = X;
            end
        end
        y(i,:) = Y(i);
    end
    z = z ./ 1000;
    fh.plotHandle = surf(x,y,z);
    if fixAxis
        xlim([min(min(x)),max(max(x))]);
        ylim([min(min(y)),max(max(y))]);
    end
    if ~isnan(edgeColor)
        set(fh.plotHandle,'EdgeColor',edgeColor);
    end
    view(-24,58);
    if ~isnan(sectionY)
        fh.sectionYHandle = plotSectionXZ(x,y,z,sectionY...
                                    ,'marksection',markSectionY...
                                    ,'marksectionlabel',markSectionYLabel...
                                    );
    end
    if ~isnan(sectionX)
        fh.sectionXHandle = plotSectionYZ(x,y,z,sectionX...
                        ,'marksection',markSectionX...
                        ,'marksectionlabel',markSectionXLabel...
                        );
    end
end

function fh = figurePlotContourf(dataCells,X,Y,edgeColor...
    ,sectionY,markSectionY,markSectionYLabel...
    ,sectionX,markSectionX,markSectionXLabel...
    ,fixAxis,chartType...
    )
    hold on;
    maxLengthX = max(cellfun(@(x) size(x.pulsationValue,2),dataCells));
    z = zeros(length(dataCells),maxLengthX);
    z(:) = nan;
    x = z;
    y = z;
    for i = 1:length(dataCells)
        z(i,1:length(dataCells{i}.pulsationValue)) = dataCells{i}.pulsationValue;
        if size(X,1) > 1
            x(i,1:length(X{i})) = X{i};
        else
            if iscell(X)
                x(i,1:length(X{i})) = X{1};
            else
                x(i,1:length(X)) = X;
            end
        end
        y(i,:) = Y(i);
    end
    z = z ./ 1000;
    x = x(:,1:end-1);
    y = y(:,1:end-1);
    z = z(:,1:end-1);
    if strcmpi(chartType,'contourf')
        [tmp,fh.plotHandle] = contourf(x,y,z);
    elseif strcmpi(chartType,'contourc')
        [tmp,fh.plotHandle] = contour(x,y,z);
    elseif strcmpi(chartType,'contour3')
        [tmp,fh.plotHandle] = contour3(x,y,z);
    end
	clear tmp;
    if fixAxis
        xlim([x(1,1),x(1,end)]);
        ylim([y(1,1),y(end,1)]);
    end

end