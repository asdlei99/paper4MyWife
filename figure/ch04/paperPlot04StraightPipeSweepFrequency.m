function paperPlot04StraightPipeSweepFrequency(sweepResult,isSavePlot)
	type = 'small';
	STFT.windowSectionPointNums = 512;
	STFT.noverlap = floor(STFT.windowSectionPointNums*3/4);
    STFT.nfft=2^nextpow2(STFT.windowSectionPointNums);
    Fs = 100;
    indexs = 1:13;
	if strcmpi(type,'large')
		plotLargePlot(sweepResult,isSavePlot,STFT,Fs,indexs);
	else
		plotSmallPlot(sweepResult,isSavePlot,STFT,Fs,indexs);
	end
	plotShadow(sweepResult,isSavePlot,STFT,Fs);
end

function plotShadow(sweepResult,isSavePlot,STFT,Fs)
	%频率投影和时间投影
    figHandle = figure;
    paperFigureSet('full',6);
    subplot(1,2,1)
    plotSweepFrequencyDistributionFre(sweepResult,Fs,'STFT',STFT...
        ,'charttype','contourf');%,'charttype','contourf'plot3
    title('(a)','FontSize',paperFontSize());
    set(gca,'color','none');
    
    %幅值投影
    subplot(1,2,2)
    plotSweepFrequencyDistributionAmp(sweepResult,Fs,'STFT',STFT...
        ,'charttype','contourf');%,'LevelStep',80,'ShowText','off','TextStep',60,'LineStyle','-'
    title('(b)','FontSize',paperFontSize());
    set(gca,'color','none');
    h = colorbar('Position',[0.919112096709723 0.147410714285715 0.031183034764756 0.771071428571429]);
    set(h,'YTick',[]);

	if isSavePlot
		saveFigure(fullfile(getPlotOutputPath(),'ch04'),'直管扫频分析-时间频率投影');
		close(figHandle);
	end
end

function plotLargePlot(sweepResult,isSavePlot,STFT,Fs,indexs)
	%扫频
    for index = indexs
        pressure = sweepResult(:,index);

		figHandle = figure;
		paperFigureSet('normal',7);
		plotSweepFrequency(pressure,Fs,'STFT',STFT);
		view(-45,48);
		xlabel('频率(Hz)','FontSize',paperFontSize());
		ylabel('时间(s)','FontSize',paperFontSize());
		zlabel('幅值','FontSize',paperFontSize());
		title(sprintf{'测点%d',index},'FontSize',paperFontSize());
		box on;
		if isSavePlot
			set(gca,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch04'),sprintf('直管扫频stft分析-测点%d',index));
			close(figHandle);
		end
    end
end

function plotSmallPlot(sweepResult,isSavePlot,STFT,Fs,indexs)
%扫频
    for index = indexs
        pressure = sweepResult(:,index);

		figHandle = figure;
		paperFigureSet('small',6);
		fh = plotSweepFrequency(pressure,Fs,'STFT',STFT);
        set(gca,'XTick',0:10:50);
		view(-35,36);
		xlabel('频率(Hz)','FontSize',paperFontSize());
		ylabel('时间(s)','FontSize',paperFontSize());
		zlabel('幅值','FontSize',paperFontSize());
		title(sprintf('测点%d',index),'FontSize',paperFontSize());
		box on;
		if isSavePlot
			set(gca,'color','none');
			saveFigure(fullfile(getPlotOutputPath(),'ch04'),sprintf('直管扫频stft分析-测点%d',index));
			close(figHandle);
		end
    end
end