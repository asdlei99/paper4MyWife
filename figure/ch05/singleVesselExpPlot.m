%% 缓冲罐的绘制
function res = singleVesselExpPlot(CombineDataCells,cmpCombineData,legendLabels,varargin)
%要分析的CombineData
%要分析的DataCells
%作为抑制率分母的CombineData
%作为抑制率分母的DataCells
baseField = 'rawData';
errorType = 'ci';
legendLabelsAbb = {'A','B'};
pressureDropMeasureRang = [2,3];
pp = varargin;
leg = legendLabels;
errorTypeInExp = 'none';
plusValueSubplot = 0;
while length(pp)>=2
    prop =pp{1};
    val=pp{2};
    pp=pp(3:end);
    switch lower(prop)
        case 'errortypeinexp' %误差带的类型
        	errorTypeInExp = val;
        case 'plusvaluesubplot'% 此值为1时，脉动压力和脉动抑制率使用一张图subplot(1,2,1)的形式
            plusValueSubplot = val;
        case 'datacells'
            dataCells = val;
        otherwise
       		error('参数错误%s',prop);
    end
end
%% 实验直进侧前出

%% 分析参数设置
%时频分析参数设置
Fs = 100;%实验采样率
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
% STFTChartType = 'contour';%contour|plot3
STFTChartType = 'plot3';%contour|plot3
STFT.measurePoint = [1,3,5,7,9,13];%时频分析波形的测点
%% 绘图 
%% [1,3,5,7,9,13]测点的时频分析波形
if 0
    dataNumIndex = 2;%读取的实验组数，<5

    stftLabels = {};
    for i = 1:length(STFT.measurePoint)
        stftLabels{i} = sprintf('测点%d',STFT.measurePoint(i));
    end
    fh = figureExpPressureSTFT(getExpDataStruct(dataCells,dataNumIndex,baseField),STFT.measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',2,'figureHeight',10);
end
%绘制0.25D的压力脉动
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% 绘制多组压力脉动
if plusValueSubplot
    if 1
        figure
        paperFigureSet_large(6);
        subplot(1,2,1)
        vesselCombineDataCells = {CombineDataCells{:},cmpCombineData};
        fh = figureExpPressurePlus(vesselCombineDataCells,leg...
            ,'errorType',errorTypeInExp...
            ,'showPureVessel',0 ...
            ,'isFigure',0);
        set(fh.gca,'Position',[0.108928571428571 0.192 0.355730519480519 0.623]);
        set(fh.legend,'Position',[0.113451186148007 0.645228146480018 0.256513817294571 0.15637859689846]);
        set(fh.textboxMeasurePoint,'Position',[0.247544642857143 0.898 0.0997999999999998 0.0912000000000004]);
%         set(fh.textarrowVessel,'X',[0.230711805555556 0.294722222222223],'Y',[0.277213541666667 0.231744791666667]);
%         
        subplot(1,2,2)
        ddMean = mean(cmpCombineData.readPlus);
        ddMean = ddMean(1:13);
        suppressionRateBase = {ddMean};
        xlabelText = '管线距离(m)';
        ylabelText = '压力脉动抑制率(%)';

        fh = figureExpPressurePlusSuppressionRate(CombineDataCells...     
                ,'errorDrawType','bar'...
                ,'showVesselRigon',1 ...
                ,'suppressionRateBase',suppressionRateBase...
                ,'xIsMeasurePoint',0 ...
                ,'figureHeight',6 ...
                ,'xlabelText',xlabelText...
                ,'ylabelText',ylabelText...
                ,'isFigure',0 ...
                );
        xlim([2,11]);
        set(fh.gca,'Position',[0.570340909090909 0.192 0.373915043290043 0.623]);
        set(fh.textboxMeasurePoint,'Position',[0.731354166666669 0.898 0.0998000000000002 0.0912000000000003]);

    end
else
    if 1
        vesselCombineDataCells = {CombineDataCells{:},cmpCombineData};

        fh = figureExpPressurePlus(vesselCombineDataCells,leg...
            ,'errorType',errorTypeInExp...
            ,'showPureVessel',0);
        set(fh.legend,...
             'Position',[0.168290657927067 0.667473958333333 0.256448925406267 0.128921438212402]);
        set(fh.textarrowVessel,'X',[0.230711805555556 0.294722222222223],'Y',[0.277213541666667 0.231744791666667]);
    end
    if 1
        ddMean = mean(cmpCombineData.readPlus);
        ddMean = ddMean(1:13);
        suppressionRateBase = {ddMean};
        xlabelText = '管线距离(m)';
        ylabelText = '压力脉动抑制率(%)';

        fh = figureExpPressurePlusSuppressionRate(CombineDataCells...
                ,legendLabels(1:end-1)...        
                ,'errorDrawType','bar'...
                ,'showVesselRigon',0 ...
                ,'suppressionRateBase',suppressionRateBase...
                ,'xIsMeasurePoint',0 ...
                ,'figureHeight',6 ...
                ,'xlabelText',xlabelText...
                ,'ylabelText',ylabelText...
                );

    end
end

%% 绘制压力不均度
% if 1
%     vesselCombineDataCells = {CombineDataCells{:},cmpCombineData};
%     figure;
%     paperFigureSet_normal();
%     hold on;
%     rang = 1:13;
%     x = constExpMeasurementPointDistance();%测点对应的距离
%     for i = 1:length(vesselCombineDataCells)
%         [y,stdVal,maxVal,minVal,muci,sigmaci] = getExpCombinePressureBalanced(vesselCombineDataCells{i});
%         y = y(rang);
%         yUp = muci(2,rang);
%         yDown = muci(1,rang);
%         h = plotWithError(x,y,yUp,yDown,'color',getPlotColor(i)...
%             ,'Marker',getMarkStyle(i),'type','errbar');
%     end
% end
%绘制0.25D的压力脉动抑制率
% fh = figureExpSuppressionLevel(orificD0_25CombineData,'errorType',errorType...
%     ,'yfilterfunptr',@fixInnerOrificY ...
% );
%% 绘制多组压力脉动抑制率


%对测点1进行时频分析波形
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%绘制1倍频的对比
%% 绘制倍频
if 0
    fh = figureExpNatureFrequencyBar(CombineDataCells,1,legendLabels(1:end-1));
    fh = figureExpNatureFrequencyBar(CombineDataCells,2,legendLabels(1:end-1));
    fh = figureExpNatureFrequencyBar(CombineDataCells,3,legendLabels(1:end-1));
end
end