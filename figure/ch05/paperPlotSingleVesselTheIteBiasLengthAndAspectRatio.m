function paperPlotSingleVesselTheIteBiasLengthAndAspectRatio(param,massFlowData,isSaveFigure)
%迭代偏置距离和长径比

	 %chartType = 'surf';
    chartType = 'contourf';
     
    endIndex = length(param.sectionL1) + length(param.sectionL2);
    indexs = 1:7:endIndex;
    if indexs(end) ~= endIndex
        indexs = [indexs,endIndex];
    end
    Lv = linspace(0.3,3,42);
    lv1 = linspace(0,param.Lv-param.Dpipe,32);
    
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
            [C,h] = contourf(X,Y,Z...
							,'ShowText','on'...
							,'LevelStep',0.2 ...
							,'TextStep',0.5 ...
							);
        end
        colormap jet;
        xlabel('偏置距离l1(m)','FontSize',paperFontSize());%l1就是lv1
        ylabel('长径比','FontSize',paperFontSize());
        zlabel('压力脉动峰峰值(kPa)','FontSize',paperFontSize());
		
        ch = colorbar();
		set(gca,'Position',[0.1811 0.2043 0.6242 0.7207]...
						  ,'XTick',[0:0.25:1]...
						  );
		set(ch,'Position',[0.8381 0.2043 0.02804 0.7111]);
		
        set(get(ch,'Label'),'String','压力脉动峰峰值(kPa)','FontSize',paperFontSize(),'FontName',paperFontName());
        box on;
		if isSaveFigure
			set(gca,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('直进侧出缓冲罐-长径比和偏置距离迭代云图(%g)',X(1,indexs(i))));
		end
	end
    
end
