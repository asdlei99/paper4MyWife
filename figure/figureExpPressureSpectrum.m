function [fh,spectrogramData] = figureExpPressureSpectrum(dataCells,varargin)
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
%��������İѵ�һ��varargin��Ϊlegend
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
        case 'datacellnum'
            dataCellNum = val;
        otherwise
       		varargin{length(varargin)+1} = prop;
            varargin{length(varargin)+1} = val;
    end
end

x = constExpMeasurementPointDistance();%����Ӧ�ľ���
count = 1;

fh.figure = figure;
paperFigureSet_normal();
for mp = meaPoint
    [fre,tmp] = getExpFreMagDatas(dataCells{dataCellNum,2},mp,baseField);
    mag(:,count) = tmp;
    [fh.plot3Handle(count),fh.plot3FillHandle(count)] = plotSpectrum3(fre,tmp,x(mp));
    count = count + 1;
end
%����ͼ��
xlabel('Ƶ��(Hz)','FontName',paperFontName(),'FontSize',paperFontSize()); 
ylabel('����(m)','FontName',paperFontName(),'FontSize',paperFontSize());
zlabel('��ֵ(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());




end

