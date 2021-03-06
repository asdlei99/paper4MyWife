function paperPlotSingleVesselTheIteBiasLengthAndAspectRatio(param,massFlowData,isSaveFigure)
%����ƫ�þ���ͳ�����

% 	chartType = 'surf';
    chartType = 'contourf';
     
    endIndex = length(param.sectionL1) + length(param.sectionL2);
%     startIndex = find(param.sectionL1>2);
%     startIndex = startIndex(1);
    startIndex = 1;
    indexs = [startIndex,endIndex];%[1,endIndex];
%     indexs = 1:7:endIndex;
%     if indexs(end) ~= endIndex
%         indexs = [indexs,endIndex];
%     end
    Lv = linspace(0.3,3,42);
    lv1 = linspace(param.Dpipe,param.Lv-param.Dpipe,32);
    vType = 'straightInBiasOut';
%     vType = 'BiasFontInStraightOut';

    [X,Y,Zc] = oneVesselChangBiasLengthAndAspectRatio(lv1,Lv,indexs...
        ,'vType',vType...
        ,'massflowdata',massFlowData...
        ,'param',param);
    
    if 1
    for i = 1:length(Zc)
        Z = Zc{i}./1000;
        figure
        paperFigureSet('small',6);
        if strcmpi(chartType,'surf')
            surf(X,Y,Z);
            view(131,29);
        else

			[C,h] = contourfSmooth(X,Y,Z);
			set(h{2},'LabelSpacing',320,'LevelStep',0.3);
        end
        colormap jet;
        xlabel('ƫ�þ���(m)','FontSize',paperFontSize());%l1����lv1
        ylabel('������','FontSize',paperFontSize());
        zlabel('ѹ���������ֵ(kPa)','FontSize',paperFontSize());
		
        ch = colorbar();
		set(gca,'Position',[0.154537671232877 0.197638888888889 0.605279680365297 0.727361111111111]);
		set(ch,'Position',[0.777939497716895 0.2043 0.0253710045662108 0.7111]);
		axis tight;
		
        % set(get(ch,'Label'),'String','ѹ���������ֵ(kPa)','FontSize',paperFontSize(),'FontName',paperFontName());
		box on;
		if isSaveFigure
			set(gca,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('ֱ����������-�����Ⱥ�ƫ�þ��������ͼ(%g)',X(1,indexs(i))));
        end
    end
    end
    
    figure
    paperFigureSet('small',6);
    Z = (Zc{1} ./ Zc{end});
    Z = 20 .* log10(Z);
    if strcmpi(chartType,'surf')
        surf(X,Y,Z);
        view(131,29);
    else
        [C,h] = contourfSmooth(X,Y,Z);
        %set(h{2},'LabelSpacing',320,'LevelStep',0.3);
    end
    colormap jet;
    ch = colorbar();
    set(gca,'Position',[0.154537671232877 0.197638888888889 0.605279680365297 0.727361111111111]);
    set(ch,'Position',[0.777939497716895 0.2043 0.0253710045662108 0.7111]);
    axis tight;
    xlabel('ƫ�þ���(m)','FontSize',paperFontSize());%l1����lv1
    ylabel('������','FontSize',paperFontSize());
    if isSaveFigure
        set(gca,'color','none');
        saveFigure(fullfile(getPlotOutputPath(),'ch05'),'����ѹ�����ֵ��');
    end
end
