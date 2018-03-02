function paperPlotSingleVesselTheIteBiasLengthAndAspectRatio(param,massFlowData,isSaveFigure)
%迭代偏置距离和长径比

	 %chartType = 'surf';
    chartType = 'contourf';
     
    endIndex = length(param.sectionL1) + length(param.sectionL2);
    indexs = [1,endIndex];
%     indexs = 1:7:endIndex;
%     if indexs(end) ~= endIndex
%         indexs = [indexs,endIndex];
%     end
    Lv = linspace(0.3,3,42);
    lv1 = linspace(param.Dpipe,param.Lv-param.Dpipe,32);
    
    [X,Y,Zc] = oneVesselChangBiasLengthAndAspectRatio(lv1,Lv,indexs...
        ,'vType','straightInBiasOut'...
        ,'massflowdata',massFlowData...
        ,'param',param);
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
        xlabel('偏置距离(m)','FontSize',paperFontSize());%l1就是lv1
        ylabel('长径比','FontSize',paperFontSize());
        zlabel('压力脉动峰峰值(kPa)','FontSize',paperFontSize());
		
        ch = colorbar();
		set(gca,'Position',[0.154537671232877 0.197638888888889 0.605279680365297 0.727361111111111]);
		set(ch,'Position',[0.777939497716895 0.2043 0.0253710045662108 0.7111]);
		axis tight;
		
        % set(get(ch,'Label'),'String','压力脉动峰峰值(kPa)','FontSize',paperFontSize(),'FontName',paperFontName());
		box on;
		if isSaveFigure
			set(gca,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('直进侧出缓冲罐-长径比和偏置距离迭代云图(%g)',X(1,indexs(i))));
		end
	end
    
end
