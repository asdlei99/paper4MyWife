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
    paperFigureSet('normal',7);
    fh = figureExpPressurePlus(expCombineDataCells,legendLabels...
			,'errorType','none'...
			,'showPureVessel',0 ...
            ,'isFigure',0);
	annotation('ellipse',...
            [0.857892361111112 0.674088541666667 0.0430972222222221 0.171979166666667]);
    annotation('arrow',[0.865638766519824 0.814977973568282],...
        [0.675567656765677 0.564356435643564]);
    annotation('ellipse',...
        [0.147927083333333 0.356588541666667 0.0519166666666667 0.17859375]);
    annotation('arrow',[0.195434027777778 0.226302083333333],...
        [0.4911875 0.561640625]);
	
    if length(legendLabels) > 4
        set(fh.legend,...
            'Position',[0.197702551027417 0.469635426128899 0.282222217491105 0.346163184982204]);
        ax1Pos = [0.618767361111111 0.257369791666667 0.275208333333337 0.29765625];
        ax2Pos = [0.202048611111112 0.564947916666667 0.235920138888888 0.248046875];
    else
        set(fh.legend,...
            'Position',[0.305740746523221 0.579878478530376 0.317499994217523 0.23592013258073]);
        ax1Pos = [0.618767361111111 0.257369791666667 0.275208333333337 0.29765625];
        ax2Pos = [0.202048611111112 0.564947916666667 0.235920138888888 0.248046875];
    end
    set(fh.textarrowVessel,'X',[0.230711805555556 0.294722222222223],'Y',[0.277213541666667 0.231744791666667]);
    set(gca,'color','none');
    ax = axes('Parent',gcf...
        ,'Position',ax1Pos...
        ,'color','w');
    box(ax,'on');
    err = [vesselDiffLinkLastMeasureMeanValues13'-vesselDiffLinkLastMeasureMeanValues13Down'...
        ,vesselDiffLinkLastMeasureMeanValues13Up'-vesselDiffLinkLastMeasureMeanValues13'];
    barHandleEnd = barwitherr(err,vesselDiffLinkLastMeasureMeanValues13');
    ylim([30,40]);
    xlim([0,length(legendLabels)+1]);
    set(barHandleEnd,'FaceColor',getPlotColor(1));
    set(ax,'XTickLabel',legendLabelsAbb);
    
    ax = axes('Parent',gcf...
            ,'Position',ax2Pos...
            ,'color','w');
    box(ax,'on');
    err = [vesselDiffLinkLastMeasureMeanValues1'-vesselDiffLinkLastMeasureMeanValues1Down'...
        ,vesselDiffLinkLastMeasureMeanValues1Up'-vesselDiffLinkLastMeasureMeanValues1'];
    barHandle1 = barwitherr(err,vesselDiffLinkLastMeasureMeanValues1');
    set(barHandle1,'FaceColor',getPlotColor(2));
    set(ax,'XTickLabel',legendLabelsAbb);
    ylim([10,20]);
    xlim([0,length(legendLabels)+1]);
	if isSaveFigure
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch05'),'缓冲罐不同接法对管系气流脉动的影响');
	end
end
