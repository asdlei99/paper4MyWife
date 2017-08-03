function fh = figureExpPressureSpectrum(dataCells,varargin)
%����ʵ�����ݵ�Ƶ��ͼ
% dataCells��dataStructCells�µľ������������dataStructCells{n,2}
% meaPoint:���
% varargin��ѡ���ԣ�
% chartType����ͼ���ͣ���ѡ��contour����Ĭ�ϣ����ߡ�plot3��
% baseField: ��ͼ�������ͣ�
pp = varargin;
varargin = {};
baseField = 'rawData';
meaPoint = 1:13;%��ʾ�Ĳ��
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

x = constExpMeasurementPointDistance();%����Ӧ�ľ���
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
%����ͼ��
xlabel('Ƶ��(Hz)','FontName',paperFontName(),'FontSize',paperFontSize()); 
ylabel('����(m)','FontName',paperFontName(),'FontSize',paperFontSize());
zlabel('��ֵ(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
view(65,36);




end

