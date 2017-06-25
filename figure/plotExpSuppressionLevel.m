function [ curHancle,fillHandle,vesselFillHandle] = plotExpSuppressionLevel(dataCombineStruct,varargin)
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
[y,stdVal,maxVal,minVal,muci] = getExpCombineReadSuppressionLevelData(dataCombineStruct);
if isnan(y)
    error('������δ�н�����ȫ�ķ�����û������������');
end
figure
paperFigureSet_normal();
x = constExpMeasurementPointDistance();%����Ӧ�ľ���
y = y(rang).*100;
muci = muci.*100;
stdVal = stdVal .* 100;
maxVal = maxVal .* 100;
minVal = minVal .* 100;

if strcmp(errorType,'std')
    yUp = y + stdVal(rang);
    yDown = y - stdVal(rang);
elseif strcmp(errorType,'ci')
    yUp = muci(2,rang);
    yDown = muci(1,rang);
else
    yUp = maxVal(rang);
    yDown = minVal(rang);
end
if isa(yFilterFunPtr,'function_handle')
    [y,yUp,yDown]= yFilterFunPtr(y,yUp,yDown);
end
[curHancle,fillHandle] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(1));
xlim([2,11]);

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
