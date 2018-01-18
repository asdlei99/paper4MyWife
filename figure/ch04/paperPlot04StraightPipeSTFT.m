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
% 	STFTChartType = 'contour';%contour|plot3
	chartType = 'plot3';
	rang = 1:13;
% 	titleLabel = {'a','b','c','d','e','f','g','h','i','j','k','l','m'};
	baseFre = 14;
	baseFre1Amp = [];
	baseFre1Time = [];
	baseFre2Amp = [];
	baseFre2Time = [];
	count = 1;
	for i=rang
		figHandle = figure;
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
		for j = 1:size(mag,2)
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
		title(sprintf('测点%d',i),'FontName',paperFontName(),'FontSize',paperFontSize());
		xlabel('频率(Hz)','FontName',paperFontName(),'FontSize',paperFontSize()); 
		ylabel('时间(s)','FontName',paperFontName(),'FontSize',paperFontSize());
		zlabel('幅值','FontName',paperFontName(),'FontSize',paperFontSize());
		axis tight;
		box on;
		view(25,53);
		d.sd{count} = sd;
		count = count + 1;
		if isSavePlot
			set(gca,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch04'),sprintf('直管时频分析-测点%d',i));
			close(figHandle);
		end
        
	end
	d.baseFre1Amp = baseFre1Amp;
	d.baseFre2Amp = baseFre2Amp;
	%绘制倍频
	chartType = '2d';
	%绘制所有1倍频
	figHandle = figure;
	paperFigureSet('full',7);
    subplot(1,2,1)
	if strcmpi(chartType,'2d')
		hold on;
		for i = 1:length(rang)
			h(i) = plot(baseFre1Time,baseFre1Amp(i,:),'color',getPlotColor(i),'marker',getMarkStyle(i));  
        end
		box on;
        title('(a)','FontName',paperFontName(),'FontSize',paperFontSize());
		xlabel('时间','FontName',paperFontName(),'FontSize',paperFontSize());
		ylabel('幅值','FontName',paperFontName(),'FontSize',paperFontSize());
        set(gca,'Position',[0.079375 0.153459115673161 0.316107456140351 0.769811326490258]);
        set(gca,'color','none');
	else
		hold on;
		for i = 1:length(rang)
			h = plotSpectrum3(baseFre1Time,baseFre1Amp(i,:),rang(i),'isFill',1,'color',[229,44,77]./255);
		end
		xlabel('时间','FontName',paperFontName(),'FontSize',paperFontSize());
		ylabel('测点','FontName',paperFontName(),'FontSize',paperFontSize());
		zlabel('幅值','FontName',paperFontName(),'FontSize',paperFontSize());
		axis tight;
		box on;
	end

	%绘制所有2倍频
    subplot(1,2,2)
	if strcmpi(chartType,'2d')
		hold on;
        h = [];
        legendText = {};
		for i = 1:size(baseFre2Amp,1)
			h(i) = plot(baseFre2Time,baseFre2Amp(i,:),'color',getPlotColor(i),'marker',getMarkStyle(i));
            legendText{i} = sprintf('测点%d',rang(i));
		end
		box on;
        hl = legend(h,legendText,'FontSize',paperFontSize());
        title('(b)','FontName',paperFontName(),'FontSize',paperFontSize());
		xlabel('时间','FontName',paperFontName(),'FontSize',paperFontSize());
		ylabel('幅值','FontName',paperFontName(),'FontSize',paperFontSize());
        set(gca,'color','none');
        set(gca,'Position',[0.472072368421053 0.153459115673161 0.336995614035087 0.769811326490258]);
        set(hl,'Position',[0.842024855502713 0.0617361360058065 0.135076752684422 0.885724181454512]);
	else
		hold on;
		for i = 1:length(rang)
			h = plotSpectrum3(baseFre2Time,baseFre2Amp(i,:),rang(i),'isFill',1,'color',[229,44,77]./255);
		end
		xlabel('时间','FontName',paperFontName(),'FontSize',paperFontSize());
		ylabel('测点','FontName',paperFontName(),'FontSize',paperFontSize());
		zlabel('幅值','FontName',paperFontName(),'FontSize',paperFontSize());
		axis tight;
		box on;
	end
	if isSavePlot
		saveFigure(fullfile(getPlotOutPutPath(),'ch04'),sprintf('直管时频分析-测点1-2倍频'));
		close(figHandle);
	end
end