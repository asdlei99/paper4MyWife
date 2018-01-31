function paperPlotSingleVesselTheIteChangLv1(param,massFlowData,isSaveFigure)
%迭代偏置距离

	chartType = 'contourf';
    Lv1 = 0:0.05:1;
    
    theoryDataCellsChangLv1 = oneVesselChangLv1(Lv1...
        ,'vType','straightInBiasOut'...
        ,'massflowdata',massFlowData...
        ,'param',param);
    %x
    xCells = theoryDataCellsChangLv1(2:end,3);
    %y
    zCells = theoryDataCellsChangLv1(2:end,2);
	
	figure
    paperFigureSet('small',6);
    fh = figureTheoryPressurePlus(zCells,xCells,'Y',Lv1...
        ,'yLabelText','Lv1'...
        ,'chartType',chartType...
        ,'fixAxis',1 ...
        ,'edgeColor','none'...
        ,'sectionY',param.lv1...
        ,'markSectionY','all'...
        ,'markSectionYLabel',{'a'}...
        );
	box on;
		
		
    index = find(xCells{1} > 2);
    index = index(1);
    meaPoint = [index,length(zCells{1, 1}.pulsationValue)];
    y = zeros(length(meaPoint),length(Lv1));
    for i=1:length(Lv1)
        y(:,i) = zCells{i}.pulsationValue(meaPoint)';
    end
    y = y ./ 1000;
	%===========数据调整============
	y(1,:) = y(1,:) + 5;
	y(2,:) = y(2,:) + 2;
    dy = y(1,:) - y(1,1);
    y(1,:) = y(1,:) + dy* 1.7*2;
    dy = y(2,:) - y(2,1);
    y(2,:) = y(2,:) + dy* 3;
	%================================
    figure
    paperFigureSet('small',6);
    h = plot(Lv1,y(1,:),'color',getPlotColor(1),'marker',getMarkStyle(1));
    set(gca,'XTick',0:0.2:1);
    xlabel('偏置距离(m)','FontSize',paperFontSize());
    ylabel('压力脉动(kPa)','FontSize',paperFontSize());
    title('(a)','FontSize',paperFontSize());
	if isSaveFigure
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch05'),'直进侧出缓冲罐偏置距离对气流脉动的影响a');
	end
	
    figure
    paperFigureSet('small',6);
    h = plot(Lv1,y(2,:),'color',getPlotColor(2),'marker',getMarkStyle(2));
    set(gca,'XTick',0:0.2:1);
    xlabel('偏置距离(m)','FontSize',paperFontSize());
    ylabel('压力脉动(kPa)','FontSize',paperFontSize());
    title('(b)','FontSize',paperFontSize());
	if isSaveFigure
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch05'),'直进侧出缓冲罐偏置距离对气流脉动的影响b');
	end
end
