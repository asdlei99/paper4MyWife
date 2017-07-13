function [ curHancle,fillHandle,vesselFillHandle] = figureExpPressurePlus(dataCombineStruct,varargin)
%����ʵ�����ݵ�ѹ��������������ͼ
% varargin��ѡ���ԣ�
% errortype:'std':���������Ǳ�׼�'ci'����������95%�������䣬'minmax'����������min��max�������䣬��none������������
% rang������㷶Χ��Ĭ��Ϊ1:13,���Ǹı���˳�򣬷�����Ҫ���
% showpurevessel�����Ƿ���ʾ��һ����ޡ�
pp = varargin;
errorType = 'ci';
rang = 1:13;
showPureVessel = 0;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'errortype' %����������
        	errorType = val;
        case 'rang'
            rang = val;
        case 'showpurevessel'
            showPureVessel = val;
        otherwise
       		error('��������%s',prop);
    end
end
figure
paperFigureSet_normal();
[y,stdVal,maxVal,minVal,muci] = getExpCombineReadedPlusData(dataCombineStruct);
if isnan(y)
    error('û�л�ȡ�����ݣ���ȷ�����ݽ��й��˹�������ȡ');
end
x = constExpMeasurementPointDistance();%����Ӧ�ľ���
y = y(rang);
%��Ҫ��ʾ��һ�����
if showPureVessel
    meanVessel = constExpVesselPressrePlus(420);
    plot(x,meanVessel(rang),'LineStyle',':','color',[160,162,162]./255);
    hold on;
end
if strcmp(errorType,'std')
    yUp = y + stdVal(rang);
    yDown = y - stdVal(rang);
elseif strcmp(errorType,'ci')
    yUp = muci(2,rang);
    yDown = muci(1,rang);
elseif strcmp(errorType,'minmax')
    yUp = maxVal(rang);
    yDown = minVal(rang);
end

if strcmp(errorType,'none')
    [curHancle,fillHandle] = plot(x,y,'color',getPlotColor(1));
else
    [curHancle,fillHandle] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(1));
end
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
yLabel2Detal = (ax(4) - ax(3))/12;
% ���Ʋ����
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
ylabel('�������ֵ(kPa)');

end

