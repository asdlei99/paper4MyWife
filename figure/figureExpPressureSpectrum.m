function [fh,spectrogramData] = figureExpPressureSpectrum(dataCells,varargin)
%绘制实验数据的频谱图
% dataCells：dataStructCells下的具体测量的数据dataStructCells{n,2}
% meaPoint:测点
% varargin可�?属�?�?
% chartType：绘图类型，可�?‘contour’（默认）或者�?plot3�?
% baseField: 绘图数据类型�?
pp = varargin;
varargin = {};
baseField = 'rawData';
meaPoint = 1:13;%显示的测�?
figureHeight = 10;
chartType = 'plot3';

%允许特殊的把地一个varargin作为legend
legendLabels = {};
if 0 ~= mod(length(pp),2)
    legendLabels = pp{1};
    pp=pp(2:end);
end
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'figureheight'
            figureHeight = val;
        case 'basefield'
            baseField = val;
        case 'chartType'
            chartType = val;
        otherwise
       		varargin{length(varargin)+1} = prop;
            varargin{length(varargin)+1} = val;
    end
end

x = constExpMeasurementPointDistance();%测点对应的距�?
count = 1;
for i = 1:length(dataCells)
    fh.figure(i) = figure;
    paperFigureSet_normal();
    for mp = meaPoint
        if(1 == length(dataCells))
            [fre,tmp] = getExpFreMagDatas(dataCells,mp,baseField);
        else
            [fre,tmp] = getExpFreMagDatas(dataCells{i},mp,baseField);
        end
        mag(:,count) = tmp;
        [fh.plot3Handle(count),fh.plot3FillHandle(count)] = plotSpectrum3(fre,tmp,x(mp));
        count = count + 1;
    end
    %绘制图形
    xlabel('频率(Hz)','FontName',paperFontName(),'FontSize',paperFontSize()); 
    ylabel('距离(m)','FontName',paperFontName(),'FontSize',paperFontSize());
    zlabel('幅�?(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
end



end

