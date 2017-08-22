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
Y = nan;%如果Y赋??，将会以3d形式绘制
sectionY = nan;
markSectionY = 'none';% 是否对切片的y值进行标记，标记可选'none'-不标记,'markLine'-在图上以线的形式标记,'shadow'-投影到x,z面上
markSectionYLabel = {};
sectionX = nan;
markSectionX = 'none';% 是否对切片的x值进行标记，标记可选'none'-不标记,'markLine'-在图上以线的形式标记,'shadow'-投影到x,z面上
markSectionXLabel = {};
% fh = nan;
fixAxis = 0;
edgeColor = 'none';
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
        otherwise
       		error('参数错误%s',prop);
    end
end

figure
paperFigureSet_normal();
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

    xlabel('管线距离(m)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel('脉动峰峰值(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
    fh.plotHandle = plotHandle;
    fh.legendHandle = legHandle;
else
    if strcmp(chartType,'plot3')
        fh = figurePlotPlot3(dataCells,X,Y,sectionY,markSectionY,sectionX,markSectionX);
    elseif strcmp(chartType,'surf')
        fh = figurePlotSurf(dataCells,X,Y,edgeColor...
            ,sectionY,markSectionY,markSectionYLabel...
            ,sectionX,markSectionX,markSectionXLabel...
            ,fixAxis...
            );
    end
    xlabel('管线距离(m)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel(yLabelText,'FontName',paperFontName(),'FontSize',paperFontSize());
    zlabel('脉动峰峰值(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
    box on;
    grid on;
    
        
    
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
    maxLengthX = 0;
    hold on;
    for i = 1:length(dataCells)
        z(i,:) = dataCells{i}.pulsationValue;
        if size(X,1) > 1
            x = X{i};
        else
            if iscell(X)
                x(i,:) = X{1};
            else
                x(i,:) = X;
            end
        end
        if(length(x) > maxLengthX )
            maxLengthX = length(x);
        end
    end
    z = z ./ 1000;
    x = zeros(length(dataCells),maxLengthX);
    x(:) = nan;
    y = x;
    for i = 1:length(dataCells)
        if size(X,1) > 1
            x(i,:) = X{i};
        else
            if iscell(X)
                x(i,:) = X{1};
            else
                x(i,:) = X;
            end
        end
        y(i,:) = Y(i);
    end
    fh.plotHandle = surf(x,y,z);
    if fixAxis
        xlim([x(1,1),x(1,end)]);
        ylim([y(1,1),y(end,1)]);
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

