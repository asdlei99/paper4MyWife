function paperPlotInnerPipeExpCmp(innerPipeDataCells,legendLabels,expVesselRang,isSaveFigure)
%?ð¤??Î·îÜ???Ýï
	errorType = 'ci';
	fh = figureExpPressurePlus(innerPipeDataCells,legendLabels,'errorType',errorType...
        ,'showPureVessel',1,'purevessellegend','?ìé??Î¸'...
        ,'expVesselRang',expVesselRang);
    set(fh.vesselHandle,'color','r');
    set(fh.textarrowVessel,'X',[0.391 0.341],'Y',[0.496 0.417]);
    set(fh.legend,'Position',[0.140376161350008 0.518142368996306 0.255763884946291 0.291041658781467]);
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch06'),'??Î·???Ýï');
	end
end