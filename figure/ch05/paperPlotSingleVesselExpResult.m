function paperPlotSingleVesselExpResult(expCombineDataCells,legendLabels,isSaveFigure)
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
	
	fh = figureExpPressurePlus(expCombineDataCells,legendLabels...
			,'errorType','none'...
			,'showPureVessel',0);
	set(fh.legend,...
        'Position',[0.197702551027417 0.469635426128899 0.282222217491105 0.346163184982204]);
    set(fh.textarrowVessel,'X',[0.230711805555556 0.294722222222223],'Y',[0.277213541666667 0.231744791666667]);
    annotation(fh.gcf,'ellipse',...
        [0.857892361111112 0.674088541666667 0.0430972222222221 0.171979166666667]);
    annotation(fh.gcf,'arrow',[0.865638766519824 0.814977973568282],...
        [0.675567656765677 0.564356435643564]);
    set(gca,'color','none');
    ax = axes('Parent',fh.gcf...
        ,'Position',[0.618767361111111 0.257369791666667 0.275208333333337 0.29765625]...
        ,'color','w');
    box(ax,'on');
    err = [vesselDiffLinkLastMeasureMeanValues13'-vesselDiffLinkLastMeasureMeanValues13Down'...
        ,vesselDiffLinkLastMeasureMeanValues13Up'-vesselDiffLinkLastMeasureMeanValues13'];
    barHandle = barwitherr(err,vesselDiffLinkLastMeasureMeanValues13');
    ylim([30,40]);
    xlim([0,7]);
    set(barHandle,'FaceColor',getPlotColor(1));
    set(ax,'XTickLabel',legendLabelsAbb);
	if isSaveFigure
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch05'),'缓冲罐不同接法对管系气流脉动的影响');
	end
end
