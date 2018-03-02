function fh = figureExpPressurePlusAndSuppressionRate(dataCells,varargin)
%����ʵ�����ݵ�ѹ��������������ͼ
% dataCombineStruct �������һ��dataCombineStruct�ͻ���һ��ͼ�����Ҫ���ƶ��������һ��dataCombineStructCells
% varargin��ѡ���ԣ�
% errortype:'std':���������Ǳ�׼�'ci'����������95%�������䣬'minmax'����������min��max�������䣬��none������������
% rang������㷶Χ��Ĭ��Ϊ1:13,���Ǹı���˳�򣬷�����Ҫ���
% showpurevessel�����Ƿ���ʾ��һ����ޡ�
    pp = varargin;
    errorType = 'ci';
    errorPlotType = 'bar';
    rang = 1:13;
    showPureVessel = 0;
    showVesselRegion = true;
    pureVesselLegend = '����';
    showVesselTextArrow = false;
    showMeasurePoint = 1;
    legendLabels = {};
    figureHeight = 6;
    y2lim = [-20,120];
    yFilterFunPtr = {};
    yPlusFilterFunPtr = {};
    expVesselRang = constExpVesselRangDistance();
    %��������İѵ�һ��varargin��Ϊlegend
    if 0 ~= mod(length(pp),2)
        legendLabels = pp{1};
        pp=pp(2:end);
    end
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
            case 'purevessellegend'
                pureVesselLegend = val;
            case 'expvesselrang'
                expVesselRang = val;
            case 'errorplottype'
                errorPlotType =val;
            case 'showvesselregion'
                showVesselRegion = val;
            case 'figureheight'
                figureHeight = val;
            case 'showmeasurepoint'
                showMeasurePoint = val;
            case 'showvesseltextarrow'
                showVesselTextArrow = val;
            case 'y2lim'
                y2lim = val;
            case 'yfilterfunptr'
                yFilterFunPtr = val;
            case 'yplusfilterfunptr'
                yPlusFilterFunPtr = val;
            otherwise
                error('��������%s',prop);
        end
    end

    fh.gcf = figure();
    paperFigureSet('full',figureHeight);

    subplot(1,2,1)
    if showVesselRegion && ~showVesselTextArrow
        tmpShowVesselRegion = false;
    elseif showVesselRegion && showVesselTextArrow
        tmpShowVesselRegion = true;
    else
        tmpShowVesselRegion = false;
    end
    fh.ax1 = figureExpPressurePlus(dataCells,legendLabels...
        ,'errorType',errorType...
        ,'rang',rang...
        ,'showPureVessel',showPureVessel...
        ,'purevessellegend',pureVesselLegend...
        ,'showVesselRegion',tmpShowVesselRegion...
        ,'errorPlotType',errorPlotType...
        ,'showMeasurePoint',showMeasurePoint...
        ,'isFigure',false...
        ,'yFilterFunPtr',yPlusFilterFunPtr...
        );
    if showVesselRegion
        plotVesselRegion(gca,expVesselRang);
    end
    box on;
    set(gca,'color','none');
    set(gca,'Position',[0.13 0.181 0.335 0.64]);
    set(fh.ax1.textboxMeasurePoint,'Position',[0.271887125220459 0.898 0.0997999999999999 0.0911999999999999]);
%     set(fh.ax1.legend,'Position',[0.132503917327984 0.515200245777881 0.162257493698618 0.298465821866045]);

    subplot(1,2,2)
    set(gca,'Position',[0.61 0.181 0.335 0.64]);  
    if showVesselRegion && ~showVesselTextArrow
        tmpShowVesselRegion = false;
    elseif showVesselRegion && showVesselTextArrow
        tmpShowVesselRegion = true;
    else
        tmpShowVesselRegion = false;
    end
    fh.ax2 = figureExpSuppressionLevel(dataCells,legendLabels...
        ,'rang',rang...
        ,'ylim',y2lim...
        ,'errorType',errorType...
        ,'showVesselRegion',tmpShowVesselRegion...
        ,'errorPlotType',errorPlotType...
        ,'showMeasurePoint',showMeasurePoint...
        ,'yfilterfunptr',yFilterFunPtr...
        ,'isFigure',false ...
    );
    if showVesselRegion
        plotVesselRegion(gca,expVesselRang);
    end
    set(fh.ax2.textboxMeasurePoint,'Position',[0.749875 0.898 0.0997999999999999 0.0912000000000004]);
%     set(fh.ax2.legend,'Position',[0.611070766347012 0.578688105929006 0.156986109376367 0.241064808506657]);
    set(gca,'color','none');
    box on;
end



