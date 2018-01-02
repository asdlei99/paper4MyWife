%% 第四章 绘图 - 直管

clear all;
close all;
clc;
baseField = 'rawData';
errorType = 'ci';
dataPath = getDataPath();
%% 数据路径
straightPipeDataPath = fullfile(dataPath,'实验原始数据\纯直管\RPM420-0.1MPa');%直管

%% 加载数据
[straightPipeDataCells,straightPipeCombineData] ...
    = loadExpDataFromFolder(straightPipeDataPath);


legendLabels = {'直管'};

%% 分析参数设置
%时频分析参数设置
Fs = 100;%实验采样率
STFT.windowSectionPointNums = 512;
STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
STFTChartType = 'contour';%contour|plot3
%% 绘图 
%% 绘制所有测点的时频分析
if 1
    chartType = 'plot3';
	rang = 1:13;
	titleLabel = {'a','b','c','d','e','f','g','h','i','j','k','l','m'};
	baseFre = 14;
	baseFre1Amp = [];
	baseFre1Time = [];
	baseFre2Amp = [];
	baseFre2Time = [];
	for i=rang
		figure
		paperFigureSet('small',6);
		pressure = straightPipeDataCells{:,i}.rawData.pressure;
		hold on;
		[fh,sd,mag] = plotSTFT(pressure,STFT,Fs,'isShowColorbar',0,'chartType',chartType);
		%查找1倍频和2倍频
		x1f = zeros(1,size(mag,1));
		y1f = x1f;
		z1f = x1f;
		x2f = x1f;
		y2f = x1f;
		z2f = x1f;
		for j = size(mag,1)
			[z1f(j),x1f(j),index] = closeLargeValue(sd.F,mag(:,j),baseFre,0.5);
			[z2f(j),x2f(j),index] = closeLargeValue(sd.F,mag(:,j),baseFre*2,0.5);
			y1f(j) = rang(j);
		end
		y2f = y1f;
		%标定1,2倍频
		h = plot3(x1f,y1f,z1f,'-.b');
		h = plot3(x2f,y2f,z2f,'-.b');
		baseFre1Amp(i,:) = z1f;
		baseFre2Amp(i,:) = z2f;
		baseFre1Time = sd.T;
		baseFre2Time = baseFre1Time;
		title(titleLabel{i},'FontName',paperFontName(),'FontSize',paperFontSize());
		xlabel('频率(Hz)','FontName',paperFontName(),'FontSize',paperFontSize()); 
		ylabel('时间(s)','FontName',paperFontName(),'FontSize',paperFontSize());
		zlabel('幅值','FontName',paperFontName(),'FontSize',paperFontSize());
		axis tight;
		box on;
		view(45,45);
	end
	%绘制倍频
	chartType = '2d';
	%绘制所有1倍频
	figure
	paperFigureSet('normal',6);
	if strcmpi(chartType,'2d')
		hold on;
		for i = 1:length(rang)
			h = plot(baseFre1Time,baseFre1Amp(i,:),'color',getPlotColor(i),'marker',getMarkStyle(i));
		end
		box on;
		xlabel('时间');
		ylabel('幅值');
	else
		hold on;
		for i = 1:length(rang)
			h = plotSpectrum3(baseFre1Time,baseFre1Amp(i,:),rang(i),'isFill',1,'color',[229,44,77]./255);
		end
		xlabel('时间');
		ylabel('测点');
		zlabel('幅值');
		axis tight;
		box on;
	end
	%绘制所有2倍频
	figure
	paperFigureSet('normal',6);
	if strcmpi(chartType,'2d')
		hold on;
		for i = 1:size(baseFre2Amp,1)
			h = plot(baseFre2Time,baseFre2Amp(i,:),'color',getPlotColor(i),'marker',getMarkStyle(i));
		end
		box on;
		xlabel('时间');
		ylabel('幅值');
	else
		hold on;
		for i = 1:length(rang)
			h = plotSpectrum3(baseFre2Time,baseFre2Amp(i,:),rang(i),'isFill',1,'color',[229,44,77]./255);
		end
		xlabel('时间');
		ylabel('测点');
		zlabel('幅值');
		axis tight;
		box on;
	end
	
	
    % dataNumIndex = 2;%读取的实验组数，<5
    % measurePoint = [1,3,5,7,9,13];%时频分析波形的测点
    % stftLabels = {};
    % for i = 1:length(measurePoint)
        % stftLabels{i} = sprintf('测点%d',measurePoint(i));
    % end
    % fh = figureExpPressureSTFT(getExpDataStruct(straightPipeDataCells,dataNumIndex,baseField),measurePoint,Fs...
        % ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        % ,'subplotRow',2,'figureHeight',10);
end

if 0
    dataNumIndex = 2;%读取的实验组数，<5
    measurePoint = [1,13];%时频分析波形的测点
    stftLabels = {};
    for i = 1:length(measurePoint)
        stftLabels{i} = sprintf('测点%d',measurePoint(i));
    end
    viewVal = [41,23];
    isShowColorBar = 0;
    fh = figureExpPressureSTFT(getExpDataStruct(straightPipeDataCells,dataNumIndex,baseField),measurePoint,Fs...
        ,stftLabels,'STFT',STFT,'chartType',STFTChartType...
        ,'subplotRow',1,'subplotcol',2,'figureHeight',6 ...
        ,'chartType','plot3'...
        ,'view',viewVal...
        ,'isShowColorBar',isShowColorBar...
        ,'simpleLabel',0 ...
    );
end
%绘制0.25D的压力脉动
%fh = figureExpPressurePlus(orificD01CombineData,'errorType',errorType,'showPureVessel',1);
%% 绘制多组压力脉动
if 0
    fh = figureExpPressurePlus(straightPipeCombineData...
        ,'errorType','ci'...
        ,'showPureVessel',0);
    % set(fh.legend,...
    %     'Position',[0.197702551027417 0.469635426128899 0.282222217491105 0.346163184982204]);
    % set(fh.textarrowVessel,'X',[0.230711805555556 0.294722222222223],'Y',[0.277213541666667 0.231744791666667]);
    % annotation(fh.gcf,'ellipse',...
    %     [0.857892361111112 0.674088541666667 0.0430972222222221 0.171979166666667]);
    % annotation(fh.gcf,'arrow',[0.865638766519824 0.814977973568282],...
    %     [0.675567656765677 0.564356435643564]);
    % ax = axes('Parent',fh.gcf...
    %     ,'Position',[0.618767361111111 0.257369791666667 0.275208333333337 0.29765625]...
    %     ,'color','w');
    % box(ax,'on');
    % err = [vesselDiffLinkLastMeasureMeanValues'-vesselDiffLinkLastMeasureMeanValuesDown'...
    %     ,vesselDiffLinkLastMeasureMeanValuesUp'-vesselDiffLinkLastMeasureMeanValues'];
    % barHandle = barwitherr(err,vesselDiffLinkLastMeasureMeanValues');
    % ylim([30,40]);
    % xlim([0,7]);
    % set(barHandle,'FaceColor',getPlotColor(1));
    % set(ax,'XTickLabel',legendLabelsAbb);
end

%对测点1进行时频分析波形
%fh = figureExpNatureFrequency(orificD01CombineData,'natureFre',[1,2],'showPureVessel',1);
%绘制1倍频的对比
%% 绘制倍频
if 0
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,1,legendLabels);
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,2,legendLabels);
    fh = figureExpNatureFrequencyBar(straightPipeCombineData,3,legendLabels);
end
