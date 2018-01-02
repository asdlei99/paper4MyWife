function d = paperPlot04StraightPipeSTFT(straightPipeDataCells,isSavePlot)
%绘制直管的时频分析波形
%% 分析参数设置
%时频分析参数设置
	if nargin < 2
		isSavePlot = 0;
	end
	Fs = 100;%实验采样率
	STFT.windowSectionPointNums = 512;
	STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
	STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
	STFTChartType = 'contour';%contour|plot3
	chartType = 'plot3';
	rang = 1:13;
	titleLabel = {'a','b','c','d','e','f','g','h','i','j','k','l','m'};
	baseFre = 14;
	baseFre1Amp = [];
	baseFre1Time = [];
	baseFre2Amp = [];
	baseFre2Time = [];
	count = 1;
	for i=rang
		figure
		paperFigureSet('small',6);
		pressure = straightPipeDataCells.pressure(:,i);
		hold on;
		[fh,sd,mag] = plotSTFT(pressure,STFT,Fs,'isShowColorbar',0,'chartType',chartType);
		%查找1倍频和2倍频
		x1f = zeros(1,size(mag,2));
		y1f = sd.T;
		z1f = x1f;
		x2f = x1f;
		y2f = sd.T;
		z2f = x1f;
		for j = size(mag,2)
			[z1f(j),x1f(j),index] = closeLargeValue(sd.F,mag(:,j),baseFre,0.5);
			[z2f(j),x2f(j),index] = closeLargeValue(sd.F,mag(:,j),baseFre*2,0.5);
        end
		%标定1,2倍频
		h = plot3(x1f,y1f,z1f,'-.b');
		h = plot3(x2f,y2f,z2f,'-.b');
		baseFre1Amp(count,:) = z1f;
		baseFre2Amp(count,:) = z2f;
		baseFre1Time = sd.T;
		baseFre2Time = baseFre1Time;
		title(titleLabel{i},'FontName',paperFontName(),'FontSize',paperFontSize());
		xlabel('频率(Hz)','FontName',paperFontName(),'FontSize',paperFontSize()); 
		ylabel('时间(s)','FontName',paperFontName(),'FontSize',paperFontSize());
		zlabel('幅值','FontName',paperFontName(),'FontSize',paperFontSize());
		axis tight;
		box on;
		view(45,45);
		d.sd{count} = sd;
		count = count + 1;
		if isSavePlot
			set(gca,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('直管时频分析-测点%d',i));
		end
	end
	d.baseFre1Amp = baseFre1Amp;
	d.baseFre2Amp = baseFre2Amp;
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
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('直管时频分析-测点1倍频'));
        close all;
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
	if isSavePlot
		set(gca,'color','none');
		saveFigure(fullfile(getPlotOutputPath(),'ch05'),sprintf('直管时频分析-测点2倍频'));
	end
end