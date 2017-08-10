function fh = figureTheoryPressurePlus(dataCells,X,varargin)
%����dataCells������ɵ�����ѹ��ֵ
% dataCellsΪdataStruct��ɵ�cell����ֻ����һ��dataStruct�����ƶ�άͼ
% X Ϊ��Ӧ��xֵ����dataCells��һ��cell��X��ӦҲ��һ��cell
% �ɱ��varargin��
% 'y':���Y��ֵ�����飩��������3d��ʽ���ƣ�������Զ�άͼ���ƶ������
% 'yLabelText':�����3d���ƣ���ֵ��Ϊy���label
% 'charttype':��ѡΪ'plot3'��'surf',��ֵͬʹ�ò�ͬ��������
% 'sectiony':ָ����yֵ������Ƭ����Ƭ����ͼ����ʾһ������
% 'markSectionY':���ڡ�sectiony����Чʱ���ã�ָ����Ƭ�����߱�Ƿ�ʽ
%                ��ѡ'none'-�����,'markLine'-��ͼ�����ߵ���ʽ���,'shadow'-ͶӰ��x,z����
% 'EdgeColor':����charttype=��surf����Ч��ָ��surf��EdgeColor����
pp = varargin;
legendLabels = {};
yLabelText = '';
Y = nan;%���Y��??��������3d��ʽ����
sectionY = nan;
fh = nan;
edgeColor = 'none';
markSectionY = 'none';% �Ƿ����Ƭ��yֵ���б�ǣ���ǿ�ѡ'none'-�����,'markLine'-��ͼ�����ߵ���ʽ���,'shadow'-ͶӰ��x,z����
%��������İѵ�һ��varargin��Ϊlegend
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
        case 'sectiony'%��һ��ָ����yֵ������Ƭ,�γ�һ�����棬ȡֵ����ȡ��ӽ���yֵ
            sectionY = val;
        case 'marksectiony'
            markSectionY = val;
        case 'edgecolor'
            edgeColor = val;
        otherwise
       		error('��������%s',prop);
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
            error('û�л�ȡ������');
        end

        [fh.plotHandle(i)] = plot(x,y,'color',getPlotColor(i)...
            ,'Marker',getMarkStyle(i));
    end
    if ~isempty(legendLabels)
        fh.legend = legend(fh.plotHandle,legendLabels,0);
    end

    xlabel('���߾���(m)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel('�������ֵ(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
else
    if strcmp(chartType,'plot3')
        fh = figurePlotPlot3(dataCells,X,Y,sectionY,markSectionY);
    elseif strcmp(chartType,'surf')
        fh = figurePlotSurf(dataCells,X,Y,edgeColor,sectionY,markSectionY);
    end
    xlabel('���߾���(m)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel(yLabelText,'FontName',paperFontName(),'FontSize',paperFontSize());
    zlabel('�������ֵ(kPa))','FontName',paperFontName(),'FontSize',paperFontSize());
    box on;
    grid on;
    
        
    
end

end

function fhRet = figurePlotPlot3(dataCells,X,Y)
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


function fh = figurePlotSurf(dataCells,X,Y,edgeColor,sectionY,markSectionY)
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
    if ~isnan(edgeColor)
        set(fh.plotHandle,'EdgeColor',edgeColor);
    end
    view(-24,58);
    if ~isnan(sectionY)
        for i = 1:length(sectionY)
            [val,index] = closeValue(Y,sectionY(i));
            if isnan(val)
                continue;
            end
            ax = axis();
            xf = [ax(1),ax(2),ax(2),ax(1),ax(1)];
            yf = ones(1,5).*val;
            zf = [ax(5),ax(5),ax(6),ax(6),ax(5)];
            fh.sectionYHandle(i) = fill3(xf,yf,zf,'r');
            set(fh.sectionYHandle(i),'FaceAlpha',0.1);
            set(fh.sectionYHandle(i),'EdgeColor','r','EdgeAlpha',0.6);
            xl = x(index,:);
            yl = y(index,:);
            zl = z(index,:);
            if strcmp(markSectionY,'all')
                plot3(xl,yl,zl,'-k');
            end
        end
    end
end

