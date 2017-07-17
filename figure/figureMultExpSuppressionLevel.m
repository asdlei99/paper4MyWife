function [ curHancle,fillHandle,vesselFillHandle] = figureMultExpSuppressionLevel(dataCombineStructCells,legendLabels,varargin)
%����ʵ�����ݵ�ѹ��������������ͼ
pp = varargin;
errorType = 'ci';%����������ģʽ��std��mean+-sd,ciΪ95%�������䣬minmaxΪ�����С
rang = 1:13;
yFilterFunPtr = @fixY;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'errortype' %����������
        	errorType = val;
        case 'rang'
            rang = val;
        case 'yfilterfunptr'
            yFilterFunPtr = val;
        otherwise
       		error('��������%s',prop);
    end
end


figure
paperFigureSet_normal();
x = constExpMeasurementPointDistance();%����Ӧ�ľ���

for plotCount = 1:length(dataCombineStructCells)
    [y,stdVal,maxVal,minVal,muci] = getExpCombineReadSuppressionLevelData(dataCombineStructCells{plotCount});
    if isnan(y)
        error('������δ�н�����ȫ�ķ�����û������������');
    end
    y = y(rang).*100;

    if strcmp(errorType,'std')
        yUp = y + stdVal(rang).* 100;
        yDown = y - stdVal(rang).* 100;
    elseif strcmp(errorType,'ci')
        yUp = muci(2,rang).* 100;
        yDown = muci(1,rang).* 100;
    elseif strcmp(errorType,'minmax')
        yUp = maxVal(rang).* 100;
        yDown = minVal(rang).* 100;
    end
    if isa(yFilterFunPtr,'function_handle')
        [y,yUp,yDown]= yFilterFunPtr(y,yUp,yDown);
    end

    if strcmp(errorType,'none')
        [curHancle(plotCount)] = plot(x,y,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    else
        [curHancle(plotCount),fillHandle(plotCount)] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(plotCount)...
            ,'Marker',getMarkStyle(plotCount));
    end
end
xlim([2,11]);
legend(curHancle,legendLabels,0);

set(gca,'Position',[0.13 0.18 0.79 0.65]);
annotation('textbox',...
    [0.48 0.885 0.0998 0.0912],...
    'String','���',...
    'FaceAlpha',0,...
    'EdgeColor','none','FontName',paperFontName(),'FontSize',paperFontSize());
annotation('textarrow',[0.38 0.33],...
    [0.744 0.665],'String',{'�����'},'FontName',paperFontName(),'FontSize',paperFontSize());
vesselFillHandle = plotVesselRegion(gca,constExpVesselRangDistance());
ax = axis;
% ���Ʋ����
yLabel2Detal = (ax(4) - ax(3))/12;
for i = 1:length(x)
    plot([x(i),x(i)],[ax(3),ax(4)],':','color',[160,160,160]./255);
    if 0 == mod(i,2)
        continue;
    end
    if x(i) < 10
        text(x(i)-0.15,ax(4)+yLabel2Detal,sprintf('%d',i),'FontName',paperFontName(),'FontSize',paperFontSize());
    else
        text(x(i)-0.3,ax(4)+yLabel2Detal,sprintf('%d',i),'FontName',paperFontName(),'FontSize',paperFontSize());           
    end
end
xlabel('���߾���(m)');
ylabel('����������(%)');

end