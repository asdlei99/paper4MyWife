function fh = figureTheoryPressurePlus(dataCells,X,varargin)
%����dataCells������ɵ�����ѹ��ֵ
% dataCellsΪdataStruct��ɵ�cell����ֻ����һ��dataStruct�����ƶ�άͼ
% X Ϊ��Ӧ��xֵ����dataCells��һ��cell��X��ӦҲ��һ��cell
% �ɱ��varargin��
% 'y':���Y��ֵ�����飩��������3d��ʽ���ƣ�������Զ�άͼ���ƶ������
% 'yLabelText':�����3d���ƣ���ֵ��Ϊy���label
% 'chartType':��ѡΪ'plot3'��'surf',��ֵͬʹ�ò�ͬ��������
% 'sectionY':ָ����yֵ������Ƭ����Ƭ����ͼ����ʾһ������
% 'markSectionY':���ڡ�sectionY����Чʱ���ã�ָ����Ƭ�����߱�Ƿ�ʽ
%                ��ѡ'none'-�����,'markLine'-��ͼ�����ߵ���ʽ���,'shadow'-ͶӰ��x,z����
% 'markSectionYLabel':������Ķ�������ʾ��������
% 'sectionX':ָ����xֵ������Ƭ����Ƭ����ͼ����ʾһ������
% 'markSectionX':���ڡ�sectionX����Чʱ���ã�ָ����Ƭ�����߱�Ƿ�ʽ
%                ��ѡ'none'-�����,'markLine'-��ͼ�����ߵ���ʽ���,'shadow'-ͶӰ��x,z����
% 'markSectionXLabel':������Ķ�������ʾ��������
% 'EdgeColor':����charttype=��surf����Ч��ָ��surf��EdgeColor����
% 'fixAxis': �����������������ģʽ�����surf����nan��������ʹ��
pp = varargin;
legendLabels = {};
yLabelText = '';
Y = nan;%���Y��??��������3d��ʽ����
sectionY = nan;
markSectionY = 'none';% �Ƿ����Ƭ��yֵ���б�ǣ���ǿ�ѡ'none'-�����,'markLine'-��ͼ�����ߵ���ʽ���,'shadow'-ͶӰ��x,z����
markSectionYLabel = {};
sectionX = nan;
markSectionX = 'none';% �Ƿ����Ƭ��xֵ���б�ǣ���ǿ�ѡ'none'-�����,'markLine'-��ͼ�����ߵ���ʽ���,'shadow'-ͶӰ��x,z����
markSectionXLabel = {};
% fh = nan;
fixAxis = 0;
edgeColor = 'none';
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
        case 'marksectionylabel'
            markSectionYLabel = val;
        case 'sectionx'%��һ��ָ����yֵ������Ƭ,�γ�һ�����棬ȡֵ����ȡ��ӽ���yֵ
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

        plotHandle(i) = plot(x,y,'color',getPlotColor(i)...
            ,'Marker',getMarkStyle(i));
        
    end
    if ~isempty(legendLabels)
        legHandle = legend(plotHandle,legendLabels,0);
    end

    xlabel('���߾���(m)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel('�������ֵ(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
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
    xlabel('���߾���(m)','FontName',paperFontName(),'FontSize',paperFontSize());
    ylabel(yLabelText,'FontName',paperFontName(),'FontSize',paperFontSize());
    zlabel('�������ֵ(kPa)','FontName',paperFontName(),'FontSize',paperFontSize());
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

