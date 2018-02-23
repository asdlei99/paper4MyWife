function paperPlotDoubleVesselExpCmp(doubleVesselCombineDataCells,svCombineData,legendLabels,isSaveFigure)
%双罐实验对比
    vesselRegion = [13,16];
    if 0
        plotDoubleVesselExpPressurePlus(doubleVesselCombineDataCells,svCombineData,legendLabels,isSaveFigure,vesselRegion);
    end
    
    if 1
        plotDoubleVesselSuppressionRate(doubleVesselCombineDataCells,svCombineData,legendLabels,isSaveFigure,vesselRegion);
    end
end

function plotDoubleVesselExpPressurePlus(doubleVesselCombineDataCells,legendLabels,isSaveFigure,vesselRegion)
	errorType = 'ci';
    figure('Name','双罐实验');
    paperFigureSet('small',6);
	fh = figureExpPressurePlus(doubleVesselCombineDataCells,legendLabels...
        ,'errorType',errorType...
        ,'rang',1:15 ...
        ,'showPureVessel',false...
        ,'showVesselRegion',false...
        ,'errorPlotType','bar'...
        ,'showMeasurePoint',true...
        ,'isFigure',true...
        );
    plotVesselRegion(gca,vesselRegion);
    
end

function plotDoubleVesselSuppressionRate(doubleVesselCombineDataCells,svCombineData,legendLabels,isSaveFigure,vesselRegion)
    %计算脉动抑制率
    rang = 1:15;
    sr = {};
    svMeanPlus = getExpCombineReadedPlusData(svCombineData);
    for i = 1:length(doubleVesselCombineDataCells)
        readPlus = doubleVesselCombineDataCells.readPlus;
        sr{i} = (svMeanPlus - readPlus)./svMeanPlus;
    end
    %绘制脉动抑制率
    figure
    paperFigureSet('small',6);
    hold on;
    for i = 1:length(sr)
        vsr = sr{i};
        [ttmp,ttmp,muci,sigmaci] = normfit(vsr,0.05);
        clear ttmp;
        yUp = muci(2,rang).* 100;
        yDown = muci(1,rang).* 100;
        y = mean(vsr);
        y = y(rang).*100;
        x = constExpTwoVesselMeasurementPointDistance;
        [curHancle(i),fillHandle(i)] = plotWithError(x,y,yUp,yDown,'color',getPlotColor(i));
    end
end









