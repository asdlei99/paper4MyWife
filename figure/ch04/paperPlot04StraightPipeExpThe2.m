function res = paperPlot04StraightPipeExpThe2(straightPipeCombineData,param,isSavePlot)
%绘制直管理论模拟实验
    rang = 1:13;
    if 1
        dataPath = getDataPath();
        res.num = xlsread(fullfile(dataPath,'直管理论实验数据-修改.xlsx'));
        xThe1 = res.num(:,1);
        yTheANor = res.num(:,2);
        xThe2 = res.num(:,3);
        yTheANew = res.num(:,4);
        xExp = res.num(:,5);
        yExp = res.num(:,6);
        xExp(isnan(xExp)) = [];
        yExp(isnan(yExp)) = [];
        [y,~,~,~,muci] = getExpCombineReadedPlusData(straightPipeCombineData);
        y = y(rang);
        yUp = muci(2,rang);
        yDown = muci(1,rang);
        
        figure
        paperFigureSet('small',6);
        hold on;
        plot(xThe1,yTheANor,'LineStyle','--','color',getPlotColor(1));
        plot(xThe2,yTheANew,'LineStyle','-','color',getPlotColor(2));
        [plotHandle,errFillHandle] = plotWithError(xExp',yExp',yUp,yDown...
                ,'color',getPlotColor(3)...
                ,'Marker','o'...
                ,'MarkerSize',2 ...
                ,'MarkerEdgeColor',getPlotColor(1)...
                ,'MarkerFaceColor',getPlotColor(1)...
                ,'type','bar');
        xlim([1,11])
        box on;
        ylabel('脉动压力峰峰值(kPa)');
        xlabel('管系距离(m)');
    else
        
        freRaw = [14,21,28,42,56,70];
        massFlowERaw = [0.23,0.00976,0.0915,0.00518,0.003351,0.00278];

        xExp = [2.5,3,4.78,5.28,5.78,6.28,7.53,8.03,8.53,9.05,9.53,10.03,10.53];
        param.acousticVelocity = 345;
        theoryDataCells = straightPipePulsation('param',param...
            ,'massflowdata',[freRaw;massFlowERaw]...
        );
        xThe = theoryDataCells{2,3};
        pulsationValue1 = theoryDataCells{2,4};
        pulsationValue1 = pulsationValue1 ./ 1000;

        param.acousticVelocity = 373;
        theoryDataCells = straightPipePulsation('param',param...
            ,'massflowdata',[freRaw;massFlowERaw]...
        );
        pulsationValue2 = theoryDataCells{2,4};
        pulsationValue2 = pulsationValue2 ./ 1000;
        res.thePulsationValue1 = pulsationValue1';
        res.thePulsationValue2 = pulsationValue2';
        res.theX = xThe';
        figure
        paperFigureSet('small',6);


        
        [y,~,~,~,muci] = getExpCombineReadedPlusData(straightPipeCombineData);
        y = y(rang);
        yUp = muci(2,rang);
        yDown = muci(1,rang);
        res.xExp = xExp';
        res.yExp = y';
        res.yExpUp = yUp';
        res.yExpDown = yDown';
        [plotHandle,errFillHandle] = plotWithError(xExp,y,yUp,yDown...
                ,'color',getPlotColor(1)...
                ,'LineStyle',getLineStyle(1)...
                ,'Marker','o'...
                ,'MarkerSize',2 ...
                ,'MarkerEdgeColor',getPlotColor(1)...
                ,'MarkerFaceColor',getPlotColor(1)...
                ,'type','bar');
        hold on;
        plot(xThe,pulsationValue1,'color',getPlotColor(2),'LineStyle','--');
        plot(xThe,pulsationValue2,'color',getPlotColor(3),'LineStyle',':');
        ylabel('脉动压力峰峰值(kPa)');
        xlabel('管系距离(m)');
        box on;
    
    end
    
% 	fh = figureExpAndSimThePressurePlus(straightPipeCombineData...
%                                 ,straightPipeSimData...
%                                 ,theDataStruct...
%                                 ,{''}...
%                                 ,'legendPrefixLegend',legnedText...
%                                 ,'showMeasurePoint',1 ...
%                                 ,'xsim',xSim,'xexp',xExp,'xThe',xThe...
%                                 ,'xlim',[2,12]...
%                                 ,'figureHeight',7 ...
%                                 ,'showVesselRigion',false);
	
	
end

