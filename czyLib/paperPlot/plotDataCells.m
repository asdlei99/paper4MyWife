function [ h ] = plotDataCells( dataCells,varargin)
%���ƶ���Ա�����
%   dataCells Ϊ���ݵ����ݣ�Ĭ��dataCells��һ��Ϊ����X����2��Ϊ����Y����3��Ϊ���ݵ�������������ͨ�����Ը���
%   'xcol' ָ��x����
%   'ycol' ָ��y����
%   'legendcol' ָ���������У�������������Ҫ��������'legendcol',nan
xCol = 1;
yCol = 2;
legendCol = 3;
ignoreHeader = 0;
while length(varargin)>=2
    prop =varargin{1};
    val=varargin{2};
    varargin=varargin(3:end);
    switch lower(prop)
        case 'xcol' %�Ƿ�����0
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

