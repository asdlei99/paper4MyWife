function paperPlotSingleVesselTheIteBiasLengthAndAspectRatio(param,massFlowData,isSaveFigure)
%����ƫ�þ���ͳ�����

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
        xlabel('ƫ�þ���l1(m)','FontSize',paperFontSize());%l1����lv1
        ylabel('������','FontSize',paperFontSize());
        zlabel('ѹ���������ֵ(kPa)','FontSize',paperFontSize());
		
        ch = colorbar();
		set(gca,'Position',[0.1811 0.2043 0.6242 0.7207]...
						  ,'XTick',[0:0.25:1]...
						  );
		set(ch,'Position',[0.8381 0.2043 0.02804 0.7111]);
		
        set(get(ch,'Label'),'String','ѹ���������ֵ(kPa)','FontSize',paperFontSize(),'FontName',paperFontName());
        box on;
		if isSaveFigure
			set(gca,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('ֱ����������-�����Ⱥ�ƫ�þ��������ͼ(%g)',X(1,indexs(i))));
		end
	end
    
end
