function paperPlotSingleVesselExpResult(expCombineDataCells,legendLabels,legendLabelsAbb,isSaveFigure)
%绘制多组压力脉动
%实验数据最后一个测点的值

	vesselDiffLinkLastMeasureMeanValues13 = cellfun(@(x) mean(x.readPlus(:,13)),expCombineDataCells,'UniformOutput',1);
	vesselDiffLinkLastMeasureMeanValues13Up = vesselDiffLinkLastMeasureMeanValues13;
	vesselDiffLinkLastMeasureMeanValues13Down = vesselDiffLinkLastMeasureMeanValues13;
	
	vesselDiffLinkLastMeasureMeanValues1 = cellfun(@(x) mean(x.readPlus(:,1)),expCombineDataCells,'UniformOutput',1);
	vesselDiffLinkLastMeasureMeanValues1Up = vesselDiffLinkLastMeasureMeanValues1;
	vesselDiffLinkLastMeasureMeanValues1Down = vesselDiffLinkLastMeasureMeanValues1;
	
	for i=1:length(expCombineDataCells)
		[~,~,muci,sigmaci] = normfit(expCombineDataCells{i}.readPlus(:,13),0.05);
		vesselDiffLinkLastMeasureMeanValues13Up(i) = muci(2,1);
		vesselDiffLinkLastMeasureMeanValues13Down(i) = muci(1,1);
		
		[~,~,muci,sigmaci] = normfit(expCombineDataCells{i}.readPlus(:,1),0.05);
		vesselDiffLinkLastMeasureMeanValues1Up(i) = muci(2,1);
		vesselDiffLinkLastMeasureMeanValues1Down(i) = muci(1,1);
    end
    figure
    paperFigureSet('normal',9);
    fh = figureExpPressurePlus(expCombineDataCells...
			,'errorType','none'...
			,'showPureVessel',0 ...
			,'showVesselRegion',false...
            ,'isFigure',0);
	plotVesselRegion(gca,constExpVesselRangDistance);
	set(gca,'Position',[0.13 0.25 0.775 0.588235294117647]);
	set(fh.textboxMeasurePoint...
		,'Position',[0.474673928348722 0.883519199346406 0.0998000000000001 0.0911999999999999]);
	%测点1的圆
	annotation('ellipse',...
            [0.147927083333333 0.397765012254902 0.0519166666666667 0.17859375]);
    annotation('arrow',[0.1784140969163 0.215859030837004],...
        [0.579411764705882 0.623529411764706]);
	%最后测点的圆
    annotation('ellipse',...
        [0.846879145252081 0.674088541666667 0.0430972222222221 0.171979166666667]);
    annotation('arrow',[0.865638766519824 0.828193832599119],...
        [0.675567656765677 0.597058823529412]);
	
    
    set(gca,'color','none');
	baseAxis = gca;
    
	%新图层，测点1压降
    ax = axes('Parent',gcf...
            ,'Position',[0.254912047234461 0.588477328431373 0.22746680739109 0.220346200980392]...
            ,'color','w');
    box(ax,'on');
    err = [vesselDiffLinkLastMeasureMeanValues1'-vesselDiffLinkLastMeasureMeanValues1Down'...
        ,vesselDiffLinkLastMeasureMeanValues1Up'-vesselDiffLinkLastMeasureMeanValues1'];
    barHandle1 = barwitherr(err,vesselDiffLinkLastMeasureMeanValues1');
    set(barHandle1,'FaceColor',getPlotColor(2));
    set(ax,'XTickLabel',legendLabelsAbb);
    ylim([10,20]);
    xlim([0,length(legendLabels)+1]);
	m1Axis = gca;
	
	%新图层，末端测点压降
    ax = axes('Parent',gcf...
        ,'Position',[0.627577933798336 0.335294117647059 0.260087264439549 0.252084865196079]...
        ,'color','w');
    box(ax,'on');
    err = [vesselDiffLinkLastMeasureMeanValues13'-vesselDiffLinkLastMeasureMeanValues13Down'...
        ,vesselDiffLinkLastMeasureMeanValues13Up'-vesselDiffLinkLastMeasureMeanValues13'];
    barHandleEnd = barwitherr(err,vesselDiffLinkLastMeasureMeanValues13');
    ylim([30,40]);
    xlim([0,length(legendLabels)+1]);
    set(barHandleEnd,'FaceColor',getPlotColor(1));
    set(ax,'XTickLabel',legendLabelsAbb);
	mEndAxis = gca;
	
	%新图层
	legend1Axis = makePlotAxesLayout(baseAxis);
	lh = legend(legend1Axis,fh.plotHandle(1:2),legendLabels(1:2));
	set(lh...
		,'Position',[0.114170337738622 0.0230392156862745 0.363436123348018 0.123529411764706]...
		,'EdgeColor','none'...
	);

	%新图层
	legend2Axis = makePlotAxesLayout(baseAxis);
	lh = legend(legend2Axis,fh.plotHandle(3:4),legendLabels(3:4));
	set(lh...
		,'Position',[0.534875183553603 0.0230392156862745 0.330396475770925 0.123529411764706]...
		,'EdgeColor','none'...
	);
	
	annotation('rectangle',...
		[0.0969162995594714 0.0235294117647059 0.812775330396476 0.117647058823529],...
		'FaceColor','flat');
	
	%绘制框选图例的矩形
	
	if isSaveFigure
		saveFigure(fullfile(getPlotOutputPath(),'ch05'),'缓冲罐不同接法对管系气流脉动的影响');
	end
end
