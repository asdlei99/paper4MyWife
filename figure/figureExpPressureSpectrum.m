function fh = figureExpPressureSpectrum(dataCells,varargin)
%绘制实验数据的频谱图
% dataCells：dataStructCells下的具体测量的数据dataStructCells{n,2}
% meaPoint:测点
% varargin可选属性：
% chartType：绘图类型，可选‘contour’（默认）或者‘plot3’
% baseField: 绘图数据类型，
pp = varargin;
varargin = {};
baseField = 'rawData';
meaPoint = 1:13;%显示的测点
figureHeight = 10;
chartType = 'plot3';
dataCellNum = 1;%define which row of dataCells should be plot,this val can set to 1~5
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'figureheight'
            figureHeight = val;
        case 'basefield'
            baseField = val;
        case 'charttype'
            chartType = val;
        case 'datacellnum'
            dataCellNum = val;
        otherwise
       		varargin{length(varargin)+1} = prop;
            varargin{length(varargin)+1} = val;
    end
end

x = constExpMeasurementPointDistance();%测点对应的距离
fh.figure = figure;
paperFigureSet_normal(figureHeight);
[fre,mag] = getExpFreMagDatas(dataCells,dataCellNum,baseField);
count = 1;
hold on;
for i = meaPoint
    [h,f] = plotSpectrum3(fre(:,1),mag(:,i),x(i));
    fh.plotHandle(count).plot = h;
    fh.plotHandle(count).fill = f;
    count = count + 1;
end
box on;
%绘制图形
xlabel('频率(Hz)','FontName',paperFontName(),'FontSize',paperFontSize()); 
ylabel('距离(m)','FontName',paperFontName(),'FontSize',paperFontSize());
zlabel('幅值(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
view(65,36);




end

