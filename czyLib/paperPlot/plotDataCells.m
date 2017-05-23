function [ h ] = plotDataCells( dataCells,varargin)
%绘制多组对比数据
%   dataCells 为数据的内容，默认dataCells第一列为数据X，第2列为数据Y，第3列为数据的描述，但可以通过属性更改
%   'xcol' 指定x的列
%   'ycol' 指定y的列
%   'legendcol' 指定描述的列，若无描述，需要单独设置'legendcol',nan
xCol = 1;
yCol = 2;
legendCol = 3;
ignoreHeader = 0;
while length(varargin)>=2
    prop =varargin{1};
    val=varargin{2};
    varargin=varargin(3:end);
    switch lower(prop)
        case 'xcol' %是否允许补0
            xCol = val;
        case 'ycol'
            yCol = val;
        case 'legendcol'
            legendCol = val;
        case 'ignoreheader'
            ignoreHeader = val;
    end
end
marker_style = {'-o','-d','-<','-s','->','-<','-p','-*','-v','-^','-+','-x','-h'};
color_style = [...
    245,18,103;...
    36,100,196;...
    18,175,134;...
    237,144,10;... 
    131,54,229;...
    
    255,99,56;...
    ]./255;
market_style_length = length(marker_style);
color_style_length = size(color_style,1);
marker_index = 0;
color_index = 0;


datasCount = size(dataCells,1);
datasCol = size(dataCells,2);
hold on;
count = 1;
for i = (1+ignoreHeader):datasCount
    marker_index = marker_index + 1;
    if marker_index > market_style_length
        marker_index = 1;
    end
    color_index = color_index + 1;
    if color_index > color_style_length
        color_index = 1;
    end
    x = dataCells{i,xCol};
    y = dataCells{i,yCol};
    if ~isempty(legendCol)
        textLegend{count} = dataCells{i,legendCol};
    end
    h(count) = plot(x,y,marker_style{marker_index},'color',color_style(color_index,:),'LineWidth',1.5);
    count = count + 1;
end

legend(h,textLegend,'Location','best');
set(gcf,'color','w');

end

